#!/bin/bash

if [[ ${BASH_SOURCE[0]} ]]; then
  filepath="$(readlink -f "${BASH_SOURCE[0]}")"
  filedir="$(dirname $filepath)"
fi
backup="$HOME/.backup-dotfiles"

die() {
  echo -e "$1\n"
  exit 1
}

usage() {
  cat <<'EOF'
install.sh [COMMAND]

Install oxys dotfiles repository.

Options:
  -f, --force  Force installation not to prompt on files. Enabled while piping.
  -h, --help   Display this help and exit
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
    if ((prompt)); then
      ! confirm "Copy $src to $target" && continue
    fi
    rsync --exclude=".git/" --backup-dir="$backup" -ar "$src" "$HOME"

    # Backup in case something goes wrong
    if [[ $? -ne 0 ]]; then
      mv $backup/* $HOME/
      die "rsync failed for whatever reason, trying to restore backups."
    else
      echo -n "$target"
    fi
    echo
  done

  # delete backups
  rm -rf $backup
}

# Parse the options
while [[ $1 = ?* ]]; do
  case $1 in
    -p|--prompt) prompt=1;;
    -h|--help) usage >&2; exit 0;;
  esac

  shift
done

if ((pipe)); then
  filedir="$PWD"
  git clone --recursive git://github.com/oxyc/dotfiles.git \
    && verifyDirectory \
    && syncit
else
  verifyDirectory

  cd $filedir \
    && git pull origin master \
    && git submodule foreach git pull origin master \
    && syncit \
    && cd $OLDPWD
fi

source $HOME/.bash_profile
