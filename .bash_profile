for file in ~/.bash/{shell,commands,aliases,prompt,drush,bash_completion,exports,local}; do
  [ -r "$file" ] && source "$file"
done
unset file
