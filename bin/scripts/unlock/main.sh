#!/usr/bin/env bash
set -euo pipefail

if [[ ! -d "$DOTFILES_HOME/.git" ]]; then
  echo "[ERROR] $DOTFILES_HOME is not a git repo." >&2
  exit 1
fi

if ! installed gh; then
  echo "[ERROR] gh CLI is required. Install it (e.g., 'brew install gh') and try again." >&2
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "[ERROR] gh is not authenticated. Run 'gh auth login' first." >&2
  exit 1
fi

# Resolve owner/repo from the existing remote so this works for forks and
# renames without hardcoding. Handles both https and ssh URLs.
remote_url="$(git -C "$DOTFILES_HOME" config --get remote.origin.url)"
owner_repo="$(echo "$remote_url" \
  | sed -E 's|^https://github\.com/||; s|^git@github\.com:||; s|\.git$||')"

if [[ -z "$owner_repo" ]]; then
  echo "[ERROR] Could not parse owner/repo from remote URL: $remote_url" >&2
  exit 1
fi

# gh repo clone uses the protocol from 'gh config get git_protocol' (https by
# default). To use ssh: 'gh config set git_protocol ssh' before running this.
current_branch="$(git -C "$DOTFILES_HOME" rev-parse --abbrev-ref HEAD)"

echo "Unlocking $DOTFILES_HOME"
echo "  remote:  $remote_url"
echo "  repo:    $owner_repo"
echo "  branch:  $current_branch"
echo

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "Cloning $owner_repo via gh..."
gh repo clone "$owner_repo" "$tmp/dotfiles"

echo "Swapping .git/..."
mv "$DOTFILES_HOME/.git" "$DOTFILES_HOME/.git.bak"

if ! mv "$tmp/dotfiles/.git" "$DOTFILES_HOME/.git"; then
  echo "[ERROR] Failed to install new .git/. Restoring backup." >&2
  mv "$DOTFILES_HOME/.git.bak" "$DOTFILES_HOME/.git"
  exit 1
fi

rm -rf "$DOTFILES_HOME/.git.bak"

# gh repo clone checks out the default branch; restore the one we were on.
echo "Restoring branch: $current_branch"
if ! git -C "$DOTFILES_HOME" checkout "$current_branch" 2>/dev/null; then
  echo "[WARN] Could not check out '$current_branch'. Check it out manually." >&2
fi

echo
echo "Done. Remote is now:"
git -C "$DOTFILES_HOME" remote -v
