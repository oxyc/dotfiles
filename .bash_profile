for file in ~/.bash/{colors,shell,functions,aliases,prompt,drush,exports,local}.sh; do
  [ -r "$file" ] && source "$file"
done
unset file
