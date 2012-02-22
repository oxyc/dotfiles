# This might seem backwards.
# https://github.com/janmoesen/tilde/blob/master/.bashrc

[ -r "$HOME/.bash/exports" ] && source "$HOME/.bash/exports"
[ -n "$PS1" ] && source ~/.bash_profile;
