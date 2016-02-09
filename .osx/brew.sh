#!/usr/bin/env bash
# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install some unix tools.
brew tap homebrew/dupes
brew install binutils
brew install diffutils
brew install ed --default-names
brew install findutils --with-default-names
brew install gawk
brew install gnu-indent --with-default-names
brew install gnu-sed --with-default-names
brew install gnu-tar --with-default-names
brew install gnu-which --with-default-names
brew install gnutls
brew install grep --with-default-names
brew install gzip
brew install openssh
brew install screen
brew install ssh-copy-id
brew install rsync
brew install tree
brew install watch
brew install wdiff --with-gettext
brew install wget --with-iri
# Install Bash 4.
brew install bash
brew tap homebrew/versions
brew install bash-completion2

# Install VIM
brew install luajit
brew install vim --with-luajit --without-ruby --override-system-vi

# Install more recent versions of some OS X tools.
brew install homebrew/php/php56 --with-gmp
brew install python

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Install some additional utils
brew install nmap
brew install pngcheck
brew install binutils
brew install mozjpeg
brew install optipng
brew install unzip

# Install other useful binaries.
brew install exiv2
brew install git
brew install git-lfs
brew install imagemagick --with-webp
brew install lua
brew install lynx
brew install mosh
brew install p7zip
brew install pigz
brew install pv
brew install rename
brew install speedtest_cli
brew install the_silver_searcher
brew install fzf
brew install webkit2png
brew install zopfli

# Install OSX applications.
brew install caskroom/cask/brew-cask
brew cask install firefox
brew cask install google-chrome
brew cask install lastpass
brew install lastpass-cli --with-pinentry
brew cask install transmission
brew cask install amethyst
brew cask install hyperswitch
brew cask install iterm2
brew cask install caskroom/homebrew-cask/dash
brew cask install caskroom/homebrew-cask/rescuetime
brew cask install caskroom/homebrew-cask/flash

# Install development tools
brew cask install virtualbox
brew cask install vagrant
brew install homebrew/completions/vagrant-completion
brew cask install vagrant-manager
vagrant plugin install vagrant-sshfs
vagrant plugin install hostsupdater
brew install libyaml
brew install ansible
brew install composer

# Install fonts.
brew tap caskroom/fonts
brew cask install font-inconsolata-dz-for-powerline

# Install Seil for remapping esc
brew cask install seil

# Install additional QuickLook plugins.
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook

# Install neovim
brew tap neovim/neovim
brew install --HEAD neovim

# Install massren
brew tap laurent22/massren
brew install massren

# Install MenuAndDockless
# brew cask install easysimbl
# wget http://myownapp.com/downloads/MenuAndDockless.zip

# Remove outdated versions from the cellar.
brew cleanup

# Enable and switch to Bash 4
if ! grep -Fxq "/usr/local/bin/bash" /etc/shells; then
  sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
  chsh -s /usr/local/bin/bash
fi
