#!/usr/bin/env zsh
export GPG_TTY=$(tty)

# Auto load any files that are not the
# "main.zsh" file from this directory.
for file in "${DOTFILES_ZSHRC}/work"/*; do
  if [[ -f "$file" ]] && [[ "$file" != *"main.zsh"* ]]; then
    source "$file"
  fi
done
