# Case-insensitive globbing.
shopt -s nocaseglob;

# append to the history file, don't overwrite it
shopt -s histappend 

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Correct minor spelling errors in 'cd' commands.
shopt -s cdspell

# Don't try to find all the command possibilities when hitting TAB on an empty line.
shopt -s no_empty_cmd_completion

# Do not overwrite files when redirecting using ">".
# Note that you can still override this with ">|".
set -o noclobber;

# Vi-like behavior for bash
set -o vi

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# @TODO should LC_ALL also be set?
export LANG='en_US.UTF-8'

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=4096
export HISTFILESIZE=16384

# When executing the same command twice or more in a row, only store it once.
export HISTCONTROL='ignoredups:ignorespace'

# Make some commands not show up in history
export HISTIGNORE='ls:l:ll:lsd:cd:cd -:pwd:* --help'

# Some distros won't check home path for inputrc.
export INPUTRC="$HOME/.inputrc"

# Some default packages
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
[[ -f $(which google-chrome) ]] && export BROWSER=$(which google-chrome)

# PATH additions
[[ -d "$HOME/bin" ]] && export PATH="$PATH:$HOME/bin"
[[ -d "$HOME/node_modules" ]] && export PATH="$PATH:$HOME/node_modules"
[[ -d "$HOME/drush" ]] && export PATH="$PATH:$HOME/drush"

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion

  for file in ~/.bash_completion.d/*; do
    [ -r "$file" ] && source "$file"
  done
fi

hash fasd 2>/dev/null && eval "$(fasd --init auto)"

# Source nvm
[[ -f "$HOME/.nvm/nvm.sh" ]] && . $HOME/.nvm/nvm.sh

# When connecting to SSH, start or reattach screen session
# http://dotfiles.org/~thayer/.bashrc
#if [ -n "$SSH_CONNECTION" ] && [ -z "$SCREEN_EXIST" ]; then
#  export SCREEN_EXIST=1
#  screen -dr
#fi
