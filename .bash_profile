export HTTP_CLIENT="curl --insecure -f -L -o"

alias grepc="grep --color=always"
alias diff="diff --suppress-common-lines -y"

# Color LS
colorflag="-G"
alias ls="command ls ${colorflag}"
alias l="ls -lF ${colorflag}" # all files, in long format
alias la="ls -laF ${colorflag}" # all files inc dotfiles, in long format
alias lsd='ls -lF ${colorflag} | grep "^d"' # only directories

# Quicker navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Git
gdn() {
  if [ -z "$1" ];
  then
	  BRANCH="origin/master"
  else
	  BRANCH="$1"
  fi

  echo "**files with modified content between $(git branch | awk '/^\*/{print $2}') and $BRANCH"
  git diff --name-only $(git branch | awk '/^\*/{print $2}') $BRANCH
}

gd() {
  if [ -z "$1" ];
  then
	  BRANCH="origin/master"
  else
	  BRANCH="$1"
  fi

  echo "**content diff between $(git branch | awk '/^\*/{print $2}') and $BRANCH"
  git diff $(git branch | awk '/^\*/{print $2}') $BRANCH $1
}

alias gitc="git ls-files | xargs -I {} echo 'git blame {} ' | awk '{print \$2,\$3}' | sort | uniq -c | sort -n -k 1 -r | head -n 1 ' | bash"
alias gco="git checkout"
alias gl="git log"
alias gb="git branch -vv"
alias gm="git merge --no-ff"
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m' # requires you to type a commit message
alias gp='git pull'

# list remote branches
alias gr="git for-each-ref --format='%(committerdate) %09 %(authorname) %09 %(refname)' | sort -k5n -k2M -k3n -k4n "

### Prompt Colors
if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
	export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
	export TERM=xterm-256color
fi

if tput setaf 1 &> /dev/null; then
	tput sgr0
	if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
		BLACK=$(tput setaf 190)
		MAGENTA=$(tput setaf 9)
		ORANGE=$(tput setaf 172)
		GREEN=$(tput setaf 190)
		PURPLE=$(tput setaf 141)
		WHITE=$(tput setaf 0)
	else
		BLACK=$(tput setaf 190)
		MAGENTA=$(tput setaf 5)
		ORANGE=$(tput setaf 4)
		GREEN=$(tput setaf 2)
		PURPLE=$(tput setaf 1)
		WHITE=$(tput setaf 7)
	fi
	BOLD=$(tput bold)
	RESET=$(tput sgr0)
else
	BLACK="\033[01;30m"
	MAGENTA="\033[1;31m"
	ORANGE="\033[1;33m"
	GREEN="\033[1;32m"
	PURPLE="\033[1;35m"
	WHITE="\033[1;37m"
	BOLD=""
	RESET="\033[m"
fi

export BLACK
export MAGENTA
export ORANGE
export GREEN
export PURPLE
export WHITE
export BOLD
export RESET

function parse_git_branch() {
	GIT_STATUS="$(git status 2> /dev/null)"
	if [[ -n $GIT_STATUS ]]; then
		BRANCH=`head -n1 <<<"$GIT_STATUS" | awk '{print $3;}'`
		if [[ $(head -n2 <<<"$GIT_STATUS" | tail -n1) != *"Your branch is up-to-date"* ]]; then
			BRANCH_DIRTY="*"
		fi
    	PROMPT=": on $PURPLE $BRANCH$BRANCH_DIRTY"
	fi
	echo $PROMPT
}

function prompt {
	PS1="_$ "
	echo "${ORANGE}($(date +%r)) ${BOLD}${MAGENTA}$(whoami) ${WHITE}in ${GREEN}$(pwd) ${WHITE}$(parse_git_branch)${RESET}"
}
PROMPT_COMMAND='prompt'


## SMARTER TAB-COMPLETION (Readline bindings) ##

# Perform file completion in a case insensitive fashion
bind "set completion-ignore-case on"

# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"

# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"

## SANE HISTORY DEFAULTS ##

# share history across terminals
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Ignore some history
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history"

# clean docker images
alias cdi="docker volume rm `docker volume ls -qf dangling=true`"

# Useful timestamp format
HISTTIMEFORMAT='%F %T '

# vi mode
set -o vi
# Prepend cd to directory names automatically
shopt -s autocd
# Correct spelling errors during tab-completion
shopt -s dirspell
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell
# Allow lazy expansion using **, eg `cd **/html5` -> /development/stuff/more_stuff/html5 when called from in the development directory
shopt -s globstar

# GIT search for recent updates made by a user:
function fta() {
	# find filetype and all most recent commits filtered by user
	FILETYPE=$1
	USER=$2
	echo "Searching through all recent commits of filetype:*$FILETYPE for user:$USER . . ."
	find . -iname "*.$FILETYPE" | xargs -I {} bash -c 'git log -n 1 --pretty=format:"{}, %an, %ad" -- {} | grep -i $USER'
}

