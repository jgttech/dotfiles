#!/usr/bin/env zsh
function require {
  local dir="$1"
  local file="${2:-"main"}"
  local import="${dir}/${file}.zsh"

  if [[ -f "$import" ]]; then
    source "$import"
  else
    echo "Failed to load utils: $import"
    exit 1
  fi
}

