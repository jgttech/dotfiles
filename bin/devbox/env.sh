#!/usr/bin/env bash
# Default environment variables.
export DOTFILES_VERSION="$(yq -r '.version' "$DOTFILES_CONFIG")"
