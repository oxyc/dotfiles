#/bin/bash

pid_file=/tmp/ircnotify

getPID() {
  ps aux | \grep "$1" | \grep -v "grep $1" | awk 'BEGIN { ORS=" " } { print $0 }'
}

shutdownProcess() {
  kill $(getPID 'ssh -f tlk tail') > /dev/null 2>&1
  kill $(getPID 'xargs -I % notify-send %') > /dev/null 2>&1
  rm -f $pid_file
  exit
}

# Make sure we're not listening already
[[ -f $pid_file ]] && { trap - INT TERM EXIT;  exit 0; }
echo $$ >| $pid_file

trap shutdownProcess INT TERM EXIT

# Start listening in a blocking state
ssh -f tlk "tail -n0 -q -f ~/irclogs/*/*.log | grep --line-buffered '>.*oxy' | sed -u -e 's/^.*\\s*.*>//g'" \
  | xargs -I % notify-send %
