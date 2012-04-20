for file in ~/.bash/{shell,commands,aliases,prompt,drush,exports,local}; do
  [ -r "$file" ] && source "$file"
done
unset file
