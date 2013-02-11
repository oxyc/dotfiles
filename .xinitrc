#!/bin/bash

[[ -f $HOME/.Xresources ]] && xrdb -merge ~/.Xdefaults

xsetroot -cursor_name left_ptr
setxkbmap -layout se
xbindkeys

# Map caps lock to esc
xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

exec xmonad
