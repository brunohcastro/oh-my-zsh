#
# Cookbook Name:: oh-my-zsh
# Recipe:: default
#
# Copyright 2016, Bruno Henrique de Castro
#
# Released under the MIT license.
#
include_recipe "git"
include_recipe "zsh"

if node['oh-my-zsh']['users'].nil? || node['oh-my-zsh']['users'].empty?
	node.default['oh-my-zsh']['users'] = [{
	  'name' => `ls -ld #{ENV['HOME']} | awk '{print $3}'`.strip,
	  'gid' => `ls -ld #{ENV['HOME']} | awk '{print $4}'`.strip,
	  'dir' => ENV['HOME'],
	  'shell' => ENV['SHELL']
	}]
end

node['oh-my-zsh']['users'].each do |user|
	
	script "Define zsh as default shell" do
		interpreter "bash"
		code <<-EOS
			chsh -s /bin/zsh #{user['name']}
		EOS
		not_if { user['shell'] == '/bin/zsh' }
	end

	git "#{user['dir']}/#{node['oh-my-zsh']['dirname']}" do
		repository node['oh-my-zsh']['git']['url']
		reference node['oh-my-zsh']['git']['reference']
		user user['name']
		group user['gid']
		action node['oh-my-zsh']['git']['action'].to_sym
	end

	directory "#{user['dir']}/#{node['oh-my-zsh']['dirname']}/custom/themes" do
		owner user['name']
		group user['gid']
		mode 0755
		action :create
	end	

	directory "#{user['dir']}/#{node['oh-my-zsh']['dirname']}/custom/lib" do
		owner user['name']
		group user['gid']
		mode 0755
		action :create
	end	

	themes = user['custom-themes'] || node['oh-my-zsh']['custom-themes']

	themes.each do |theme|
		git "#{user['dir']}/#{node['oh-my-zsh']['dirname']}/custom/themes/#{theme['name']}" do
			repository theme['git']
			reference theme['reference']
			user user['name']
			group user['gid']
			action :checkout
		end

		template "#{user['dir']}/#{node['oh-my-zsh']['dirname']}/custom/#{theme['name']}-conf.zsh" do
			source "theme-conf.zsh.erb"
			owner user['name']
			group user['gid']
			mode 0644
			variables({
				:theme => theme['name'],
				:config => theme['config']
			})
			not_if { theme['config'].nil? || theme['config'].empty? }
		end
	end

	plugins = user['custom-plugins'] || node['oh-my-zsh']['custom-plugins']

	plugins.each do |plugin|
		git "#{user['dir']}/#{node['oh-my-zsh']['dirname']}/custom/plugins/#{plugin['name']}" do
			repository plugin['git']
			reference plugin['reference']
			user user['name']
			group user['gid']
			action :sync
		end

		template "#{user['dir']}/#{node['oh-my-zsh']['dirname']}/custom/#{plugin['name']}-conf.zsh" do
			source "plugin-conf.zsh.erb"
			owner user['name']
			group user['gid']
			mode 0644
			variables({
				:plugin => plugin['name'],
				:config => plugin['config']
			})
			not_if { plugin['config'].nil? || plugin['config'].empty? }
		end
	end

	template "#{user['dir']}/.zshrc" do
		source "dot.zshrc.erb"
		owner user['name']
		group user['gid']
		mode 0644
		variables({ 
			:home => user['dir'],
			:user => user['name'],
			:theme => user['theme'] || node['oh-my-zsh']['theme'],
			:theme_backup => user['theme-backup'] || node['oh-my-zsh']['theme-backup'],
			:plugins => user['plugins'] || node['oh-my-zsh']['plugins'],
		})
		action :create_if_missing
	end

	template "#{user['dir']}/#{node['oh-my-zsh']['dirname']}/custom/aliases.zsh" do
	 	source "aliases.zsh.erb"
		owner user['name']
		group user['gid']
		mode 0644
		variables({
			:aliases => user['aliases'] || node['oh-my-zsh']['aliases']
		})
		not_if { (user['aliases'].nil? || user['aliases'].empty?) && node['oh-my-zsh']['aliases'].empty? }
	end

		template "#{user['dir']}/#{node['oh-my-zsh']['dirname']}/custom/sources.zsh" do
	 	source "sources.zsh.erb"
		owner user['name']
		group user['gid']
		mode 0644
		variables({
			:sources => user['sources'] || node['oh-my-zsh']['sources']
		})
		not_if { (user['sources'].nil? || user['sources'].empty?) && node['oh-my-zsh']['sources'].empty? }
	end 

end
