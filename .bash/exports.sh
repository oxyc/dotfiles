#!/bin/bash

# Always enable colored `grep` output
export GREP_OPTIONS="--color=auto"

export LANG="en_US.UTF-8"

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE

# When executing the same command twice or more in a row, only store it once.
export HISTCONTROL="ignoredups:ignorespace:erasedups"
# Make some commands not show up in history
export HISTIGNORE="ls:l:ll:lsd:cd:cd -:pwd:z:"

# After each command, save and reload history
# http://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
# @TODO the following code places ; in front which breaks the command, track it down!
# - printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"
export PROMPT_COMMAND="_fasd_prompt_func; history -a; history -c; history -r;"


# Some distros won't check home path for inputrc.
export INPUTRC="$HOME/.inputrc"

# Improve yaourt color combinations.
# http://archlinux.fr/man/package-query.8.html#_environment_variables_a_id_ev_a
have yaourt && export YAOURT_COLORS="\
  other=0;$FG_red:\
  nb=0;$FG_yellow:\
  pkg=0;$FG_white:\
  installed=0;$FG_red;$FG_revert:\
  lver=0;$FG_yellow:\
  ver=0;$FG_brown:\
  od=0;$FG_darkgray:\
  votes=0;$FG_yellow;$FG_italic:\
  dsc=0;$FG_gray"

# Fix ls++ on remote shells without a DISPLAY global.
# https://github.com/trapd00r/ls--/issues/18#issuecomment-15020402
[[ -z $DISPLAY ]] && export DISPLAY=1

# Some default packages
export EDITOR="vim"
export VISUAL="vim"
export PAGER="less"
have google-chrome && export BROWSER=$(which google-chrome)

# PATH additions
for dir in bin .local/bin node_modules/.bin drush .rvm/bin; do
  [[ -d "$HOME/$dir" ]] && PATH="$PATH:$HOME/$dir"
done

# Remove path duplicates
PATH=$(echo "$PATH" | awk -v RS=':' -v ORS=":" '!a[$1]++')
