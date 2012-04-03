for file in ~/.bash/{shell,commands,aliases,prompt,drush,extra}; do
    [ -r "$file" ] && source "$file"
done
unset file
