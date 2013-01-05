for file in ~/.bash/{shell,functions,aliases,prompt,drush,exports,local}.sh; do
  [ -r "$file" ] && source "$file"
done
unset file
