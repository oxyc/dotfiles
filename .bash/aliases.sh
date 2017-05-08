#!/bin/bash

# New commands
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"
alias ll="ls -lah" # exa overrides if available
alias lsd="ls -la | grep '^d'"
alias clean="find . -regex '.*\(.AppleDouble\|.DS_Store\)$' -ls -exec rm -r {} \;"

# Rewrites
alias df="df -h"
alias du="du -hc"
alias ping="ping -c 5"
alias vi="vim"
command -v xdg-open >/dev/null && alias open="xdg-open" # Install https://github.com/Cloudef/PKGBUILDS/tree/master/linopen
alias grep='grep --color=auto'

# Shortcuts
command -v git >/dev/null && alias g="git"
command -v exa >/dev/null && {
  alias l="exa"
  alias ll="exa -la"
}

# Download mutt attachments into downloads folder
command -v mutt >/dev/null && alias mutt="cd ~/downloads/mutt && mutt && cd -"

# Enable mouse over mosh
# https://github.com/keithw/mosh/issues/101#issuecomment-12317162
command -v mosh >/dev/null && alias mosh="perl -E ' print \"\e[?1005h\e[?1002h\" '; mosh"

# Fasd shortcuts
command -v fasd >/dev/null && {
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
fi

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# List 10 biggest files in pwd.
alias bf="du -x | sort -nr | head -10"

# URL-encode strings
# https://github.com/mathiasbynens/dotfiles/blob/master/.aliases
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

alias chromekill="ps aux | grep '[c]hrome --type=renderer' |  grep -v 'extension-process' | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# Make HTTP requests
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$method"="lwp-request -m '$method'"
done
unset method
