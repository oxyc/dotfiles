#!/bin/bash

if [ -f $HOME/.Xdefaults ]; then
  xrdb -merge $HOME/.Xdefaults
fi

# Map caps lock to esc, on ubuntu this needs to be in ~/.xsession
xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
