for file in ~/.bash/{colors,functions,shell,aliases,prompt,drush,exports,local}.sh; do
  [ -r "$file" ] && source "$file"
done
unset file
