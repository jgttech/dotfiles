#!/usr/bin/env zsh
export PATH="$HOME/.config/nvim/bin:$PATH"

if [[ $(uname) == "Darwin" ]]; then
  source "${DOTFILES_ZSHRC}/etc/os/darwin.zsh"
elif command -v pacman &> /dev/null; then
  source "${DOTFILES_ZSHRC}/etc/os/archlinux.zsh"
fi
