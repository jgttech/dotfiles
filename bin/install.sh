#!/usr/bin/env bash
set -euo pipefail
# The required version of Python that must exist
# in order for the installation to work properly.
python_version="3.13"

# The repo to clone when installing dotfiles.
repo="https://github.com/jgttech/dotfiles.v2.git"

# Which platforms this supports.
platforms=("linux" "darwin")

# The name of the build configuration file.
# This file is a JSON file that gets created
# once the dotfiles are installed. It tells you
# everything about the dotfiles environment
# confguration in a single configuration file.
# With things like "jq" this information can be
# read and loaded into the ZSH environment directly
# from the JSON file, making it easy to source and
# reference about how the environment is setup. Therefore
# editing this file will edit the shell environment for
# the dotfiles that are currently built on the system.
cfg=".dotfiles.build.json"

#############################################
# CLI arguments and default values.

# The location to install the repo to. The
# location is resolve relative to the users
# $HOME environment variable. So everything
# must be relative to that context.
home=".dotfiles"

# The language to build the binary in.
# The dotfiles built-in CLI supports any
# language within the "tools" directory of
# the repo. The name of the directory should
# match the binary for the language, which some
# exceptions being TypeScript, as NodeJS
# typically can be used to install and invoke
# TS to compile to a JS runtime. So check the
# "tools" directory for the names of folders
# as the language options that can be passed
# into the install script.
#
# I should note that the purpose for having multiple
# languages for the built-in CLI is for personal
# reasons that allows me to practice implementing
# the same features for the CLI across different
# languages so I can gain more experience in different
# languages as I choose to learn them.
lang="go"

# The name of the dotfiles binary to
# invoke dotfiles CLI commands.
binary="dotfiles"

# The mode to run the installation in.
# This is only used for testing the dotfiles
# installation with Podman to simulate a new
# system install and is set in the Makefile.
dev=false
#############################################

# CLI arguments for the install script.
options="H:L:B:D"
longoptions="home:,lang:,binary:,dev"

# Dependencies for both the install script
# and the dotfiles tools themselves. I prefer
# to do this check in BASH, here, because this
# is MUCH easier to check for and fail before
# getting into the setup process, which Python
# handles.
dependencies=("getopt" "fontconfig" "python" "lua" "git" "jq" "stow" "omz" "nvm" "zip" "unzip")

# Tracks what is missing to, if something is
# missing, I can display the full list of what
# is missing instead of failing on each missing
# system package.
missing=()

# This function uses a ZSH sub-process to check it a
# binary/package exists on the system. This is required
# because the configuration uses ZSH as the default shell.
# If something it checked against the BASH shell (that
# runs this install) then I can't properly detect what
# the ZSH environment detects and can't guarentee compatibility.
# So checking against ZSH is a requirement.
installed() { zsh -i -c "which $1" &> /dev/null ; }

# Checks if your platform is supported.
supported_platform() {
  local current_platform=$(uname -s | tr '[:upper:]' '[:lower:]')
  local supported_platforms=("$@")

  for platform in "${supported_platforms[@]}"; do
    # Convert both strings to lowercase for
    # case-insensitive matching.
    platform=$(echo "$platform" | tr '[:upper:]' '[:lower:]')

    # Check if current platform contains the
    # supported_platform platform string or if supported_platform
    # platform contains the current platform string
    if \
      [[ "$current_platform" == *"$platform"* ]] || \
      [[ "$platform" == *"$current_platform"* ]]; \
    then
      return 0
    fi
  done

  return 1
}

# Checks to make sure that the correct minimum supported
# version of Python is being used in order for these
# dotfiles to work.
supported_python_version() {
  local required_version="$1"
  local required_major="${required_version%%.*}"
  local required_minor="${required_version#*.}"
  local version=$(python --version 2>&1)

  if [[ $version =~ Python[[:space:]]+([0-9]+)\.([0-9]+) ]]; then
    local major="${BASH_REMATCH[1]}"
    local minor="${BASH_REMATCH[2]}"

    if ((major > required_major)) || (( major == required_major && minor >= required_minor )); then
      return 0
    fi
  fi

  echo "[ERROR]"
  echo "Python $required_major.$required_minor or higher is required."
  echo "Current version: $version"
  return 1
}

# Make sure the current platform this is running
# on is supported_platform by the dotfiles.
if ! supported_platform "${platforms[@]}"; then
  echo "Platform NOT supported_platform: \"$(uname -s)\""
  exit 1
fi

# Unfortunately, I need to make sure that ZSH is
# installed before continuing the installation
# of the dotfiles because it is used to validate
# the existence of packages on the system.
if ! command -v "zsh" &> /dev/null; then
  echo "[NOTE]"
  echo "This install script uses ZSH to validate"
  echo "the exsitence of packages your system"
  echo "needs in order to function with these"
  echo "dotfiles."
  echo ""
  echo "[ERROR]"
  echo "ZSH required to install dotfiles. Please,"
  echo "Please install ZSH to continue."
  exit 1
fi

# Parse the CLI options.
if ! argv=$(getopt --options=$options --longoptions=$longoptions --name "$0" -- "$@"); then
  exit 1
fi

eval set -- "$argv"

while true; do
  case "$1" in
    -H|--home)
      home="$2"
      shift 2
      ;;

    -L|--lang)
      lang="$2"
      shift 2
      ;;

    -B|--binary)
      binary="$2"
      shift 2
      ;;

    -D|--dev)
      dev=true
      shift
      ;;

    --)
      shift
      break
      ;;

    *)
      echo "[ERROR]"
      echo "Expected error while parsing install arguments."
      exit 1
      ;;
  esac
done

# If we do not have the acceptable Python
# version, then we can't install the dotfiles.
# So we need to check what they are.
if ! supported_python_version "$python_version"; then
  exit 1
fi

# Add the language that was selected to the
# dependencies so that I can check if the binary
# for the language exists. Which is required to
# build the dotfiles CLI. The only exception is
# things like TypeScript that can be installed
# with NodeJS (through NVM) and does not need to
# exist prior to installing the dotfiles.
if [[ "$lang" != "ts" ]]; then
  dependencies+=("$lang")
fi

# Check which script dependencies are needed.
for dep in "${dependencies[@]}"; do
  # For whatever reason the "fc-cache",
  # "fc-list", etc, all come from the "fontconfig"
  # package. So when we are checking for that
  # package we just need to make sure that one of
  # the commands that becomes available exists to
  # validate that "fontconfig" was installed.
  if [[ "$dep" == "fontconfig" ]]; then
    if ! installed "fc-list"; then
      missing+=("$dep")
    fi
  # Outside "fontconfig" we cna use the typical
  # approach of checking each package as usual.
  else
    if ! installed "$dep"; then
      missing+=("$dep")
    fi
  fi
done

# If we have missing packages, fail the install
# and display all the missing packages.
if [[ ${#missing[@]} -ne 0 ]]; then
  echo "[ERROR]"
  echo "Missing (${#missing[@]}) required dependencies:"

  for missing in "${missing[@]}"; do
    echo " $missing"
  done

  exit 1
fi

home_dir="$HOME/$home"
tools_dir="tools/$lang"
install_dir="$home_dir/bin/install"

if [[ "$dev" == false ]]; then
  if [[ ! -d "$home_dir" ]]; then
    git clone "$repo" "$home_dir"
  else
    echo "[WARNING]"
    echo "Dotfiles already installed. To uninstall"
    echo "them, run the 'purge' command with the"
    echo "dotfiles CLI."
    echo ""
    echo "If you are unsure command you can use,"
    echo "you can verify it by checking the build"
    echo "configuration file."
    echo ""
    echo "Here is a command:"
    echo "cat ~/$cfg | jq '.build.binary' | tr -d '\"'"
    exit 0
  fi
fi

if [[ ! -d "$home_dir/$tools_dir" ]]; then
  echo "[ERROR]"
  echo "Language not supported: $lang"
  exit 1
fi

if [[ ! -d "$home_dir" ]]; then
  echo "[ERROR]"
  echo "Failed. Unable to clone repo."
  exit 1
fi

if [[ ! -d "$install_dir" ]]; then
  echo "[ERROR]"
  echo "Failed. Missing install scripts."
  exit 1
fi

echo "Installing NodeJS LTS..."
zsh -i -c "nvm install --lts; nvm use --lts --default";

echo "Installing dotfiles..."

# Run the installation process using Python.
# It is just WAY easier to do complex setup
# with Python than it is in BASH.
python "$install_dir" \
  --home="$home_dir" \
  --tools="$tools_dir" \
  --binary="$binary" \
  --config="$cfg"

echo "Reloading font cache..."
# Reload font cache to load custom user
# fonts into the system.
fc-cache -f -v

if [[ "$(fc-list | grep -c 'MesloLGS NF')" -le 0 ]]; then
  echo "[WARNING]"
  echo "Failed to load fonts for 'MesloLGS NF'"
fi

if [[ $? -ne 0 ]]; then
  echo "[ERROR]"
  echo "Status Code: $?"
  echo "Unexpected error occured, cleaning up..."

  if [[ -d "$home_dir" ]]; then
    rm -rf "$home_dir"
  fi

  exit 0
else
  echo -e "\n"
  echo "Done"
fi
