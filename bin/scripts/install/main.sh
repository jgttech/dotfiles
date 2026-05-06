#!/usr/bin/env bash
set -euo pipefail

# Can't install without the fabric.
if [[ ! -d "$DOTFILES_BUILD" ]]; then
  script build "$@"
fi

dotfiles install
