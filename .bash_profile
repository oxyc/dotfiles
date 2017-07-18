for file in "$(dirname "$BASH_SOURCE")"/.bash/{colors,linux,functions,exports,shell,completions,aliases,prompt,drush,ssh-agent,overrides}.sh; do
  [ -r "$file" ] && source "$file"
done
unset file
