#!/usr/bin/env bash
set -euo pipefail

export DOTFILES_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$DOTFILES_HOME"

config="$1"
shift

export DOTFILES_CONFIG="$DOTFILES_HOME/$config"

if [[ ! -d "$DOTFILES_HOME/.devbox" ]]; then
  devbox install
fi

exec devbox run -q -- bash -euo pipefail -c \
  "source $(printf '%q' "$DOTFILES_HOME/bin/devbox/bootstrap.sh") && source$(printf ' %q' "$@")"
