for file in ~/.bash/{shell,commands,aliases,prompt,extra}; do
    [ -r "$file" ] && source "$file"
done
unset file
