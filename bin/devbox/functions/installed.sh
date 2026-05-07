#!/usr/bin/env bash
# Common install locations a binary may live in that aren't yet on PATH —
# typical right after a fresh install where the user hasn't restarted their shell.
_extra_bindirs=(
  "/opt/homebrew/bin"                     # Homebrew (Apple Silicon)
  "/opt/homebrew/sbin"
  "/usr/local/bin"                        # Homebrew (Intel) / generic
  "/usr/local/sbin"
  "$HOME/.local/bin"                      # XDG user bin (devbox installer lands here)
  "$HOME/bin"                             # legacy user bin
  "$HOME/.cargo/bin"                      # rust / cargo install
  "$HOME/go/bin"                          # go install
  "$HOME/.nix-profile/bin"                # nix profile (single-user)
  "/nix/var/nix/profiles/default/bin"     # nix profile (multi-user)
)

# True if $1 is invokable, including in common install locations not yet on PATH.
installed() {
  local cmd="$1" d

  # Layer 1: PATH (binaries, shims, functions, aliases, builtins).
  command -v "$cmd" >/dev/null 2>&1 && return 0

  # Layer 2: common install locations that may not be on PATH yet.
  for d in "${_extra_bindirs[@]}"; do
    if [[ -x "$d/$cmd" ]]; then
      echo "[hint] Found '$cmd' at $d/$cmd — not on PATH yet." >&2
      echo "       Open a new shell or 'export PATH=\"$d:\$PATH\"' to use it." >&2
      return 0
    fi
  done

  return 1
}
