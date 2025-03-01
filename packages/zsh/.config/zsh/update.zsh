#!/usr/bin/env zsh
# The purpose of using a function is to things
# within a scoped context so that it does NOT
# pollute the global context.
dotfiles_update() {
  # Check if python3 exists and use it, otherwise fallback to python
  local python_cmd=$(command -v python3 || command -v python)

  local cwd=$(pwd)
  local home=$(dotfiles_json ".home")
  local tools=$(dotfiles_json ".tools")
  local cmd="${python_cmd} ${home}/${tools}/build.py"

  cd "${home}"

  local pull_output=$(git pull 2>&1)

  if [[ "$pull_output" != *"Already up to date"* ]]; then
    echo "Updating, please wait..."
    eval "${cmd}"

    # Replacing 'python' in the cli command with the appropriate python command
    # local compat_cli=$(echo "$cli" | sed "s#^python#$python_cmd#")

    # Execute the command
    # eval "$compat_cli"
  fi

  cd "${cwd}"
}

dotfiles_update
