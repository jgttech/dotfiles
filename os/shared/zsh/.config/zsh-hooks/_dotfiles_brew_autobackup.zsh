#!/usr/bin/env zsh
# Auto-dump the host Brewfile on brew install state drift.
# Fingerprints $(brew --prefix)/{Cellar,Caskroom,Library/Taps} on every prompt;
# on mismatch, runs `brew bundle dump --force` against the host Brewfile.
# Fingerprint advances only on success so failures retry next prompt.
# Opt-out: DOTFILES_BREW_AUTOBACKUP=0.
_dotfiles_brew_autobackup() {
  [[ "${DOTFILES_BREW_AUTOBACKUP:-1}" == "0" ]] && return
  [[ -o interactive ]] || return
  (( ZSH_SUBSHELL == 0 )) || return
  [[ -n "${DOTFILES_HOME:-}" && -d "$DOTFILES_HOME" ]] || return
  command -v brew >/dev/null 2>&1 || return

  local brewfile fpfile prefix cur last
  brewfile="$DOTFILES_HOME/hosts/$(hostname -s)/brew/.config/brew/Brewfile"
  [[ -d "${brewfile:h}" ]] || return

  prefix="$(brew --prefix 2>/dev/null)" || return
  [[ -n "$prefix" ]] || return

  fpfile="$HOME/.config/brew/Brewfile.fingerprint"
  cur="$(stat -c '%Y:%s' "$prefix/Cellar" "$prefix/Caskroom" "$prefix/Library/Taps" 2>/dev/null)" || return
  last=""
  [[ -r "$fpfile" ]] && last="$(<"$fpfile")"
  [[ "$cur" == "$last" ]] && return

  if brew bundle dump --file="$brewfile" --force >/dev/null; then
    stat -c '%Y:%s' "$prefix/Cellar" "$prefix/Caskroom" "$prefix/Library/Taps" > "$fpfile"
  fi
}

add-zsh-hook precmd _dotfiles_brew_autobackup
