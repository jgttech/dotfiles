#!/usr/bin/env bash
# Runs a script using a cosistent standard.
function script {
  name="${1:-""}"

  if [[ "$name" == "" ]]; then
    echo "Must supply a script name"
    exit 1
  fi

  source "$DOTFILES_HOME/bin/scripts/$name/main.sh" $@
}

function dotfiles {
  case "$1" in
    install) source "$DOTFILES_BUILD/install"; ;;
    uninstall) source "$DOTFILES_BUILD/uninstall"; ;;
    *) echo "No \"$1\" build file found"; ;;
  esac
}
