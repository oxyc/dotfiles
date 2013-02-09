#!/bin/bash

PATH="$PATH:$HOME/.local/bin:/usr/sbin"

CAPACITY=$(battery capacity)
AC=$(battery ac)

send() {
  DISPLAY=:0.0 notify-send --urgency=${2:-normal} "$1"
}

# Exit if AC is used.
[[ $AC -eq 1 ]] && exit 0

# Hibernate if we're below 5%
if [[ $CAPACITY -lt 5 ]]; then
  send "Hibernating in 60 sec because of low battery!" "critical"
  sleep 60
  sudo pm-hibernate

# Critical notification at less than 10%
elif [[ $CAPACITY -lt 10 ]]; then
  send "Battery: ${CAPACITY}%" "critical"

# Low level notification at less than 15%
elif [[ $CAPACITY -lt 15 ]]; then
  send "Battery: ${CAPACITY}%" "critical"
fi
