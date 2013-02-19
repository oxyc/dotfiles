#!/bin/bash

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

xsetroot -cursor_name left_ptr
setxkbmap -layout se
xbindkeys

# Set a wallpaper
[[ -f ~/pictures/wallpapers/default.jpg ]] && \
  feh --bg-scale ~/pictures/wallpapers/default.jpg

# Map caps lock to esc
xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

exec xmonad
