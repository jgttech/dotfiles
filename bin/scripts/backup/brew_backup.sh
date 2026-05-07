#!/usr/bin/env bash
function brew_backup {
  local location="${1:-""}"

  if [[ ! -d "$location" ]]; then
    mkdir -p "$location"
  fi

  brewfile="$location/Brewfile"

  if [[ -f "$brewfile" ]]; then
    rm -f "$brewfile"
  fi

  brew bundle dump --file="$brewfile"
}
