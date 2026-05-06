#!/usr/bin/env bash
set -euo pipefail
(( $# == 0 )) && exit 0

export DOTFILES_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$DOTFILES_HOME"

env_dotfiles="$DOTFILES_HOME/.env.dotfiles"

if [[ -f "$env_dotfiles" ]]; then
  source "$env_dotfiles"
else
  echo "Missing REQUIRED environment config:"
  echo -e "$env_dotfiles\n"
  exit 1
fi

export DOTFILES_CONFIG="$DOTFILES_HOME/$DOTFILES_CONFIG"

if [[ ! -d "$DOTFILES_HOME/.devbox" ]]; then
  devbox install
fi

exec devbox run -q -- bash -euo pipefail -c \
  "source $(printf '%q' "$DOTFILES_HOME/bin/devbox/bootstrap.sh") && source$(printf ' %q' "$@")"
