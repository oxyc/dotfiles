#/bin/bash

pid_file=/tmp/ircnotify
export DISPLAY=":0.0"

getPID() {
  ps aux | \grep "$1" | awk 'BEGIN { ORS=" " } { print $2 }'
}

shutdownProcess() {
  kill $(getPID '[s]sh -f tlk tail') > /dev/null 2>&1
  kill $(getPID '[x]args -I % notify-send %') > /dev/null 2>&1
  rm -f $pid_file
  exit
}

# Make sure we're not listening already
[[ -f $pid_file ]] && [[ -s /proc/$(cat $pid_file)/exe ]] && { trap - INT TERM EXIT;  exit 0; }
echo $$ >| $pid_file

trap shutdownProcess INT TERM EXIT

# Start listening in a blocking state
ssh -f tlk "tail -n0 -q -f ~/irclogs/*/*.log | grep --line-buffered '>.*oxy' | sed -u -e 's/^.*\\s*.*>//g'" \
  | xargs -I % notify-send %
