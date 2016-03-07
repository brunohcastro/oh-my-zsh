name             'oh-my-zsh'
maintainer       'Bruno Henrique de Castro'
maintainer_email 'brunohcastro@gmail.com'
license          'MIT'
description      'Installs/Configures oh-my-zsh'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe           'oh-my-zsh::default', 'Installs for main user or defined users.'
recipe           'oh-my-zsh::all-users', 'Installs for all users.'

depends          'git'
depends          'zsh'

%w( ubuntu debian mac_os_x centos redhat fedora ).each do |os|
  supports os
end