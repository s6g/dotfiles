# find all dotfiles in this directory and copy to home
find . -maxdepth 1 -type f -iname '.*' -exec cp -i {} ~/ \;

## VIM Specific

# get vim plugin manager if it doesn't exist
[ ! -f ~/.vim/autoload/plug.vim ] && curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# copy molokai colorscheme for vim if it doesn't exist
[ ! -f ~/.vim/colors/molokai.vim ] && curl -fLo ~/.vim/colors/molokai.vim --create-dirs https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim 

# install vim plugins
vim -c PlugInstall -c ':q' -c ':q'