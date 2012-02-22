# This might seem backwards.
# https://github.com/janmoesen/tilde/blob/master/.bashrc

for file in ~/.bash/{exports}; do
    [ -r "$file" ] && source "$file"
done
unset file

[ -n "$PS1" ] && source ~/.bash_profile;
