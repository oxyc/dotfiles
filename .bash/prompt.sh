# https://github.com/sindresorhus/pure/blob/master/prompt.zsh
[[ -z $DEFAULT_USERNAME ]] && DEFAULT_USERNAME="oxy"
[[ -z $DEFAULT_HOSTNAME ]] && DEFAULT_HOSTNAME="cindy"

__prompt() {
  [[ -n "$SSH_CLIENT" ]] && local ssh="ssh"
  if [[ $USER != $DEFAULT_USERNAME ]] || [[ $HOSTNAME != $DEFAULT_HOSTNAME ]]; then
    local user="$USER@$HOSTNAME"
  fi
  local branch="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null)"
  local dirty=$(git diff --quiet --ignore-submodules HEAD 2>/dev/null; [ $? -eq 1 ] && echo '*')

  [[ -n $ssh ]] && [[ -n $user ]] && ssh="$ssh:"
  [[ -n $user ]] && [[ -n $branch ]] && user="$user "

  echo " ${ssh}${user}${branch}${dirty}"
}

PS1="\n\[$ORANGE\]\W\[$GRAY\]\$(__prompt)\[$WHITE\]:\[$RESET\] "
