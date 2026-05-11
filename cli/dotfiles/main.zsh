#!/usr/bin/env zsh
# This is the hook for the dotfiles CLI integration point.
# It creates a boundary between what is part of the dotfiles
# system integration process and what is not. This exists to
# allow for dotfiles managed CLI features/capabilities/tools/etc
# to exist within the repo that are NOT associated with the build
# directly. The build does control system integration with this,
# but it is not required to maintain the code beyond this point.
#
# Changes here are immediately applied to the environment the
# next time the shell environment is loaded.
function dotfiles {
  local cwd="$(pwd)"
  cd "$DOTFILES_HOME" || return $?

  just "$@"
  local rc=$?

  cd "$cwd"
  return $rc
}
