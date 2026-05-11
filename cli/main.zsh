#!/usr/bin/env zsh
export DOTFILES_CLI="$DOTFILES_HOME/cli"

for file in "$DOTFILES_CLI"/*/; do
  entrypoint="$file/main.zsh"

  if [[ -f "$entrypoint" ]]; then
    source "$entrypoint"
  fi
done

dotfiles sync
