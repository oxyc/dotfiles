## Installation

One-line installation script
``
curl https://raw.github.com/oxyc/dotfiles/master/install.sh -o - | bash
``

Add a .bash/extras file with your additional settings, such as:
``
git config --global user.name FULLNAME
git config --global user.email EMAIL
git config --global github.user USERNAME
git config --global github.token TOKEN
``

Edit your own name and website into ~/bin/license.

## Features

### Bundled scripts

- [ack](http://betterthangrep.com/) - Ack, better than grep
- [markdown](http://daringfireball.net/projects/markdown/) - Markdown to HTML

### Useful aliases/functions
- `ip` Output your external IP.
- `server` Start a HTTP server in current path.
- `license` Output a MIT license file.
- `extract` Extract content from a compressed file.
- `bu` Backup current directory to ~/.backup.
- `record_desktop` Begin screenrecording and share the video over HTTP (needs polishing).
- `psgrep` Grep trough running processes.
- `mkcdir` Create a directory and move into it.
- `calc` A proper calculator
- `bf` List the 10 biggest files in the current path.

### Bash prompt

![Bash prompt](http://i.imgur.com/2asnT.png)

## Additional suggestions

As this is often used with shell-only accessed computers I'm not including a
font but my personal preference is [Inconsolata](http://levien.com/type/myfonts/inconsolata.html) by Raph Levien.

``
mkdir -p ~/.fonts && cd ~/.fonts && wget http://levien.com/type/myfonts/Inconsolata.otf && sudo fc-cache -f -v
``

## Inspired/Stolen by

- [Gianni Chiappetta](https://github.com/gf3/dotfiles)
- [Mathias Bynens](https://github.com/mathiasbynens/dotfiles)
- [Ryan Tomayko](https://github.com/rtomayko/dotfiles)
- [Holman](https://github.com/holman/dotfiles)
- [Jan Moesen](https://github.com/janmoesen/tilde)

and more whom are referenced within the files.
