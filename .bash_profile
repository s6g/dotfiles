export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

set -o vi
export WORKON_HOME=~/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
# create new venv
# mkvirtualenv --python=`which python3` myenv

alias gs='git status'
alias gb='git branch'
alias gco='git checkout'
alias gp='git pull'
