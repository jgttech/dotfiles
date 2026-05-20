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

# GNU stat (Linux) vs BSD stat (macOS) take different flags; try both.
_dotfiles_brew_fp() { stat -c '%Y:%s' "$@" 2>/dev/null || stat -f '%m:%z' "$@" 2>/dev/null; }

# Derive a commit message from the Brewfile diff. Each +/- line maps to its
# equivalent brew/cask/tap/mas/vscode command so `git log --oneline` reads as
# the action you would have run by hand.
_dotfiles_brew_commit_msg() {
  local repo="$1" brewfile="$2" host="$3"
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
  done < <(git -C "$repo" diff -- "$brewfile")

  (( ${#actions[@]} )) || return 1
  printf '%s: %s' "$host" "${(j:; :)actions}"
}

_dotfiles_brew_autobackup() {
  [[ "${DOTFILES_BREW_AUTOBACKUP:-1}" == "0" ]] && return
  [[ -o interactive ]] || return
  (( ZSH_SUBSHELL == 0 )) || return
  [[ -n "${DOTFILES_HOME:-}" && -d "$DOTFILES_HOME" ]] || return
  command -v brew >/dev/null 2>&1 || return

  local brewfile fpfile prefix cur last d host pushable msg
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
  cur="$(_dotfiles_brew_fp "${paths[@]}")"
  [[ -n "$cur" ]] || return
  last=""
  [[ -r "$fpfile" ]] && last="$(<"$fpfile")"
  [[ "$cur" == "$last" ]] && return

  brew bundle dump --file="$brewfile" --force >/dev/null || return
  _dotfiles_brew_fp "${paths[@]}" > "$fpfile"

  # Auto-commit + push only when the clone was authenticated by `just unlock`.
  # Locked clones stop here — the Brewfile diff is left in the working tree.
  [[ "${DOTFILES_BREW_AUTOCOMMIT:-1}" == "0" ]] && return
  pushable="$(git -C "$DOTFILES_HOME" config --get dotfiles.pushable 2>/dev/null)"
  [[ "$pushable" == "true" ]] || return

  # Skip if the dump produced no real diff, if the Brewfile is already staged
  # (user is mid-edit), or if the repo is in a special state we shouldn't
  # silently commit into.
  git -C "$DOTFILES_HOME" diff --quiet -- "$brewfile" && return
  git -C "$DOTFILES_HOME" diff --cached --quiet -- "$brewfile" || return
  for d in MERGE_HEAD REBASE_HEAD CHERRY_PICK_HEAD REVERT_HEAD; do
    [[ -e "$DOTFILES_HOME/.git/$d" ]] && return
  done

  msg="$(_dotfiles_brew_commit_msg "$DOTFILES_HOME" "$brewfile" "$host")" || return
  [[ -n "$msg" ]] || return

  git -C "$DOTFILES_HOME" commit --quiet -m "$msg" -- "$brewfile" >/dev/null 2>&1 || return

  # Detach push so a slow network / auth prompt can't stall the user's
  # prompt; transient failures retry on the next state-changing brew command.
  ( cd "$DOTFILES_HOME" && git push --quiet >/dev/null 2>&1 & ) >/dev/null 2>&1
}

add-zsh-hook precmd _dotfiles_brew_autobackup
