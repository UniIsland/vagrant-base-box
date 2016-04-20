#!/bin/bash

## must not run as root
if [ "$(id -u)" == "0" ]; then
   echo "This script must be run as normal user" >&2
   exit 1
fi

cd "$HOME"
mkdir lib

# setup zsh
ZSH=$HOME/lib/oh-my-zsh
ZSH_CUSTOM=$HOME/lib/oh-my-zsh_custom
mkdir -p $ZSH_CUSTOM/themes
git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $ZSH
curl -Lo $ZSH_CUSTOM/themes/t1.zsh-theme \
  'https://github.com/UniIsland/production-ready/raw/master/fork/oh-my-zsh/custom/themes/t1.zsh-theme'
cat > ~/.zshrc <<"EOF"
ZSH=$HOME/lib/oh-my-zsh
ZSH_CUSTOM=$HOME/lib/oh-my-zsh_custom
ZSH_THEME="t1"
CASE_SENSITIVE="true"
DISABLE_CORRECTION="true"
HIST_STAMPS="yyyy-mm-dd"
plugins=(bundler colored-man common-aliases debian gem git rails screen)
source $ZSH/oh-my-zsh.sh

eval "$(rbenv init - zsh)"

[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
EOF
. ./.zshrc

# setup rbenv
mkdir -p ~/.rbenv ~/lib/rbenv_plugins
ln -s ~/lib/rbenv_plugins ~/.rbenv/plugins
git clone --depth=1 https://github.com/sstephenson/rbenv-gem-rehash.git ~/lib/rbenv_plugins/rbenv-gem-rehash
git clone --depth=1 https://github.com/sstephenson/rbenv-vars.git ~/lib/rbenv_plugins/rbenv-vars
git clone --depth=1 https://github.com/sstephenson/ruby-build.git ~/lib/rbenv_plugins/ruby-build
# rbenv install "$(rbenv local)"
# rbenv rehash

# setup other user config
cat > ~/.gemrc <<EOF
---
:backtrace: false
:verbose: true
gem: --no-document
EOF


## in the project repo
cd /vagrant
# install ruby
rbenv install $(rbenv local)
rbenv rehash
# install bundler
gem install bundler
# clear gem cache
gem sources -c
gem cleanup -V


# setup global ruby version
cd
rbenv global $(rbenv versions | tail -n 1)
