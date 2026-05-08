#!/usr/bin/env bash
# Default environment variables.
export DOTFILES_VERSION="$(yq -r '.version' "$DOTFILES_CONFIG")"
export DOTFILES_BUILD="$DOTFILES_HOME/$(yq -r '.build' "$DOTFILES_CONFIG")"

# System host
host_dir="$DOTFILES_HOME/hosts"

# Homebrew
brewfile="\$HOME/.config/brew/Brewfile"

# Devbox
devbox_home="$(devbox global path 2>/dev/null)"

# Dotfiles resources
os="$DOTFILES_HOME/os"
shared="$os/shared"
