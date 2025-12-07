#!/usr/bin/env zsh
for file in "${DOTFILES_ZSH_HOME}/etc/work/icf"/*; do
  if  [[ ! "$file" =~ "main.zsh" ]]; then
    if [[ -f "$file" ]] && [[ -r "$file" ]]; then
      source "$file"
    fi
  fi
done
