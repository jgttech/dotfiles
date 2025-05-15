#!/usr/bin/env zsh
for file in "${DOTFILES_ZSHRC}/work/icf"/*; do
  if  [[ ! "$file" =~ "main.zsh" ]]; then
    if [[ -f "$file" ]] && [[ -r "$file" ]]; then
      source "$file"
    fi
  fi
done
