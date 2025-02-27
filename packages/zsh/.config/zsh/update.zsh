#!/usr/bin/env zsh
# The purpose of using a function is to things
# within a scoped context so that it does NOT
# pollute the global context.
dotfiles_update() {
  local cwd=$(pwd)
  local home=$(dotfiles_json ".home")
  local tools=$(dotfiles_json ".tools")
  local cli=$(dotfiles_json ".cli")

  cd "${home}"

  local original_ref=$(git rev-parse HEAD)

  git pull &> /dev/null

  if [[ $(git rev-parse HEAD) != "$original_ref" ]]; then
    echo "Updating, please wait..."
    dotfiles rebuild
  fi

  # local pull_output=$(git pull)
  #
  # if [[ "$pull_output" != *"Already up to date"* ]]; then
  #   echo "Updating, please wait..."
  #   dotfiles rebuild
  # fi

  cd "${cwd}"
}

dotfiles_update
