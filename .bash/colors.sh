#!/usr/bin/env bash

# Unescaped codes
FG_italic="3"
FG_underline="4"
FG_revert="7"
FG_reset="0"
FG_red="31"
FG_green="32"
FG_yellow="33"
FG_blue="34"
FG_purple="35"
FG_cyan="36"
FG_orange="91"
FG_brown="96"
FG_white="97"
FG_darkestgray="30"
FG_darkergray="92"
FG_darkgray="93"
FG_gray="90"
FG_lightgray="94"
FG_lightergray="37"
FG_lightestgray="95"

# Escape codes, global
export ITALIC="\e[${FG_italic}m"
export UNDERLINE="\e[${FG_underline}m"
export REVERT="\e[${FG_revert}m"
export RESET="\e[${FG_reset}m"

export RED="\e[0;${FG_red}m"
export GREEN="\e[0;${FG_green}m"
export YELLOW="\e[0;${FG_yellow}m"
export BLUE="\e[0;${FG_blue}m"
export PURPLE="\e[0;${FG_purple}m"
export CYAN="\e[0;${FG_cyan}m"
export ORANGE="\e[0;${FG_orange}m"
export BROWN="\e[0;${FG_brown}m"

export WHITE="\e[0;${FG_white}m"
export LIGHTESTGRAY="\e[0;${FG_lightestgray}m"
export LIGHTERGRAY="\e[0;${FG_lightergray}m"
export LIGHTGRAY="\e[0;${FG_lightgray}m"
export GRAY="\e[0;${FG_gray}m"
export DARKGRAY="\e[0;${FG_darkgray}m"
export DARKERGRAY="\e[0;${FG_darkergray}m"
export DARKESTGRAY="\e[0;${FG_darkestgray}m"
export BLACK="$(tput setaf 16)"

export FOREGROUND="$LIGHTERGRAY"
export BACKGROUND="$DARKESTGRAY"

BASE16_SHELL=/usr/local/share/base16-shell/
[[ -d $BASE16_SHELL ]] && source "$BASE16_SHELL/scripts/base16-default-dark.sh"
