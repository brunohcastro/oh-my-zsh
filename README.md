oh-my-zsh Cookbook
==================
This is my first cookbook, so bear with me a little there. This is also my first open source piece of code! Urray for that!

This cookbook was part of my process of learning how to cook chef, and a good starting point to learn ruby too, so there is much room for improvement. It is meant to setup oh-my-zsh and provides two recipes to accomplish that.

- The `::default` recipe will install oh-my-zsh for all users defined in `node['oh-my-zsh']['users']` (an example of using this node is presented below) or, if the node is empty, it will install for the user that called the chef-client (the recipe tries to bypass the root user if using sudo by getting the owner and group of the dir in the ENV['HOME'] variable).

- The `::all-users` recipe will install oh-my-zsh for all users in the system. For that I had to do some plumbing using shell commands and ruby and don't know if it's a good practice or not. For Mac OS X it works by calling `dscacheutil -q user` and identifying the users with uid higher than 500. For linux systems it works by reading the `node['etc']['passwd']` and ignoring any user with the uid lower than 1000, as well as the nobody user (uid 65534).


Requirements
------------
This cookbook is intended to be used in UNIX based systems. I'm currently using oh-my-zsh in Windows through cygwin's `mintty`, i just need to learn a little more about chef to apply it to this cookbook, but it's definitely an milestone for this project.

The current dependencies for this cookbook are:

####cookbooks

- `zsh` - to install zsh binary.
- `git` - as we need to clone several git projects (`oh-my-zsh` and the themes and plugins).

####binaries

- `chsh` - to change the user's shell to zsh.

Attributes
----------
Thera are several customiztion options, and these are just the ones I came up while learning how to cook chef. I'm sure i will add more customization options and support for the `users` cookbook data bags.

#### oh-my-zsh
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <th colspan=4>General</th>
  </tr>
  <tr>
    <td><tt>['oh-my-zsh']['git']['url']</tt></td>
    <td>String</td>
    <td>URL to the `oh-my-zsh` git repo</td>
    <td><tt><a href='https://github.com/robbyrussell/oh-my-zsh.git'>oh-my-zsh</a></tt></td>
  </tr>
  <tr>
    <td><tt>['oh-my-zsh']['git']['reference']</tt></td>
    <td>String</td>
    <td>Which reference to clone in the git repo</td>
    <td><tt>master</tt></td>
  </tr>
  <tr>
    <td><tt>['oh-my-zsh']['git']['action']</tt></td>
    <td>String</td>
    <td>Choose between checkout, sync, export or nothing</td>
    <td><tt>checkout</tt></td>
  </tr>
  <tr>
    <td><tt>['oh-my-zsh']['dirname']</tt></td>
    <td>String</td>
    <td>Name of the intallation directory</td>
    <td><tt>.oh-my-zsh</tt></td>
  </tr>
  <tr>
    <th colspan=4>Theming</th>
  </tr>
  <tr>
    <td><tt>['oh-my-zsh']['custom-themes']</tt></td>
    <td>Array of Hashsets</td>
    <td>The themes to install</td>
    <td><tt>powerlevel9k</tt> and <tt>honukai</tt></td>
  </tr>
  <tr>
    <td><tt>['oh-my-zsh']['theme']</tt></td>
    <td>String</td>
    <td>Default theme</td>
    <td><tt>powerlevel9k/powerlevel9k</tt></td>
  </tr>
  <tr>
    <td><tt>['oh-my-zsh']['theme-backup']</tt></td>
    <td>String</td>
    <td>A backup theme to use when your terminal doesn't support 256 colors</td>
    <td><tt>robbyrussel</tt></td>
  </tr>
  <tr>
    <th colspan=4>Plugins</th>
  </tr>
  <tr>
    <td><tt>['oh-my-zsh']['custom-plugins']</tt></td>
    <td>Array of Hashsets</td>
    <td>Plugins to install</td>
    <td><tt>empty</tt></td>
  </tr>
  <tr>
    <td><tt>['oh-my-zsh']['plugins']</tt></td>
    <td>String</td>
    <td>Active plugins</td>
    <td><tt>(git)</tt></td>
  </tr>
  <tr>
    <th colspan=4>Customization</th>
  </tr>
  <tr>
    <td><tt>['oh-my-zsh']['aliases']</tt></td>
    <td>Hashset</td>
    <td>Aliases to install</td>
    <td><tt>empty</tt></td>
  </tr>
  <tr>
    <td><tt>['oh-my-zsh']['sources']</tt></td>
    <td>Array</td>
    <td>Source files to add</td>
    <td><tt>empty</tt></td>
  </tr>
  <tr>
    <th colspan=4>Users</th>
  </tr>
  <tr>
    <td><tt>['oh-my-zsh']['users']</tt></td>
    <td>Array of Hashsets</td>
    <td>Users to install oh-my-zsh</td>
    <td><tt>empty</tt></td>
  </tr>
</table>

Usage
-----

#### oh-my-zsh::default
If you just include this recipe to your runlist, it will install oh-my-zsh for the user who called the chef-client using all the defaults. You can define the users and the other parameters above. Here is a sample of the user definition.

```
default['oh-my-zsh']['users'] = [
  {'name' => 'testuser',
  'gid' => 'staff',
  'dir' => '/Users/Testuser',
  'theme' => 'bullet-train/bullet-train',
  'theme-backup' => 'robbyrussell',
  'plugins' => '(git osx)',
  'custom-themes' => [{
    'name' => 'powerlevel9k', 
    'git' => 'https://github.com/bhilburn/powerlevel9k.git', 
    'reference' => 'master', 
    'config' => {
      'POWERLEVEL9K_LEFT_PROMPT_ELEMENTS' => '(root_indicator time context dir vcs)',
      'POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS' => '(status rbenv)',
      'POWERLEVEL9K_STATUS_VERBOSE' => 'false',
      'POWERLEVEL9K_SHORTEN_STRATEGY' => 'truncate_middle',
      'POWERLEVEL9K_SHORTEN_DIR_LENGTH' => '3'}},
    {'name' => 'bullet-train', 'git' => 'https://github.com/caiogondim/bullet-train-oh-my-zsh-theme.git', 'reference' => 'master'},
    {'name' => 'honukai', 'git' => 'https://github.com/oskarkrawczyk/honukai-iterm-zsh.git', 'reference' => 'master'}
  ],
  'custom-plugins' => [{'name' => 'some-plugin', 'git' => 'plugin.git.repo', 'reference' => 'master'},
  ],
  'aliases' => {
    'test' => 'echo "Test"'
  },
  'sources' => [
    '~/.profile',
    '~/.myawesomedotfile'
  ]}
]
```

Contributing
------------

I will be glad to have your contribution! The steps are the usual:

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Submit a Pull Request using Github!

License and Authors
-------------------
This cookbook is released under the MIT license.

Copyright (c) 2016 Bruno Henrique de Castro - brunohcastro@gmail.com