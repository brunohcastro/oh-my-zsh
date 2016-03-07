#
# Cookbook Name:: oh-my-zsh
# Recipe:: all-users
#
# Copyright 2016, Bruno Henrique de Castro
#
# Released under the MIT license.
#
case node['platform']
when 'mac_os_x'

	node.default['oh-my-zsh']['users'] = `dscacheutil -q user | grep -A 3 -B 2 -e uid:\\ '[5-9][0-9][0-9]'`.split(/\n-{0,2}\n-{0,2}/).map! { |user|
	  user = Hash[user.split("\n").reject { |c| c.empty? }.map { |data| data.split(': ') }]
	  user.delete_if {|k,v| k == 'password' }
	  user.each { |k,v|
	    if k == 'gid' || k == 'uid'
	      user[k] = v.to_i
	    end
	  }
	}

else
	node['etc']['passwd'].each { |user, data|
		if data['uid'].to_i >= 1000 && data['uid'].to_i != 65534
			node.default['oh-my-zsh']['users'] << {'name' => user, 'uid' => data['uid'].to_i, 'gid' => data['gid'].to_i, 'dir' => data['dir'], 'shell' => data['shell']}
		end
	}
	
end

include_recipe 'oh-my-zsh::default'