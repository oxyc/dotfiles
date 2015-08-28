#!/bin/bash
# Source: http://nuvole.org/sites/default/files/drush-bash-tricks.txt

# Drush-Bash tricks 0.1
# Copyright Nuvole 2010.
# License: GPL 3, see http://www.gnu.org/licenses/gpl.html

# For a quick start: copy this entire file to the end of the .bashrc
# file in your home directory and it will be enabled at your next
# login. See http://nuvole.org/node/26 for more details and options.

# Use a local drush version if installed.
drush() {
  local root="$(git rev-parse --show-cdup 2>/dev/null || echo 0)"
  local drush="$(which drush)"
  if [[ "$root" != "0" ]] && [[ -a "${root:-.}/composer.json" ]]; then
    [[ ! -z "$root" ]] && pushd $root >/dev/null
    local bin=$(composer config bin-dir)
    [[ -x "$bin/drush" ]] && drush="$(realpath $bin/drush)"
    [[ ! -z "$root" ]] && popd >/dev/null
  fi
  $drush $@
}

# Drupal and Drush aliases.
# To be added at the end of .bashrc.
alias drsp='cp sites/default/default.settings.php sites/default/settings.php'
alias drcc='drush cache-clear all'
alias drdb='drush updb && drush cc all'
alias drdu='drush sql-dump --ordered-dump --result-file=dump.sql'
alias dren='drush pm-enable'
alias drdis='drush pm-disable'
alias drf='drush features'
alias drfd='drush features-diff'
alias drfu='drush -y features-update'
alias drfr='drush -y features-revert'
alias drfra='drush -y features-revert all'
alias dr='drush'

_drupal_root() {
  # Go up until we find index.php
  current_dir=`pwd`;
  while [ ${current_dir} != "/" -a -d "${current_dir}" -a \
          ! -f "${current_dir}/index.php" ] ;
  do
    current_dir=$(dirname "${current_dir}") ;
  done
  if [ "$current_dir" == "/" ] ; then
    exit 1 ;
  else
    echo "$current_dir" ;
  fi
}

_drupal_modules_in_dir() {
  COMPREPLY=( $( compgen -W '$( command find $1 -regex ".*\.module" -exec basename {} .module \; 2> /dev/null )' -- $cur  ) )
}

_drupal_modules() {
  local cur
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  local drupal_root=`_drupal_root` && \
  _drupal_modules_in_dir "$drupal_root/sites $drupal_root/profiles $drupal_root/modules"
}

_drupal_features_in_dir() {
  COMPREPLY=( $( compgen -W '$( command find $1 -regex ".*\.features.inc" -exec basename {} .features.inc \; 2> /dev/null )' -- $cur  ) )
}

_drupal_features() {
  local cur
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  local drupal_root=`_drupal_root` && \
  _drupal_features_in_dir "$drupal_root/sites/all/modules $drupal_root/modules"
}

cdd() {
  local drupal_root=`_drupal_root` && \
  if [ "$1" == "" ] ; then
    cd "$drupal_root";
  else
    cd `find $drupal_root -regex ".*/$1\.module" -exec dirname {} \;`
  fi
}

complete -F _drupal_modules dren
complete -F _drupal_modules drdis
complete -F _drupal_features drfr
complete -F _drupal_features drfu
complete -F _drupal_features drfd
complete -F _drupal_modules cdd

# Drush alias cd, change into a drush alias directory.
drcd() {
  local alias="$1";
  if [[ ${alias:0:1} != '@' ]]; then
    alias="@${alias}"
  fi
  if [[ ! ($alias =~ *.\..*) ]]; then
    alias="${alias}.dev"
  fi

  cd $(drush dd $alias)
}

# Add tab completion for drush aliases
[[ -e /etc/drush/aliases ]] && complete -o "default" -o "nospace" -W "$(ls -1 /etc/drush/aliases | grep .aliases | sed 's/\.[^ ]*/ /g')" drcd
