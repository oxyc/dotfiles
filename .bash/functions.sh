#!/bin/bash

# Whether or not we have a command
# http://dotfiles.org/~steve/.bashrc
have() {
  type "$1" &> /dev/null
}

# Filter through running processes
psgrep() {
  ps aux | \grep -e "$@" | \grep -v "grep -e $@"
}

# One command to rule them all
# http://dotfiles.org/~krib/.bashrc
extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)  tar xjf $1      ;;
      *.tar.gz)   tar xzf $1      ;;
      *.bz2)      bunzip2 $1      ;;
      *.rar)      rar x $1        ;;
      *.gz)       gunzip $1       ;;
      *.tar)      tar xf $1       ;;
      *.tbz2)     tar xjf $1      ;;
      *.tgz)      tar xzf $1      ;;
      *.zip)      unzip $1        ;;
      *.Z)        uncompress $1   ;;
      *)          echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# http://dotfiles.org/~krib/.bashrc
bu() {
  if [ "$(dirname $1)" == "." ]; then
    mkdir -p ~/.backup/$(pwd)
    cp $1 ~/.backup/$(pwd)/$1-$(date +%Y%m%d%H%M).backup
  else
    mkdir -p ~/.backup/$(dirname $1)
    cp $1 ~/.backup/$1-$(date +%Y%m%d%H%M).backup
  fi
}

# Tmux session wrapper
# You can configure skeletons per hostname by adding them to ~/.tmux/sessions/$(hostname)
play() {
  local session="${1:-$(hostname)}"

  if tmux has-session -t $session; then
    echo "Attaching old session in 1..."; sleep 1
    tmux -2 attach-session -t $session
  else
    if [[ -e ~/.tmux/sessions/$session ]]; then
      echo "Session skeleton exists, running it in 1..."; sleep 1
      . ~/.tmux/sessions/$session
    else
      echo "Creating new session in 1..."; sleep 1
      tmux new-session -d -s $session -n $session "bash"
      tmux -2 attach-session -t $session
    fi
  fi
}

# Sort the "du" output and use human-readable units.
# https://github.com/janmoesen/tilde/blob/master/.bash/commands
duh() {
  du -sk ${@:-*} | sort -n | while read size fname; do
    for unit in KiB MiB GiB TiB PiB EiB ZiB YiB; do
      if [ "$size" -lt 1024 ]; then
        echo -e "${size} ${unit}\t${fname}"
        break
      fi
      size=$((size/1024))
    done
  done
}

# Edit the files found with the previous "ag" command using Vim
vag() {
  declare -a files
  while read -r file; do
    echo "$file"
    files+=("$file")
  done < <(bash -c "ag -l $@")
  "${EDITOR:-vim}" "${files[@]}"
}

# Git log with per-commit clickable GitHub URLs.
# https://github.com/cowboy/dotfiles/commit/78fde838a429250e923f5611e233c6e4e942b377
gf() {
  local remote="$(git remote -v | awk '/^origin.*\(push\)$/ {print $2}')"
  [[ "$remote" ]] || return
  local user_repo="$(echo "$remote" | perl -pe 's/.*://;s/\.git$//')"
  git log $* --name-status --color | awk "$(cat <<AWK
    /^.*commit [0-9a-f]+/ {sha=substr(\$2,1,7); printf "%s\thttps://github.com/$user_repo/commit/%s\033[0m\n", \$1, sha; next}
    /^[MA]\t/ {printf "%s\thttps://github.com/$user_repo/blob/%s/%s\n", \$1, sha, \$2; next}
    /.*/ {print \$0}
AWK
  )" | less -R
}

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

imageshadow() {
  local input="$1"
  local output="${2:-${input%.*}-shadow.${input#*.}}"
  convert "$input" \( +clone -background black -shadow 100x10+0+10 \) \
    +swap -background transparent -layers merge +repage "$output"
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

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
getcertnames() {
  if [ -z "${1}" ]; then
    echo "ERROR: No domain specified."
    return 1
  fi

  domain="${1}"
  echo "Testing ${domain}…"
  echo # newline

  tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
    | openssl s_client -connect "${domain}:443" 2>&1);

  if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
    certText=$(echo "${tmp}" \
      | openssl x509 -text -certopt "no_header, no_serial, no_version, \
      no_signame, no_validity, no_issuer, no_pubkey, no_sigdump, no_aux");
      echo "Common Name:"
      echo # newline
      echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//";
      echo # newline
      echo "Subject Alternative Name(s):"
      echo # newline
      echo "${certText}" | sed -ne "/Subject Alternative Name:/{n;p}" \
        | awk -F ':' 'BEGIN { RS="," } { print $2 }'
      return 0
  else
    echo "ERROR: Certificate not found.";
    return 1
  fi
}

# Simple calculator
# = 1 + 3
= () {
  local result=""
  result="$(printf "scale=10;$*\n" | bc -l | tr -d '\\\n')"
  #                       └─ default (when `--mathlib` is used) is 20
  #
  if [[ "$result" == *.* ]]; then
    # improve the output for decimal numbers
    printf "$result" |
    sed -e 's/^\./0./'        `# add "0" for cases like ".5"` \
        -e 's/^-\./-0./'      `# add "0" for cases like "-.5"`\
        -e 's/0*$//;s/\.$//'   # remove trailing zeros
  else
    printf "$result"
  fi
  printf "\n"
}

# Escape UTF-8 characters into their 3-byte format
escape() {
  printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
  echo
}

# Decode \x{ABCD}-style Unicode escape sequences
unidecode() {
  perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
  echo
}

# Get a character’s Unicode code point
codepoint() {
  perl -e "use utf8; print sprintf('U+%04X', ord(\"$@\"))"
  echo
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
# https://github.com/mathiasbynens/dotfiles
targz() {
  local tmpFile="${@}.tar"
  tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1

  size=$(
    stat -f"%z" "${tmpFile}" 2> /dev/null; # OS X `stat`
    stat --printf="%s" "${tmpFile}" 2> /dev/null # GNU `stat`
  )

  local cmd=""
  if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
    # the .tar file is smaller than 50 MB and Zopfli is available; use it
    cmd="zopfli"
  else
    if hash pigz 2> /dev/null; then
      cmd="pigz"
    else
      cmd="gzip"
    fi
  fi

  echo "Compressing .tar using \`${cmd}\`…"
  "${cmd}" -v "${tmpFile}" || return 1
  [ -f "${tmpFile}" ] && rm "${tmpFile}"
  echo "${tmpFile}.gz created successfully."
}

# https://github.com/mathiasbynens/dotfiles/pull/249
tre() {
  tree -aC -I '.git|node_modules|bower_components|.sass-cache' --dirsfirst "$@" | less -FRNX
}