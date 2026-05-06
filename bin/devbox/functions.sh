#!/usr/bin/env bash
# Runs a script using a cosistent standard. To invoke a sub-script
# under a scripts directory use a dot (".") delimiter.
#
# Example:
# script foo     # Runs the bin/scripts/foo/main.sh
# script foo.bar # Runs the bin/scripts/foo/bar.sh
function script {
  IFS="." read -ra parts <<< "${1:-""}"
  name="${parts[0]}"
  sub_script="${parts[1]:-""}"

  if [[ "$name" == "" ]]; then
    echo "Must supply a script name"
    exit 1
  fi

  if [[ "$sub_script" == "" ]]; then
    source "$DOTFILES_HOME/bin/scripts/$name/main.sh" "$@"
  else
    source "$DOTFILES_HOME/bin/scripts/$name/${sub_script}.sh" "$@"
  fi
}

function dotfiles {
  case "$1" in
    install) source "$DOTFILES_BUILD/install"; ;;
    uninstall) source "$DOTFILES_BUILD/uninstall"; ;;
    *) echo "No \"$1\" build file found"; ;;
  esac
}
