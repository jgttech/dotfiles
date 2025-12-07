#!/usr/bin/env zsh
# The purpose of using a function is to things
# within a scoped context so that it does NOT
# pollute the global context.
dotfiles-auto-update() {
  local out=$(git pull 2>&1)

  if [[ "$out" != *"Already up to date"* ]]; then
    echo "Updating, please wait..."
    # dotfiles repo sync
  fi
}

# dotfiles-auto-update
