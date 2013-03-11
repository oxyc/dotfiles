#!/bin/bash

# New commands
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"
alias ll="ls -lah"
alias lsd="ls -la | grep '^d'"
alias clean="rm -f *~"

# Rewrites
alias df="df -h"
alias du="du -hc"
alias ping="ping -c 5"
alias vi="vim"
alias open="xdg-open" # Install https://github.com/Cloudef/PKGBUILDS/tree/master/linopen

# Shortcuts
alias g="git"
alias v="vim"
have todo.sh && alias t="todo.sh -d ~/.todo.cfg"
have ls++ && alias l="ls++"

# Download mutt attachments into downloads folder
have mutt && alias mutt="cd ~/downloads/mutt && mutt && cd -"

# Place scrot files in specified directory
have scrot && alias scrot="scrot ~/pictures/screenshots/%Y-%m-%d_%H%M%S.png"

# Git shortcuts
alias ga="git add"
alias gp="git push"
alias gpa="gp --all"
alias gu="git pull"
alias gl="git log"
alias gg="gl --decorate --oneline --graph --date-order --all"
alias gs="git status"
alias gd="git diff"
alias gdc="gd --cached"
alias gm="git commit -m"
alias gma="git commit -am"
alias gb="git branch"
alias gba="git branch -a"
function gc() { git checkout "${@:-master}"; } # Checkout master by default
alias gcb="gc -b"

# Fasd shortcuts
have && {
  alias o="fasd -f -e xdg-open"
  alias oo="fasd -fi -e xdg-open"
  alias z="fasd_cd -d"
  alias zz="fasd_cd -d -i"
  alias v="fasd -f -e vim"
  alias vv="fasd -fi -e vim"
}

# Enable aliases to be sudo’ed
alias sudo="sudo "

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls="ls --color=auto"
  alias grep="grep --color=auto"
  alias fgrep="fgrep --color=auto"
  alias egrep="egrep --color=auto"
fi

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# List 10 biggest files in pwd.
alias bf="du -x | sort -nr | head -10"

# URL-encode strings
# https://github.com/mathiasbynens/dotfiles/blob/master/.aliases
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# http://dotfiles.org/~ghost1227/.bashrc
alias meminfo="echo -e '/proc/meminfo:\n';grep --color=auto '^[Mem|Swap]*[Free|Total]*:' /proc/meminfo && echo -e '\nfree -m:'; free -m"

# Make HTTP requests
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$method"="lwp-request -m '$method'"
done
unset method
