#!/usr/bin/env bash
set -euo pipefail

# Check if python3 exists and use it, otherwise fallback to python
python_cmd=$(command -v python3 || command -v python)

# The current platform the user is running on.
# This is used by some of the install utility
# functions.
current_platform=$(uname -s | tr '[:upper:]' '[:lower:]')

# This is the custom font that is installed
# when stow links the packages into the system.
font_family="MesloLGS NF"

# The required version of Python that must exist
# in order for the installation to work properly.
python_version="3.13"

# The repo to clone when installing dotfiles.
repo="https://github.com/jgttech/dotfiles.v2.git"

# Where the CLI is setup at within the dotfiles.
# This path is linked, via stow, into the system.
build_out=".build"

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
config=".dotfiles.build.json"

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
#
# If dependencies are missing, the user needs
# to lookup their platforms approach to install
# the missing dependencies. The one things this
# install script does not handle is installing
# dependencies. It just checks for them. This is
# because maintianing install methods are various
# Linux and MacOS distro's and/or versions is a
# LOT of work and not what these tools are for.
dependencies=( \
  "getopt" \
  "base64" \
  "lua" \
  "git" \
  "jq" \
  "stow" \
  "omz" \
  "nvm" \
  "zip" \
  "unzip" \
  "rg" \
  "fd" \
  "fzf" \
)

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

# Check if the platform matches whatever platform we are
# looking for. This is done to allow platform specifc
# commands to be run for things like reloading system fonts
# and other platform specific needs.
is_platform() {
  local desired_platform="$1"

  # Check if current platform contains the
  # supported_platform platform string or if supported_platform
  # platform contains the current platform string
  if \
    [[ "$current_platform" == *"$desired_platform"* ]] || \
    [[ "$desired_platform" == *"$current_platform"* ]]; \
  then
    return 0
  fi

  return 1
}

# Checks to make sure that the correct minimum supported
# version of Python is being used in order for these
# dotfiles to work.
supported_python_version() {
  local required_version="$1"
  local required_major="${required_version%%.*}"
  local required_minor="${required_version#*.}"
  local version=$($python_cmd --version 2>&1)

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
  echo "Please install ZSH and re-run the script."
  exit 1
fi

# At one point, I was using gnu-getopt on macOS
# for compatibility purposes. However, if gnu-getopt
# is setup in your PATH properly, BEFORE the macOS
# default BSD-based getopt, then the GNU-based getopt
# an be used. For now, this is left in here this way
# because I may need to change that back in the future.
getopt_cmd="getopt"

# Parse the CLI options.
if ! argv=$($getopt_cmd --options=$options --longoptions=$longoptions --name "$0" -- "$@"); then
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
      echo "Unexpected error while parsing install arguments."
      exit 1
      ;;
  esac
done

# If we do not have the acceptable Python
# version, then we can't install the dotfiles.
# So we need to verify what the Python version is.
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

if is_platform "linux"; then
  dependencies+=("fontconfig")
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

# The paths we need to build the commands used
# to install the dotfiles.
home_dir="$HOME/$home"
tools_dir="tools/$lang"
install_module="${home_dir}/bin/install.py"

if [[ "$dev" == false ]]; then
  if [[ ! -d "${home_dir}" ]]; then
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
    echo "cat ~/$config | jq '.binary' | tr -d '\"'"
    exit 0
  fi
fi

if [[ ! -d "$home_dir" ]]; then
  echo "[ERROR]"
  echo "Failed. Unable to clone repo."
  exit 1
fi

if [[ ! -d "$home_dir/$tools_dir" ]]; then
  echo "[ERROR]"
  echo "Failed. Language not supported: $lang"
  exit 1
fi

if [[ ! -f "$install_module" ]]; then
  echo "[ERROR]"
  echo "Failed. Unable to invoke install module."
  exit 1
fi

echo "Installing NodeJS LTS..."
zsh -i -c "nvm install --lts; nvm use --lts --default";

# Step 1:
# Generates the environment config. This config
# drives basically everything that has to do with
# the dotfiles and the built-in CLI. Including
# bulding the CLI, itself.
${python_cmd} ${install_module} \
  --home="$home_dir" \
  --tools="$tools_dir" \
  --binary="$binary" \
  --config="$config" \
  --out="$build_out"

# Step 2:
# Invokes the command that builds the dotfiles CLI
# and symlinks it into the system.
${python_cmd} ${home_dir}/${tools_dir}/build.py

# Step 3:
# Invokes the install command with the dotfiles CLI.
# This links directly to the CLI binary/entrypoint
# because this is more reliable than relying on the
# symlink, though, that might change later. This will
# do the work of managing and linking the packages in
# the system.
${home_dir}/${build_out}/cli/${binary} install

echo "Reloading fonts, please wait..."

# Reload font cache to load custom user
# fonts into the system. We want to this
# even if the user does have an error because
# it is possible that the fonts either did not
# get installed or something else unexpected has
# happened and this would, technically, reload
# the system fonts so that if/when we check we
# can be sure the latest version of the fonts
# in the system are what we are looking at.
if is_platform "linux"; then
  fc-cache -f -v
  cnt=$(fc-list | grep -c "$font_family")

  # During dependency checking, we verify that "fontconfig"
  # is installed, so this should work, as expected.
  if [[ "${cnt}" -le 0 ]]; then
    echo "[WARNING]"
    echo "Failed to load fonts for '$font_family'"
  fi
elif is_platform "darwin"; then
  atsutil databases –removeUser
  atsutil server –shutdown
  atsutil server –ping
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
  echo "Done"
fi
