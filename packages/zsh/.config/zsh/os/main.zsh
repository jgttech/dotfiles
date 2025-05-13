#!/usr/bin/env zsh
if [[ $(uname) == "Darwin" ]]; then
  source "${DOTFILES_ZSHRC}/os/darwin.zsh"
elif command -v pacman &> /dev/null; then
  source "${DOTFILES_ZSHRC}/os/archlinux.zsh"
fi

if [[ "$(uname -p)" == "arm" ]]; then
  export PATH="$HOME/.config/nvim/bin:$PATH"
fi
