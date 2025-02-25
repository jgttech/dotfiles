#!/usr/bin/env zsh
# The purpose of using a function is to things
# within a scoped context so that it does NOT
# pollute the global context.
dotfiles_update() {
  local cwd=`pwd`
  local home=`dotfiles_json ".home"`

  cd ${home}
  git pull
  git fetch

  cd ${cwd}
}

dotfiles_update
