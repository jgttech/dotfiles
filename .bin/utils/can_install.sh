#!/usr/bin/env bash
function can_install {
  local pkg="$1"
  printf "$pkg\t"

  which $pkg &>/dev/null; if [[ $? != 0 ]]; then
    echo -e"$(red "❌") $(dim "not installed")" 
    return 0
  else
    echo -e "$(green "✔️")  $(dim "(already installed)")"
    return 1
  fi
}
