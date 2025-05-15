#!/usr/bin/env zsh
# The purpose of using a function is to things
# within a scoped context so that it does NOT
# pollute the global context.
dotfiles-auto-update() {
  # Check if python3 exists and use it, otherwise fallback to python
  local python_cmd=$(command -v python3 || command -v python)

  local cwd=$(pwd)
  local home=$(dotfiles-json ".home")
  local tools=$(dotfiles-json ".tools")
  local cmd="${python_cmd} ${home}/${tools}/build.py"

  cd "${home}"

  local pull_output=$(git pull 2>&1)

  if [[ "$pull_output" != *"Already up to date"* ]]; then
    echo "Updating, please wait..."
    eval "${cmd}"
  fi

  cd "${cwd}"
}

dotfiles-auto-update
