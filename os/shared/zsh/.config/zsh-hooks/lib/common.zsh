#!/usr/bin/env zsh
# Shared helpers for dotfiles precmd hooks. Sourced by main.zsh before any
# individual hook, so every hook can rely on these being defined.

# GNU stat (Linux) vs BSD stat (macOS) take different flags; try both so the
# same hook code works across platforms.
_dotfiles_fp() { stat -c '%Y:%s' "$@" 2>/dev/null || stat -f '%m:%z' "$@" 2>/dev/null; }

# True when `just unlock` has marked this clone authoritative for autobackup
# commits + pushes. Locked clones leave git history and the remote alone.
_dotfiles_pushable() {
  [[ -n "${DOTFILES_HOME:-}" ]] || return 1
  [[ "$(git -C "$DOTFILES_HOME" config --get dotfiles.pushable 2>/dev/null)" == "true" ]]
}

# True when the repo is mid-merge/rebase/cherry-pick/revert. Hooks should
# refuse to auto-commit into a partial operation the user is driving by hand.
_dotfiles_repo_busy() {
  [[ -n "${DOTFILES_HOME:-}" ]] || return 1
  local d
  for d in MERGE_HEAD REBASE_HEAD CHERRY_PICK_HEAD REVERT_HEAD; do
    [[ -e "$DOTFILES_HOME/.git/$d" ]] && return 0
  done
  return 1
}

# Commit a specific set of paths with a given message, then fire a detached
# push so a slow network / auth prompt can't stall the prompt. Returns
# non-zero (without committing) when there's nothing to commit, when any of
# the paths already has staged changes (user mid-edit), or when the repo is
# busy. Transient push failures retry on the next hook firing.
_dotfiles_commit_and_push() {
  local msg="$1"; shift
  [[ -n "$msg" ]] || return 1
  (( $# )) || return 1
  [[ -n "${DOTFILES_HOME:-}" ]] || return 1

  local p any_diff=0
  for p in "$@"; do
    git -C "$DOTFILES_HOME" diff --quiet -- "$p" || { any_diff=1; break; }
  done
  (( any_diff )) || return 1

  for p in "$@"; do
    git -C "$DOTFILES_HOME" diff --cached --quiet -- "$p" || return 1
  done

  _dotfiles_repo_busy && return 1

  git -C "$DOTFILES_HOME" commit --quiet -m "$msg" -- "$@" >/dev/null 2>&1 || return 1

  ( cd "$DOTFILES_HOME" && git push --quiet >/dev/null 2>&1 & ) >/dev/null 2>&1
}
