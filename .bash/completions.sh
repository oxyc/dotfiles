# Shell completions.
if ! shopt -oq posix; then
  for file in /etc/bash_completion /usr/local/etc/bash_completion.d/* ~/.bash_completion.d/*; do
    [ -r "$file" ] && source "$file"
  done
fi

# @todo
complete -cf sudo
complete -o nospace -A command killall

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
if [ -e "$HOME/.ssh/config" ]; then
  complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh mosh
fi

# Play function
if [ hash play 2>/dev/null ]; then
  # Add tab completion for play using active tmux sessions and session files available
  _play_complete() {
    cat <(tmux list-sessions 2>/dev/null | awk -F ':' '{ print $1 }') \
        <(ls 2>/dev/null ~/.tmux/sessions/)
  }
  complete -o "default" -o "nospace" -C _play_complete play
fi

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null; then
  complete -o default -o nospace -F _git g
fi

# Fasd
[ hash fasd 2>/dev/null ] && _fasd_bash_hook_cmd_complete v m j o
