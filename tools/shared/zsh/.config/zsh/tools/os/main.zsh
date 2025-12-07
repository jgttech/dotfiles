#!/usr/bin/env zsh
export PATH="$HOME/.config/nvim/bin:$PATH"

if [[ $(uname) == "Darwin" ]]; then
  source "${DOTFILES_ZSH_HOME}/tools/os/darwin.zsh"
elif command -v pacman &> /dev/null; then
  source "${DOTFILES_ZSH_HOME}/tools/os/archlinux.zsh"
fi
