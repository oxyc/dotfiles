#!/bin/bash
# https://github.com/sindresorhus/pure/blob/master/prompt.zsh
[ -z $DEFAULT_USERNAME ] && DEFAULT_USERNAME='oxy'
[ -z $DEFAULT_HOSTNAME ] && DEFAULT_HOSTNAME='cindy'

WHITE="\033[97m"
GRAY="\033[90m"
RESET="\033[0m"

__prompt() {
  local output=""
  [ -n "$SSH_CLIENT" ] && local ssh="ssh/"
  [ $USER != $DEFAULT_USERNAME ] && local user=" $USER@$HOSTNAME"
  [ $HOSTNAME != $DEFAULT_HOSTNAME ] && local user=" $USER@$HOSTNAME"
  local branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d;s/* \(.*\)/\1/')
  local dirty=$(git diff --quiet --ignore-submodules HEAD 2>/dev/null; [ $? -eq 1 ] && echo '*')

  echo " ${ssh}${branch}${dirty}${user}"
}

PS1="\n\[$WHITE\]\W\[$GRAY\]\$(__prompt)\[$WHITE\]:\[$RESET\] "
