#!/usr/bin/env bash
set -euo pipefail

# Manually set to "false" when ready for production use.
# This internal flag is used to make sure we don't pull
# from real commited code unintentionally.
dev=${DOTFILES_DEV:-false}

# Working directory when the script was called.
# Used to keep track of the origin directory path
# so that the user can be placed back in the same
# path when the installation finishes.
wd=`pwd`

# Set the base directory for where the repo is going
# to be. However, the user can use "DOTFILES_DIR" to
# override where things are down loaded to.
base="${DOTFILES_DIR:-"$HOME/.dotfiles"}"

# The language that should be used to install the CLI
# and defaults to "go" as the default language.
language="${DOTFILES_LANG:-"go"}"

# Which tools we want to install.
tools="tools/$language"

# For now, I only check for the directory that this
# should be built to, but in the future I would like
# to standardize the binary installation process and
# have a standard way to verify it was built.
build="$base/.build"

# What is absolutely required to run the installation.
dependencies=("git" "stow" "jq" $language)

# Keeps track of what we do not have so that if something
# that is required is missing, we can display what that is
# and tell the user to install it.
missing=()

# Where binaries can be installed at to allow the CLI
# to be able to be referenced when the dotfiles are
# unisntalled, but not purged from the system.
bins=()

# Checks if a target binary exists.
function installed {
  command -v $1 &> /dev/null
}

# Check for any missing dependencies.
for dependency in "${dependencies[@]}"; do
  if ! installed $dependency; then
    missing+=("$dependency")
  fi
done

# If we are missing anything, display what we are
# missing so we can install it and re-run it, again.
if [[ ${#missing[@]} -ne 0 ]]; then
  echo ""
  echo -e "Please install the missing dependencies:\n"

  for dependency in "${missing[@]}"; do
    echo "$dependency"
  done

  exit 1
fi

# Clone the repo. If running again, then try to
# update the repo, if it has a ".git" dir in it.
if [[ ! -d "$base" ]]; then
  git clone https://github.com/jgttech/dotfiles.git $base
elif [[ -d "$base/.git" && "$dev" == false ]]; then
  cd $base
  git pull
  cd $wd
fi

# Parse the PATH variable into an array
IFS=':' read -ra paths <<< "$PATH"

for dir in "${paths[@]}"; do
  if [ -d "$dir" ] && [ -x "$dir" ]; then
    bins+=("$dir")
  fi
done

echo "bins: ${bins[@]}"
