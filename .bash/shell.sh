# Disable CTRL-s (stop output)
stty stop ''

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

[[ -s ~/.nvm/nvm.sh ]] && source ~/.nvm/nvm.sh
[[ -s ~/.rvm/scripts/rvm ]] && source ~/.rvm/scripts/rvm
[[ -s ~/.travis/travis.sh ]] && source ~/.travis/travis.sh

if ! shopt -oq posix; then
  for file in ~/.bash_completion.d/* /etc/bash_completion /usr/local/etc/bash_completion.d/*; do
    [ -r "$file" ] && source "$file"
  done
fi

command -v fasd >/dev/null && eval "$(fasd --init auto)"

command -v grunt >/dev/null && eval "$(grunt --completion=bash)"

command -v fzf >/dev/null && {
  fzf_path="$(dirname $(realpath $(which fzf)))/.."
  source "$fzf_path/shell/completion.bash"
  source "$fzf_path/shell/key-bindings.bash"
  # Ctrl-A: cd into the selected directory, use this instead of fzf's own Alt-C
  # We use vi mode
  bind '"\C-a": "\eddi$(__fzf_cd__)\C-x\C-e\C-x\C-r\C-m"'
  bind -m vi-command '"\C-a": "i\C-a"'
  unset fzf_path
}

# When connecting to SSH, start or reattach screen session
# http://dotfiles.org/~thayer/.bashrc
#if [ -n "$SSH_CONNECTION" ] && [ -z "$SCREEN_EXIST" ]; then
#  export SCREEN_EXIST=1
#  screen -dr
#fi
