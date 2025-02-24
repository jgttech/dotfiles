#!/usr/bin/env zsh
source "$DOTFILES_ZSHRC/utils/require.zsh"

# The "core" path is where all the custom
# ZSH utilities exist and are loaded from.
for dir in "${DOTFILES_ZSHRC}/shell"/*; do
  if [ -d "$dir" ]; then
    require "$dir"
  fi
done
