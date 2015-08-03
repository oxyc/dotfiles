for file in ~/.bash/{local,colors,functions,exports,shell,aliases,prompt,drush,ssh-agent,overrides}.sh; do
  [ -r "$file" ] && source "$file"
done
unset file
