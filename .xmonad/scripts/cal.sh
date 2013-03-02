#!/bin/bash
#
# (c) 2007, by Robert Manea
# http://dzen.geekmode.org/dwiki/doku.php?id=dzen:calendar

TODAY=$(expr $(date +'%d') + 0)
MONTH=$(date +'%m')
YEAR=$(date +'%Y')

{
  highlight="\#ebac40"
  # Current month and day
  cal | sed -r -e "1,2 s/.*/^fg($highlight)&^fg()/; s/^(.)/  \1/" \
      -e "s/(^| )($TODAY)($| )/\1^bg(\#ebac40)^fg(#666)\2^fg()^bg()\3/"
  # Next month
  [ $MONTH -eq 12 ] && YEAR=$(expr $YEAR + 1)
  cal $(expr \( $MONTH + 1 \) % 12) $YEAR | sed -r -e '1,2 s/.*/^fg(\#ebac40)&^fg()/; s/^(.)/  \1/'
} | dzen2 -p 60 -fn '-*-InconsolataForPowerline-*-*-*-*-14-*-*-*-*-*-utf8-*' \
          -x 1400 -y 17 -w 170 -l 16 -sa l -e 'onstart=uncollapse;button3=exit;button1=exit'
