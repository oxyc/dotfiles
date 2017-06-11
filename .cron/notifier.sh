#!/bin/bash

PATH="$PATH:$HOME/.local/bin:/usr/sbin"
source ~/.bash/functions.sh

CAPACITY=$(battery capacity)
AC=$(battery ac)

# Exit if AC is used.
[[ $AC -eq 1 ]] && exit 0

# Hibernate if we're below 5%
if [[ $CAPACITY -lt 5 ]]; then
  notify "Hibernating in 60 sec because of low battery!" "critical"
  sleep 60
  sudo pm-hibernate

# Critical notification at less than 10%
elif [[ $CAPACITY -lt 10 ]]; then
  notify "Battery: ${CAPACITY}%" "critical"

# Low level notification at less than 15%
elif [[ $CAPACITY -lt 15 ]]; then
  notify "Battery: ${CAPACITY}%" "critical"
fi
