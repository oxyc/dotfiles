#!/bin/bash

filepath="$(readlink -f "${BASH_SOURCE[0]}")"
filedir="$(dirname $filepath)"
backup="$HOME/.backup-dotfiles"

die() {
  echo -e "$1\n"
  exit 1
} >&2

usage() {
  cat <<'EOF'
install.sh [COMMAND]

Install oxys dotfiles repository.

Options:
  -f, --force   Prompt for each first level file before copying
  -h, --help    Display this help and exit
  install       Install dotfiles, only required the first time
  update        Update files
EOF
}

confirm() {
  echo
  read -p "$1 [y/n] " -n 1
  [[ $REPLY =~ ^[Yy]$ ]]
}

# Try to find the correct repo directory
verifyDirectory() {
  if [[ ${filredir##*/} != "dotfiles" ]]; then
    if [[ -d "$filedir/dotfiles" ]]; then
      filedir="$filedir/dotfiles"
    fi
  fi
  [[ -d "$filedir/.git" ]] || die "Couldn't find the repository directory."
}

syncit() {

  if ! mkdir -p "$backup"; then
    die "Error creating backup directory $backup"
  fi

  for src in $(find $filedir -maxdepth 1 ! -name 'dotfiles' \
                                         ! -name '.git' \
                                         ! -name '.' \
                                         ! -name 'install.sh' \
                                         ! -name 'README.md'); do
    local basename=$(basename $src)
    local target="$HOME/$basename"

    # Verify unless force flagged
    if [[ $force -ne 1 ]]; then
      ! confirm "Copy $src to $target" && continue
    fi
    rsync --backup-dir="$backup" -ar "$src" "$HOME"

    # Backup in case something goes wrong
    if [[ $? -ne 0 ]]; then
      mv $backup/* $HOME/
      die "rsync failed for whatever reason, trying to restore backups."
    fi
    echo
  done

  # delete backups
  rm -rf $backup
}

# Parse the options
while [[ $1 = ?* ]]; do
  case $1 in
    -f|--force) force=1;;
    -h|--help) usage >&2; exit 0;;
    install) setup=1;;
    update) update=1;;
    *) die "Invalid option: $1";;
  esac

  shift
done

if ((update)); then
  verifyDirectory

  cd $filedir \
    && git pull origin master \
    && git submodule foreach git pull origin master \
    && syncit \
    && cd $OLDPWD

elif ((setup));then
  git clone --recursive git://github.com/oxyc/dotfiles.git \
    && verifyDirectory \
    && syncit
else
  die "$0: missing command operand\nTry \`$0 --help\` for more information."
fi

if [[ $? -ne 0 ]]; then
  die "Something went wrong... sorry about that"
fi

source $HOME/.bash_profile
