#!/usr/bin/env zsh

# Configure mise
export MISE_DATA_DIR="${DOTFILES_MISE_HOME}/data"
export MISE_CACHE_DIR="${DOTFILES_MISE_HOME}/cache"
export MISE_GLOBAL_CONFIG_FILE="${DOTFILES_MISE_HOME}/config.toml"
export MISE_TMP_DIR="${DOTFILES_MISE_HOME}/tmp"

# Activate mise
eval "$(mise activate zsh)"
