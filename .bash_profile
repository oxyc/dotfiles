for file in "$(dirname "$BASH_SOURCE")"/.bash/{colors,linux,functions,exports,shell,aliases,prompt,drush,ssh-agent,overrides}.sh; do
  [ -r "$file" ] && source "$file"
done
unset file

# Clear system messages
clear
