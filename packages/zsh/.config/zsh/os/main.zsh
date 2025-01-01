#!/usr/bin/env zsh
# Loads a particular OS-based ZSH configuration file.
if [[ $(uname) == "Darwin" ]]; then
  zsh-import "os" "macos/main"
  DOTFILES_ZSHRC="$DOTFILES_DIR/os/macos/main.zsh"
elif command -v pacman > /dev/null; then
  zsh-import "os" "arch/main"
  DOTFILES_ZSHRC="$DOTFILES_DIR/os/arch/main.zsh"
fi

if [[ $(uname) == "$WORK_OS" ]] && [[ $(uname -n) == "$WORK_ID" ]]; then
  zsh-import "work"
fi
