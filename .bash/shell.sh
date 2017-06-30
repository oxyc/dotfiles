# Disable CTRL-s (stop output).
stty stop ''

# Enter directories by default, i.e. no `cd`. Bash 4.
shopt -s autocd 2> /dev/null

# Correct minor spelling errors in 'cd' commands.
shopt -s cdspell

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Attempt to save all lines of a multiple-line command in the same history entry.
shopt -s cmdhist

# Include dotfiles in globbing.
shopt -s dotglob

# Expand aliases for non-interactive shells.
shopt -s expand_aliases

# Extended globbing patterns.
# http://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html#Pattern-Matching
shopt -s extglob

# Recursive globbing. Bash 4.
shopt -s globstar 2> /dev/null

# append to the history file, don't overwrite it.
shopt -s histappend

# Don't try to find all the command possibilities when hitting TAB on an empty line.
shopt -s no_empty_cmd_completion

# Case-insensitive globbing.
shopt -s nocaseglob

# Do not overwrite files when redirecting using ">".
# Note that you can still override this with ">|".
set -o noclobber

# Vi-like behavior for bash.
set -o vi

[[ -s ~/.nvm/nvm.sh ]] && source ~/.nvm/nvm.sh
[[ -s ~/.rvm/scripts/rvm ]] && source ~/.rvm/scripts/rvm
[[ -s ~/.travis/travis.sh ]] && source ~/.travis/travis.sh

# Shell completions.
if ! shopt -oq posix; then
  for file in /etc/bash_completion /usr/local/etc/bash_completion.d/* ~/.bash_completion.d/*; do
    [ -r "$file" ] && source "$file"
  done
fi

command -v fasd >/dev/null && eval "$(fasd --init auto)"

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

command -v grunt >/dev/null && eval "$(grunt --completion=bash)"

# Start GPG agent.
if [ ! -n "$(pgrep gpg-agent)" ]; then
  gpg-agent --daemon
fi

# When connecting to SSH, start or reattach screen session
# http://dotfiles.org/~thayer/.bashrc
#if [ -n "$SSH_CONNECTION" ] && [ -z "$SCREEN_EXIST" ]; then
#  export SCREEN_EXIST=1
#  screen -dr
#fi
