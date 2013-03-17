# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Correct minor spelling errors in 'cd' commands.
shopt -s cdspell

# Enter directories by default, i.e. no `cd`
shopt -s autocd

# Attempt to save all lines of a multiple-line command in the same history entry.
shopt -s cmdhist

# Expand aliases for non-interactive shells.
shopt -s expand_aliases

# Don't try to find all the command possibilities when hitting TAB on an empty line.
shopt -s no_empty_cmd_completion

# Include dotfiles in globbing.
shopt -s dotglob

# Recursive globbing
shopt -s globstar

# Case-insensitive globbing.
shopt -s nocaseglob;

# Extended globbing patterns.
# http://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html#Pattern-Matching
shopt -s extglob

# Do not overwrite files when redirecting using ">".
# Note that you can still override this with ">|".
set -o noclobber;

# Vi-like behavior for bash
set -o vi

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export LANG='en_US.UTF-8'

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=4096
export HISTFILESIZE=16384

# When executing the same command twice or more in a row, only store it once.
export HISTCONTROL="ignoredups:ignorespace:erasedups"

# After each command, save and reload history
# http://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Make some commands not show up in history
export HISTIGNORE="ls:l:ll:lsd:cd:cd -:pwd:"

# Some distros won't check home path for inputrc.
export INPUTRC="$HOME/.inputrc"

# Fix ls++ on remote shells without a DISPLAY global.
# https://github.com/trapd00r/ls--/issues/18#issuecomment-15020402
[[ -z $DISPLAY ]] && export DISPLAY=1

# Some default packages
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
[[ -f $(which google-chrome) ]] && export BROWSER=$(which google-chrome)

# PATH additions
for dir in bin .local/bin node_modules/.bin drush .rvm/bin; do
  [[ -d "$HOME/$dir" ]] && export PATH="$PATH:$HOME/$dir"
done

# nvm
[[ -s ~/.nvm/nvm.sh ]] && source ~/.nvm/nvm.sh

# rvm
[[ -s ~/.rvm/scripts/rvm ]] && source ~/.rvm/scripts/rvm

if ! shopt -oq posix; then
  for file in ~/.bash_completion.d/* /etc/bash_completion; do
    [ -r "$file" ] && source "$file"
  done
fi

hash fasd 2>/dev/null && eval "$(fasd --init auto)"

# When connecting to SSH, start or reattach screen session
# http://dotfiles.org/~thayer/.bashrc
#if [ -n "$SSH_CONNECTION" ] && [ -z "$SCREEN_EXIST" ]; then
#  export SCREEN_EXIST=1
#  screen -dr
#fi
