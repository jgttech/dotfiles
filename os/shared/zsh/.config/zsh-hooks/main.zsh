#!/usr/bin/env zsh
# Loads every `_dotfiles_*` hook file in this directory. Each hook self-registers
# (typically via `add-zsh-hook precmd …`) and reads its own opt-out env var.
# Defaults are "on"; set the var to 0 to disable the hook for the shell session.
#
# Registry — keep in sync when adding or removing hooks:
#
#   DOTFILES_DEVBOX_AUTOSYNC   _dotfiles_devbox_autosync.zsh
#     Reconciles the global devbox env on devbox.{json,lock} drift. Runs
#     `devbox global install` and re-evals shellenv when the source-of-truth
#     fingerprint changes.
#
#   DOTFILES_BREW_AUTOBACKUP   _dotfiles_brew_autobackup.zsh
#     Re-dumps the host Brewfile when brew's Cellar/Caskroom/Taps mtimes
#     change. Keeps hosts/<host>/brew/.config/brew/Brewfile in sync with the
#     installed package state; commits stay manual via `just save`.
_dotfiles_hooks="$HOME/.config/zsh-hooks/hooks"

for hook in "${_dotfiles_hooks[@]}"/*; do
  source "$hook"
done
