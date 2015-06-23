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
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names
# Install Bash 4.
brew install bash
brew tap homebrew/versions
brew install bash-completion2

# Install `wget` with IRI support.
brew install wget --with-iri

# Install VIM
brew install luajit
brew install vim --with-luajit --without-ruby --override-system-vi

# Install more recent versions of some OS X tools.
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh
brew install homebrew/dupes/screen
brew install homebrew/php/php55 --with-gmp

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Install some additional utils
brew install nmap
brew install pngcheck
brew install binutils

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
brew install ssh-copy-id
brew install the_silver_searcher
brew install tree
brew install webkit2png
brew install zopfli

# Install OSX applications.
brew install caskroom/cask/brew-cask
brew cask install firefox
brew cask install google-chrome
brew cask install lastpass
brew cask install transmission
brew cask install amethyst
brew cask install iterm2
brew cask install caskroom/homebrew-cask/dash
brew cask install caskroom/homebrew-cask/rescuetime
brew cask install caskroom/homebrew-cask/flash
brew cask install caskroom/homebrew-cask/vagrant

# Install fonts.
brew tap caskroom/fonts
brew cask install font-inconsolata-dz-for-powerline

# Install Seil for remapping esc
brew cask install seil

# Install additional QuickLook plugins.
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook 

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
