#!/usr/bin/env zsh
# Auto-dump the host Brewfile on brew install state drift.
# Fingerprints $(brew --prefix)/{Cellar,Caskroom,Library/Taps} on every prompt;
# on mismatch, runs `brew bundle dump --force` against the host Brewfile.
# Fingerprint advances only on success so failures retry next prompt.
# When `git config dotfiles.pushable` is true (set by `just unlock`), also
# auto-commits the Brewfile change and pushes asynchronously. Locked clones
# only see the file change — `git log` and the remote are left alone.
# Opt-outs: DOTFILES_BREW_AUTOBACKUP=0 (whole hook), DOTFILES_BREW_AUTOCOMMIT=0
# (keep dumping, skip commit+push even when unlocked).

# `_dotfiles_fp` is provided by lib/common.zsh (BSD/GNU stat shim).

# Derive a commit message from the Brewfile diff. Each +/- line maps to its
# equivalent brew/cask/tap/mas/vscode command so `git log --oneline` reads as
# the action you would have run by hand.
_dotfiles_brew_commit_msg() {
  local brewfile="$1" host="$2"
  local line body verb pkg
  local -a actions
  while IFS= read -r line; do
    case "$line" in
      "+++"*|"---"*) continue ;;
      "+"*) verb="install" ;;
      "-"*) verb="uninstall" ;;
      *) continue ;;
    esac
    body="${line:1}"
    case "$body" in
      'brew "'*)
        pkg="${body#brew \"}"; pkg="${pkg%%\"*}"
        actions+=("brew $verb $pkg") ;;
      'cask "'*)
        pkg="${body#cask \"}"; pkg="${pkg%%\"*}"
        actions+=("brew $verb --cask $pkg") ;;
      'tap "'*)
        pkg="${body#tap \"}"; pkg="${pkg%%\"*}"
        [[ "$verb" == "install" ]] && actions+=("brew tap $pkg") || actions+=("brew untap $pkg") ;;
      'mas "'*)
        pkg="${body#mas \"}"; pkg="${pkg%%\"*}"
        actions+=("mas $verb $pkg") ;;
      'vscode "'*)
        pkg="${body#vscode \"}"; pkg="${pkg%%\"*}"
        actions+=("vscode $verb $pkg") ;;
    esac
  done < <(git -C "$DOTFILES_HOME" diff -- "$brewfile")

  (( ${#actions[@]} )) || return 1
  printf '%s: %s' "$host" "${(j:; :)actions}"
}

_dotfiles_brew_autobackup() {
  [[ "${DOTFILES_BREW_AUTOBACKUP:-1}" == "0" ]] && return
  [[ -o interactive ]] || return
  (( ZSH_SUBSHELL == 0 )) || return
  [[ -n "${DOTFILES_HOME:-}" && -d "$DOTFILES_HOME" ]] || return
  command -v brew >/dev/null 2>&1 || return

  local brewfile fpfile prefix cur last d host msg
  local -a paths
  host="$(hostname -s)"
  brewfile="$DOTFILES_HOME/hosts/$host/brew/.config/brew/Brewfile"
  [[ -d "${brewfile:h}" ]] || return

  prefix="$(brew --prefix 2>/dev/null)" || return
  [[ -n "$prefix" ]] || return

  # Library/Taps only exists once you've tapped at least one source; filter
  # to whatever's actually on disk so a clean brew install still fingerprints.
  paths=()
  for d in Cellar Caskroom Library/Taps; do
    [[ -e "$prefix/$d" ]] && paths+=("$prefix/$d")
  done
  (( ${#paths[@]} )) || return

  fpfile="$HOME/.config/brew/Brewfile.fingerprint"
  cur="$(_dotfiles_fp "${paths[@]}")"
  [[ -n "$cur" ]] || return
  last=""
  [[ -r "$fpfile" ]] && last="$(<"$fpfile")"
  [[ "$cur" == "$last" ]] && return

  brew bundle dump --file="$brewfile" --force >/dev/null || return
  _dotfiles_fp "${paths[@]}" > "$fpfile"

  # Auto-commit + push only when the clone was authenticated by `just unlock`.
  # Locked clones stop here — the Brewfile diff is left in the working tree.
  [[ "${DOTFILES_BREW_AUTOCOMMIT:-1}" == "0" ]] && return
  _dotfiles_pushable || return

  msg="$(_dotfiles_brew_commit_msg "$brewfile" "$host")" || return
  _dotfiles_commit_and_push "$msg" "$brewfile"
}

add-zsh-hook precmd _dotfiles_brew_autobackup
