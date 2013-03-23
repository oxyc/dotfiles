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
shopt -s nocaseglob

# Extended globbing patterns.
# http://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html#Pattern-Matching
shopt -s extglob

# Do not overwrite files when redirecting using ">".
# Note that you can still override this with ">|".
set -o noclobber

# Vi-like behavior for bash
set -o vi

export LANG="en_US.UTF-8"

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=4096
export HISTFILESIZE=16384

# When executing the same command twice or more in a row, only store it once.
export HISTCONTROL="ignoredups:ignorespace:erasedups"

# After each command, save and reload history
# http://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
# @TODO the following code places ; in front which breaks the command, track it down!
# - printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"
export PROMPT_COMMAND="_fasd_prompt_func; history -a; history -c; history -r;"

# Make some commands not show up in history
export HISTIGNORE="ls:l:ll:lsd:cd:cd -:pwd:"

# Some distros won't check home path for inputrc.
export INPUTRC="$HOME/.inputrc"

# Improve yaourt color combinations.
# http://archlinux.fr/man/package-query.8.html#_environment_variables_a_id_ev_a
[ -x /usr/bin/yaourt ] && export YAOURT_COLORS="other=0;31:nb=0;33:pkg=0;97:installed=0;31;7:lver=0;33:ver=0;96:od=0;93:votes=0;33;3:dsc=0;90"

# Fix ls++ on remote shells without a DISPLAY global.
# https://github.com/trapd00r/ls--/issues/18#issuecomment-15020402
[[ -z $DISPLAY ]] && export DISPLAY=1

# Some default packages
export EDITOR="vim"
export VISUAL="vim"
export PAGER="less"
[[ -f $(which google-chrome) ]] && export BROWSER=$(which google-chrome)

# PATH additions
for dir in bin .local/bin node_modules/.bin drush .rvm/bin; do
  [[ -d "$HOME/$dir" ]] && PATH="$PATH:$HOME/$dir"
done

# Remove path duplicates
PATH=$(echo "$PATH" | awk -v RS=':' -v ORS=":" '!a[$1]++')

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
