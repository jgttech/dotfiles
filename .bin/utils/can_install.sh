#!/usr/bin/env bash
function can_install {
  local pkg="$1"

  pacman -Q | grep "${pkg} " &>/dev/null; if [[ $? != 0 ]]; then
    echo -e "$(red "❌") $pkg $(dim "(not installed)")" 
    return 0
  else
    echo -e "$(green "✔️") $pkg $(dim "(already installed)")"
    return 1
  fi
}
