#!/usr/bin/env zsh
export DOTFILES_CLI="$DOTFILES_HOME/cli"

function dotfiles {
  local cwd="$(pwd)"
  cd "$DOTFILES_CLI" || return $?

  just "$@"
  local rc=$?

  cd "$cwd"
  return $rc
}
