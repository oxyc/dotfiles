#!/usr/bin/env bash

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
command -v cap >/dev/null && alias cap="bundle exec cap"
alias df="df -h"
alias diff="git diff --no-index --color-words"
alias du="du -hc"
alias ping="ping -c 5"
alias vi="vim"
command -v xdg-open >/dev/null && alias open="xdg-open" # Install https://github.com/Cloudef/PKGBUILDS/tree/master/linopen
alias grep='grep --color=auto'

# Shortcuts
command -v exa >/dev/null && {
  alias l="exa"
  alias ll="exa -la"
}
command -v fasd >/dev/null && {
  alias o="fasd -f -e xdg-open"
  alias oo="fasd -fi -e xdg-open"
  alias z="fasd_cd -d"
  alias zz="fasd_cd -d -i"
  alias v="fasd -f -e vim"
  alias vv="fasd -fi -e vim"
}
command -v git >/dev/null && alias g="git"

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls="ls --color=auto"
fi

# Enable mouse over mosh
# https://github.com/keithw/mosh/issues/101#issuecomment-12317162
command -v mosh >/dev/null && alias mosh="perl -E ' print \"\e[?1005h\e[?1002h\" '; mosh"

# Download mutt attachments into downloads folder
command -v mutt >/dev/null && alias mutt="cd ~/downloads/mutt && mutt && cd -"

# Enable aliases to be sudo’ed
alias sudo="sudo "

# List 10 biggest files in pwd.
alias bf="du -x | sort -nr | head -10"

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# URL-encode strings
# https://github.com/mathiasbynens/dotfiles/blob/master/.aliases
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# Make HTTP requests
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$method"="lwp-request -m '$method'"
done
unset method
