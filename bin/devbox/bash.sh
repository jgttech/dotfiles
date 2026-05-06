#!/usr/bin/env bash
set -euo pipefail

export DOTFILES_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$DOTFILES_HOME"

config="$1"
shift

export DOTFILES_CONFIG="$DOTFILES_HOME/$config"

exec devbox run -q -- bash -euo pipefail -c \
  "source '$DOTFILES_HOME/bin/devbox/env.sh' && source $(printf '%q' "$1")"
