#!/usr/bin/env zsh
# Auto-reconcile the global devbox env on source-of-truth drift.
# Fingerprints $(devbox global path)/devbox.{json,lock} on every prompt;
# on mismatch, runs `devbox global install` and re-evals shellenv.
# Fingerprint advances only on success so failures retry next prompt.
# Opt-out: DOTFILES_DEVBOX_AUTOSYNC=0.
_dotfiles_devbox_autosync() {
  [[ "${DOTFILES_DEVBOX_AUTOSYNC:-1}" == "0" ]] && return
  [[ -o interactive ]] || return
  (( ZSH_SUBSHELL == 0 )) || return
  [[ -n "${DOTFILES_HOME:-}" && -d "$DOTFILES_HOME" ]] || return

  local globaldir manifest lockfile fpfile cur last
  globaldir="$(devbox global path 2>/dev/null)" || return
  [[ -n "$globaldir" ]] || return
  manifest="$globaldir/devbox.json"
  lockfile="$globaldir/devbox.lock"
  [[ -e "$manifest" && -e "$lockfile" ]] || return

  fpfile="$DOTFILES_HOME/devbox.fingerprint"
  cur="$(_dotfiles_fp "$manifest" "$lockfile")"
  [[ -n "$cur" ]] || return
  last=""
  [[ -r "$fpfile" ]] && last="$(<"$fpfile")"
  [[ "$cur" == "$last" ]] && return

  if devbox global install; then
    eval "$(devbox global shellenv)"
    _dotfiles_fp "$manifest" "$lockfile" > "$fpfile"
  fi
}

add-zsh-hook precmd _dotfiles_devbox_autosync
