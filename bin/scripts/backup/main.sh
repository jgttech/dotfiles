#!/usr/bin/env bash
script backup.brew_backup

if installed brew; then
  host_dir="$DOTFILES_HOME/hosts/$host_name"
  host_dir+="/brew/.config/brew"

  if [[ -d "$host_dir" ]]; then
    brew_backup "$host_dir"
  fi
fi
