#/bin/bash
# Requires .local/bin/notify

PATH="$PATH:$HOME/.local/bin:/usr/sbin"
# Get user defined variables
[ -r "$HOME/.bash/local.sh" ] && source $HOME/.bash/local.sh

getPID() { ps aux | \grep "$1" | awk 'BEGIN { ORS=" " } { print $2 }'; }
getPTS() { ps aux | \grep "$1" | awk 'BEGIN { ORS=" " } { print $7 }'; }

pid_file=/tmp/ircnotify
export IRC_PTS=$(getPTS "\(ssh\|mosh-client\) $IRC_SSH_ALIAS")

shutdownProcess() {
  kill $(getPID "[s]sh -f $IRC_SSH_ALIAS tail") > /dev/null 2>&1
  kill $(getPID "[x]args -I % notify %") > /dev/null 2>&1
  rm -f $pid_file
  exit
}

# Make sure we're not listening already
[[ -f $pid_file ]] && [[ -s /proc/$(cat $pid_file)/exe ]] && { trap - INT TERM EXIT;  exit 0; }
echo $$ >| $pid_file

trap shutdownProcess INT TERM EXIT

# Start listening in a blocking state.
# (1) Only check lines beginning with a date
# (2) Not written by myself and not a status message
# (5) Mentions my name as a separted word (i.e. not proxy)
ssh -f irc "tail -n0 -q -f ~/.weechat/logs/irc.*.weechatlog | awk -Winteractive '\
  /[0-9]+/ {\
    if (\$3 !~ \"$IRC_USERNAME|--\") {\
      s=\"\";\
      for (i=3; i<=NF;i++) s = s \$i \" \";\
      if (s ~ \" $IRC_USERNAME\") print s;\
    }\
  }'" | BELL=$IRC_PTS xargs -I % notify %
