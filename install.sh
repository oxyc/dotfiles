#!/bin/bash

dir=$(dirname ${BASH_SOURCE[0]})

die() {
  printf '%s\n' "$@"
  exit 1
} >&2

usage() {
  cat <<'EOF'
  install.sh [COMMAND]

  Download oxys dotfiles repository to the current location and create symlinks
  in $HOME pointing to all essential files. Numbered backups will be created.

  Options:
    -h, --help          Display this help and exit
    -f, --force        Prompt for each file to be symlinked
    -i, --install       Install dotfiles, use only first time
    -u, --update        Update k
EOF
}

confirm() {
  read -p "$1 [y/n] " -n 1
  [[ $REPLY =~ ^[Yy]$ ]]
}

createSymlinks() {
  local backup="$HOME/.backup-dotfiles"
  mkdir -p $backup

  for file in $(find $dir -maxdepth 1 ! -name 'dotfiles' \
                                      ! -name '.git' \
                                      ! -name '.' \
                                      ! -name 'install.sh' \
                                      ! -name 'README.md'); do
    local basename=$(basename $file)
    local old_file="$HOME/$basename"

    if [[ $force -ne 1 ]]; then
      echo
      if ! confirm "Create symlink for $basename"; then
        continue
      fi
    fi
    if [ -e $old_file ]; then
      echo "Moving old $old_file to $backup/$basename"
      mv --backup=numbered "$old_file" "$backup/$basename"
    fi
    ln -s "$PWD/$file" "$HOME/$basename"
  done
}

case "$1" in
  --force|-f)
    force=1
    ;;
  --install|-i)
    git clone --recursive git://github.com/oxyc/dotfiles.git \
      && createSymlinks

    if [[ $? -ne 0 ]]; then
      die "Something went wrong"
    fi
    ;;
  --help|-h|help)
    usage
    ;;
  --update|-u)
    cd $dir \
      && git pull origin master \
      && git submodule foreach git pull origin master

    if [[ $? -ne 0 ]]; then
      die "Something went wrong"
    fi
    ;;
  *)
    die "No command specified"
    ;;
esac

source $HOME/.bash_profile
