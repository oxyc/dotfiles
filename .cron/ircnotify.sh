#/bin/bash
# Requires .local/bin/notify

PATH="$PATH:$HOME/.local/bin:/usr/sbin"

getPID() { ps aux | \grep "$1" | awk 'BEGIN { ORS=" " } { print $2 }'; }
getPTS() { ps aux | \grep "$1" | awk 'BEGIN { ORS=" " } { print $7 }'; }

pid_file=/tmp/ircnotify
export IRC_PTS=$(getPTS '\(ssh\|mosh-client\) tlk')

shutdownProcess() {
  kill $(getPID '[s]sh -f tlk tail') > /dev/null 2>&1
  kill $(getPID '[x]args -I % notify %') > /dev/null 2>&1
  rm -f $pid_file
  exit
}

# Make sure we're not listening already
[[ -f $pid_file ]] && [[ -s /proc/$(cat $pid_file)/exe ]] && { trap - INT TERM EXIT;  exit 0; }
echo $$ >| $pid_file

trap shutdownProcess INT TERM EXIT

# Start listening in a blocking state
ssh -f tlk "tail -n0 -q -f ~/irclogs/*/*.log | grep --line-buffered '>.*oxy' | sed -u -e 's/^.*\\s*.*>//g'" \
  | BELL=$IRC_PTS xargs -I % notify %
