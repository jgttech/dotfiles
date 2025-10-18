#!/usr/bin/env zsh
# Auto-load the .utils, first.
for util in "${DOTFILES_ZSHRC}/utils"/*; do
  if [[ -f "$util" ]] && [[ -r "$util" ]]; then
    source "$util"
  fi
done

# Auto-load the .init scripts, next.
for init in "${DOTFILES_ZSHRC}/init"/*; do
  if [[ -f "$init" ]] && [[ -r "$init" ]]; then
    source "$init"
  fi
done
