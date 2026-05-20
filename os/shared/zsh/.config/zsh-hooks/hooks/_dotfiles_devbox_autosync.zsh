#!/usr/bin/env zsh
# Auto-reconcile the global devbox env on source-of-truth drift.
# Fingerprints $(devbox global path)/devbox.{json,lock} on every prompt; on
# mismatch, runs `devbox global install` and re-evals shellenv. Fingerprint
# advances only on success so failures retry next prompt. When the clone is
# pushable (set by `just unlock`), also auto-commits + pushes manifest
# changes — same gating model as the brew autobackup hook.
# Opt-outs: DOTFILES_DEVBOX_AUTOSYNC=0 (whole hook), DOTFILES_DEVBOX_AUTOCOMMIT=0
# (keep reconciling, skip commit+push even when unlocked).

# Derive a commit message from the devbox.json diff. Treats only quoted-string
# array entries (the `packages` shape) as actions; key:value pairs like the
# schema URL are filtered out. Packages appearing in both +/- (pure
# reformatting churn like a trailing-comma flip) are dropped.
_dotfiles_devbox_commit_msg() {
  local manifest="$1" host="$2"
  local line verb pkg
  local -A adds removes
  while IFS= read -r line; do
    case "$line" in
      "+++"*|"---"*) continue ;;
      "+"*) verb="add" ;;
      "-"*) verb="rm" ;;
      *) continue ;;
    esac
    if [[ "${line:1}" =~ '^[[:space:]]*"([^":]+)"[[:space:]]*,?[[:space:]]*$' ]]; then
      pkg="${match[1]}"
      [[ -n "$pkg" ]] || continue
      case "$verb" in
        add) adds[$pkg]=1 ;;
        rm)  removes[$pkg]=1 ;;
      esac
    fi
  done < <(git -C "$DOTFILES_HOME" diff -- "$manifest")

  local -a actions
  for pkg in "${(ok)removes[@]}"; do
    [[ -n "${adds[$pkg]:-}" ]] || actions+=("devbox global rm $pkg")
  done
  for pkg in "${(ok)adds[@]}"; do
    [[ -n "${removes[$pkg]:-}" ]] || actions+=("devbox global add $pkg")
  done

  (( ${#actions[@]} )) || return 1
  printf '%s: %s' "$host" "${(j:; :)actions}"
}

_dotfiles_devbox_autosync() {
  [[ "${DOTFILES_DEVBOX_AUTOSYNC:-1}" == "0" ]] && return
  [[ -o interactive ]] || return
  (( ZSH_SUBSHELL == 0 )) || return
  [[ -n "${DOTFILES_HOME:-}" && -d "$DOTFILES_HOME" ]] || return
  command -v devbox >/dev/null 2>&1 || return

  local globaldir manifest lockfile fpfile cur last host msg
  local -a repo_paths
  host="$(hostname -s)"
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

  devbox global install || return
  # Equivalent to running the `refresh-global` alias that `devbox global add`
  # tells you to run after a manifest change: --preserve-path-stack -r emits
  # a fresh shellenv block, and `hash -r` flushes zsh's command-path cache
  # so freshly-installed binaries (or freshly-removed ones) resolve correctly
  # on the next prompt without requiring a manual reload.
  eval "$(devbox global shellenv --preserve-path-stack -r)" && hash -r
  _dotfiles_fp "$manifest" "$lockfile" > "$fpfile"

  # Auto-commit + push only when the clone was authenticated by `just unlock`.
  # The manifest/lockfile in $globaldir are symlinks into $DOTFILES_HOME, so
  # any `devbox global add|rm` shows up as a working-tree diff in the repo.
  [[ "${DOTFILES_DEVBOX_AUTOCOMMIT:-1}" == "0" ]] && return
  _dotfiles_pushable || return

  repo_paths=()
  [[ -e "$DOTFILES_HOME/devbox.json" ]] && repo_paths+=("$DOTFILES_HOME/devbox.json")
  [[ -e "$DOTFILES_HOME/devbox.lock" ]] && repo_paths+=("$DOTFILES_HOME/devbox.lock")
  (( ${#repo_paths[@]} )) || return

  msg="$(_dotfiles_devbox_commit_msg "$DOTFILES_HOME/devbox.json" "$host")" || return
  _dotfiles_commit_and_push "$msg" "${repo_paths[@]}"
}

add-zsh-hook precmd _dotfiles_devbox_autosync
