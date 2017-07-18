# https://github.com/sindresorhus/pure/blob/master/prompt.zsh
[[ -z $DEFAULT_USERNAME ]] && DEFAULT_USERNAME="oxy"
[[ -z $DEFAULT_HOSTNAME ]] && DEFAULT_HOSTNAME="cindy"

__prompt_user() {
  [[ -n "$SSH_CLIENT" ]] && local ssh="ssh"
  if [[ $USER != $DEFAULT_USERNAME ]] || [[ $HOSTNAME != $DEFAULT_HOSTNAME ]]; then
    local user="$USER@$HOSTNAME"
  fi
  [[ -n $ssh ]] && [[ -n $user ]] && ssh="$ssh:"
  [[ -n $user ]] && [[ -n $branch ]] && user="$user "

  echo "${ssh}${user}"
}

__prompt_git() {
  local branch="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null)"
  local dirty=$(git diff --quiet --ignore-submodules HEAD 2>/dev/null; [ $? -eq 1 ] && echo '*')
  if [[ -n "$branch" ]] || [[ -n "$dirty" ]]; then
    echo " ${branch}${dirty}"
  fi
}

__prompt() {
  local exit_code=$?
  PS1="\n"
  PS1="$PS1\[$ORANGE\]\W"
  PS1="$PS1\[$GRAY\]\$(__prompt_user)"
  if [[ $exit_code != 0 ]]; then
    PS1="$PS1\[$GRAY\] ["
    PS1="$PS1\[$RED\]$exit_code"
    PS1="$PS1\[$GRAY\]]"
  fi
  PS1="$PS1\$(__prompt_git)"
  PS1="$PS1\[$WHITE\]:"
  PS1="$PS1\[$RESET\] "
}

PROMPT_COMMAND="__prompt"
