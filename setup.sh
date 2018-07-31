## Brew
[ ! `which brew` ] && /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" <<< ''

[ ! `shopt -q globstar` ] && brew update && brew install bash

# make sure the new bash is configured correctly
[ ! $(cat /etc/shells  | grep `which bash`) ] && sudo -- sh -c "echo `which bash` >> /etc/shells" && chsh -s `which bash`

# find all dotfiles in this directory and copy to home
find . -maxdepth 1 -type f -iname '.*' -exec cp -i {} ~/ \;

## Hammerspoon specific

# installation
HAMMERSPOON_VERSION=0.9.70
[ ! -d /Applications/Hammerspoon.app ] && cd /Applications && curl -L https://github.com/Hammerspoon/hammerspoon/releases/download/$HAMMERSPOON_VERSION/Hammerspoon-$HAMMERSPOON_VERSION.zip -o hammerspoon.zip && unzip -o hammerspoon.zip && rm hammerspoon.zip

# configuration files
[ ! -d ~/.hammerspoon ] && mkdir ~/.hammerspoon
find .hammerspoon -maxdepth 1 -type f -iname '*.lua' -exec cp -i {} ~/.hammerspoon \;

## VIM Specific

# get vim plugin manager if it doesn't exist
[ ! -f ~/.vim/autoload/plug.vim ] && curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# copy molokai colorscheme for vim if it doesn't exist
[ ! -f ~/.vim/colors/molokai.vim ] && curl -fLo ~/.vim/colors/molokai.vim --create-dirs https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim 

# install vim plugins
vim -c PlugInstall -c ':q' -c ':q'

# install z
[ ! -f ~/github/rupa/z/z.sh ] && mkdir -p ~/github/rupa && cd ~/github/rupa && git clone https://github.com/rupa/z.git
