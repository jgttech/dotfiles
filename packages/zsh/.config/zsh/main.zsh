#!/usr/bin/env zsh
DOTFILES_ZSH_HOME="$HOME/.config/zsh"
source "$DOTFILES_ZSH_HOME/src/require.zsh"

for dir in "$DOTFILES_ZSH_HOME/utils/"; do
  echo "$dir"
done
