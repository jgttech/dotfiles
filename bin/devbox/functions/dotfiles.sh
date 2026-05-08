#!/usr/bin/env bash
function dotfiles {
  case "$1" in
    install) source "$DOTFILES_BUILD/install"; ;;
    uninstall) source "$DOTFILES_BUILD/uninstall" "${@:2}"; ;;
    *) echo "No \"$1\" build file found"; ;;
  esac
}
