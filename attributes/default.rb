default['oh-my-zsh']['git']['url'] = 'https://github.com/robbyrussell/oh-my-zsh.git'
default['oh-my-zsh']['git']['reference'] = 'master'
default['oh-my-zsh']['git']['action'] = 'checkout'

default['oh-my-zsh']['dirname'] = '.oh-my-zsh'

default['oh-my-zsh']['custom-themes'] = [
  {'name' => 'powerlevel9k', 'git' => 'https://github.com/bhilburn/powerlevel9k.git', 'reference' => 'master', 
    'config' => {
      'POWERLEVEL9K_LEFT_PROMPT_ELEMENTS' => '(root_indicator time context dir vcs)',
      'POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS' => '(status rbenv)',
      'POWERLEVEL9K_STATUS_VERBOSE' => 'false',
      'POWERLEVEL9K_SHORTEN_STRATEGY' => 'truncate_middle',
      'POWERLEVEL9K_SHORTEN_DIR_LENGTH' => '3'
    }
  },
  {'name' => 'honukai', 'git' => 'https://github.com/oskarkrawczyk/honukai-iterm-zsh.git', 'reference' => 'master'}
]

default['oh-my-zsh']['theme'] = 'powerlevel9k/powerlevel9k'
default['oh-my-zsh']['theme-backup'] = 'robbyrussell'

default['oh-my-zsh']['custom-plugins'] = []

default['oh-my-zsh']['plugins'] = '(git)'

default['oh-my-zsh']['aliases'] = {
  'zshconfig' => 'nano ~/.zshrc',
  'ohmyzsh' => 'cd ~/.oh-my-zsh'
}

default['oh-my-zsh']['sources'] = []

default['oh-my-zsh']['users'] = []