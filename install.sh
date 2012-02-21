#!/bin/bash

syncit() {
  rsync --exclude ".git/" --exclude "install.sh" --exclude "README.md" -av . ~
  source ~/.bash_profile
}

case "$1" in
  --update|-u)
    git pull && git submodule foreach git pull \
      && syncit \
      || echo "Something went wrong"
    ;;
  *)
    git clone --recursive git://github.com/oxyc/dotfiles.git \
      && cd dotfiles \
      && syncit \
      || echo "Something went wrong"
    ;;
esac
