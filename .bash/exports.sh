#!/usr/bin/env bash

# Some default packages
export EDITOR="vim"
export VISUAL="vim"
export PAGER="less"

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE

# When executing the same command twice or more in a row, only store it once.
export HISTCONTROL="ignoredups:ignorespace:erasedups"
# Make some commands not show up in history
export HISTIGNORE="ls:l:ll:lsd:cd:cd -:pwd:z:"

# Some distros won't check home path for inputrc.
export INPUTRC="$HOME/.inputrc"

# Prefer US English and use UTF-8.
export LANG="en_US.UTF-8"

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

# Avoid issues with `gpg` as installed via Homebrew.
# https://stackoverflow.com/a/42265848/96656
export GPG_TTY=$(tty);

# After each command, save and reload history
# http://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
# @TODO the following code places ; in front which breaks the command, track it down!
# - printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"
export PROMPT_COMMAND="_fasd_prompt_func; history -a; history -c; history -r;"

# PATH additions.
for dir in bin .local/bin node_modules/.bin drush .rvm/bin .composer/vendor/bin; do
  [[ -d "$HOME/$dir" ]] && export PATH="$PATH:$HOME/$dir"
done

# Add gems to PATH.
if command -v ruby >/dev/null && command -v gem >/dev/null; then
  gem_bin="$(ruby -rubygems -e 'puts Gem.user_dir')/bin"
  [[ -d "$gem_bin" ]] && export PATH="$gem_bin:$PATH"
  unset gem_bin
fi
