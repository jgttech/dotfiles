#!/usr/bin/env bash
host_name="$(hostname -s)"
script backup.brew_backup

if installed brew; then
  host_target="$DOTFILES_HOME/hosts/$host_name"
  host_target+="/brew/.config/brew"

  if [[ -d "$host_target" ]]; then
    brew_backup "$host_target"
  fi
fi
