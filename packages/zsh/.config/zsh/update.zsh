#!/usr/bin/env zsh
# The purpose of using a function is to things
# within a scoped context so that it does NOT
# pollute the global context.
dotfiles_update() {
  local updated=false
  local cwd=`pwd`
  local home=`dotfiles_json ".home"`
  local tools=`dotfiles_json ".tools"`
  local cli=`dotfiles_json ".cli"`
  local current_hash=`git rev-parse HEAD`

  cd "${home}"
  git pull &> /dev/null
  git fetch &> /dev/null

  local update_hash=`git rev-parse HEAD`
  if [[ "${current_hash}" != "${update_hash}" ]]; then
    update=true
  fi

  echo "REBUILD: ${cli}"

  # If there was an updated change, the command
  # used to build the CLI is re-run exactly as it
  # was when the inital install happened, which will
  # update the CLI to a newer version.
  if [[ "${updated}" == true ]]; then
    cd "${home}/${tools}"
    eval "${cli}"
  fi

  cd "${cwd}"
}

dotfiles_update
