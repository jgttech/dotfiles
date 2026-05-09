#!/usr/bin/env bash
# Install the prerequisites required to run `bash install` and `just install`
# on a fresh macOS box: brew, devbox, just, yq, and (only when git is missing)
# Xcode Command Line Tools. Idempotent: skips anything already installed.
#
# Direct invocation = consent. The consent prompt lives in the calling
# `./install` script. `--yes` is accepted but no-op for compatibility.
set -euo pipefail

case "${OSTYPE:-}" in
  darwin*) ;;
  *)
    echo "[ERROR] Bootstrap currently supports macOS only. Linux support is pending." >&2
    exit 1
    ;;
esac

_extra_bindirs=(
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  "/usr/local/bin"
  "/usr/local/sbin"
  "$HOME/.local/bin"
  "$HOME/bin"
  "$HOME/.cargo/bin"
  "$HOME/go/bin"
  "$HOME/.nix-profile/bin"
  "/nix/var/nix/profiles/default/bin"
)

installed() {
  local cmd="$1" d
  command -v "$cmd" >/dev/null 2>&1 && return 0
  for d in "${_extra_bindirs[@]}"; do
    [[ -x "$d/$cmd" ]] && return 0
  done
  return 1
}

# Step 1: Homebrew (curl). Required before anything brew-installable.
if ! installed brew; then
  echo "==> Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Refresh PATH so subsequent steps can find brew.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Step 2: devbox (curl). Independent of brew.
if ! installed devbox; then
  echo "==> Installing devbox"
  curl -fsSL https://get.jetify.com/devbox | bash
fi

# Devbox installer lands binary at $HOME/.local/bin; ensure on PATH.
export PATH="$HOME/.local/bin:$PATH"

# Step 3: just (brew). Not in devbox.json, so brew is the channel.
if ! installed just; then
  echo "==> Installing just (brew)"
  brew install just
fi

# Step 4: yq (devbox). In devbox.json, so favor devbox over brew.
if ! installed yq; then
  echo "==> Installing yq (devbox global)"
  devbox global add yq
fi

# Step 5: Xcode Command Line Tools, only if git is missing. Last by design:
# the GUI dialog cannot be auto-dismissed, so anything installable headlessly
# runs first.
if ! installed git; then
  echo "==> Triggering Xcode Command Line Tools install"
  xcode-select --install || true
  echo
  echo "Xcode Command Line Tools require GUI confirmation."
  echo "Complete the install dialog, then re-run: bash install"
  exit 0
fi

echo
echo "Bootstrap complete."
