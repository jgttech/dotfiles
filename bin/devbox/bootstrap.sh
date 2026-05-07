#!/usr/bin/env bash
source "$DOTFILES_HOME/bin/devbox/env.sh"

for fn in "$DOTFILES_HOME/bin/devbox/functions"/*; do
  source "$fn"
done
