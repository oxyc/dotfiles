#!/usr/bin/env bash

# Place scrot files in specified directory
command -v scrot >/dev/null && alias scrot="scrot ~/pictures/screenshots/%Y-%m-%d_%H%M%S.png"

# http://dotfiles.org/~ghost1227/.bashrc
alias meminfo="echo -e '/proc/meminfo:\n';grep --color=auto '^[Mem|Swap]*[Free|Total]*:' /proc/meminfo && echo -e '\nfree -m:'; free -m"

# Set the BROWSER variable to whichever chrome version is available.
for browser in "google-chrome" "google-chrome-stable" "google-chrome-beta"; do
  if command -v $browser >/dev/null; then
    export BROWSER="$(which $browser)";
    break
  fi
done

# Improve yaourt color combinations.
# http://archlinux.fr/man/package-query.8.html#_environment_variables_a_id_ev_a
command -v yaourt >/dev/null && export YAOURT_COLORS="\
  other=0;$FG_red:\
  nb=0;$FG_yellow:\
  pkg=0;$FG_white:\
  installed=0;$FG_red;$FG_revert:\
  lver=0;$FG_yellow:\
  ver=0;$FG_brown:\
  od=0;$FG_darkgray:\
  votes=0;$FG_yellow;$FG_italic:\
  dsc=0;$FG_gray"

# Usage: dimscreen 0-100
dimscreen() {
  local max=$(cat /sys/class/backlight/acpi_video0/max_brightness)
  local amount="${1:-$max}"
  local dim=$(printf "%.0f" $(awk -v m=$max -v a=$amount 'BEGIN { print m * a / 100}'))

  sudo bash -c "for i in /sys/class/backlight/acpi_video*/brightness; do echo $dim > \$i; done"
}

toggletouch() {
  local touchpad=$(xinput list | grep 'TouchPad' | sed -e 's/.*id=\([0-9]\+\).*/\1/')
  local trackpad=$(xinput list | grep 'TrackPoint' | sed -e 's/.*id=\([0-9]\+\).*/\1/')
  local enabled=$(xinput list-props $touchpad | grep 'Device Enabled' | sed 's/.*:.\+\([01]\).*/\1/')
  ((enabled)) && local status=0 || local status=1
  xinput --set-prop $touchpad "Device Enabled" $status
  xinput --set-prop $trackpad "Device Enabled" $status
}

screenshot() {
  [[ $1 ]] && echo "Grabbing screenshot in $1 sec" && sleep $1
  local activeWindow=$(xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)")
  local id=${activeWindow:40}
  local filename="$(date +%F_%H%M%S).png"
  import -window "$id" -frame $filename
  imageshadow $filename $filename
}

windowsize() {
  local width=${1:-640}
  local height=${2:-400}
  wmctrl -r :ACTIVE: -e 0,-1,-1,$width,$height
}
