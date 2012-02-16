#!/bin/bash

git clone git://github.com/oxyc/dotfiles.git
cd dotfiles
rsync --exclude ".git/" --exclude "install.sh" --exclude "README.md" -av . ~
source ~/.bash_profile
