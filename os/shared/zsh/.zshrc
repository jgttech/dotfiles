#!/usr/bin/env zsh
# Hooks the devbox global packages into the shell.
eval "$(devbox global shellenv)"

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
  cur="$(stat -f '%m:%z' "$manifest" "$lockfile" 2>/dev/null)" || return
  last=""
  [[ -r "$fpfile" ]] && last="$(<"$fpfile")"
  [[ "$cur" == "$last" ]] && return

  if devbox global install; then
    eval "$(devbox global shellenv)"
    stat -f '%m:%z' "$manifest" "$lockfile" > "$fpfile"
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _dotfiles_devbox_autosync

# ORDER MATTERS
_dotfiles=(\
  # Hooks the dotfiles .build/environment into the shell.
  "$HOME/.zshrc.environment" \

  # Hook the hosts ZSH config into the shell.
  # This is where the ZSH config should live for each host.
  "$HOME/.config/zsh/main.zsh" \
)

# Track which files failed to load.
_dotfiles_failed=()

for src in "${_dotfiles[@]}"; do
  if [[ -e "$src" ]]; then
    source "$src"

    if [[ "$src" == *".zshrc.environment"* ]]; then
      source "$DOTFILES_HOME/cli/main.zsh"
    fi
  else
    _dotfiles_failed+=("$src")
  fi
done

if [[ ${#_dotfiles_failed[@]} -ne 0 ]]; then
  echo "[ERROR]"
  echo "Failed to load (${#_dotfiles_failed[@]}) dotfiles environment configs:"

  for failed in "${_dotfiles_failed[@]}"; do
    echo " - $failed"
  done

  echo
  exit 1
fi

# Just to keep the global space from being polluted.
unset _dotfiles
unset _dotfiles_failed
