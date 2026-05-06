#!/usr/bin/env bash
# Default environment variables.
export DOTFILES_VERSION="$(yq -r '.version' "$DOTFILES_CONFIG")"
export DOTFILES_BUILD="$DOTFILES_HOME/$(yq -r '.build' "$DOTFILES_CONFIG")"
