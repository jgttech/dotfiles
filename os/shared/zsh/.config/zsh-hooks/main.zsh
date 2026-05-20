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
_dotfiles_zsh_hooks_root="$HOME/.config/zsh-hooks"

# Shared helpers (BSD/GNU stat, pushable gate, repo-busy check, commit/push)
# load before any hook so every hook can use them.
for _libfile in "$_dotfiles_zsh_hooks_root"/lib/*.zsh(N); do
  source "$_libfile"
done

for _hook in "$_dotfiles_zsh_hooks_root"/hooks/*(N); do
  source "$_hook"
done

unset _dotfiles_zsh_hooks_root _libfile _hook
