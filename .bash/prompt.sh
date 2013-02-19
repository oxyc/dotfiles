#!/bin/bash
# git magic inspired by https://github.com/gf3/dotfiles/blob/master/.bash_prompt

# Use status -uno to only traverse tracked files, alot faster.
# @see https://github.com/mathiasbynens/dotfiles/issues/184
parse_git_dirty() {
  [[ $(git status -uno 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
}

parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

prompt_desc() {
  OUTPUT=""
  if [ -n "$SSH_CLIENT" ] ; then
    OUTPUT="${OUTPUT}ssh/"
  fi
  if [[ -n $(git branch 2> /dev/null) ]] ; then
    OUTPUT="${OUTPUT}$(parse_git_branch)/"
  fi

  [[ -n "$OUTPUT" ]] && echo " (${OUTPUT%?})"
}

WHITE="\033[97m"
YELLOW="\033[93m"
RESET="\033[0m"

PS1="\n\[$WHITE\]\W\[$YELLOW\]\$(prompt_desc)\[$WHITE\]:\[$RESET\] "
