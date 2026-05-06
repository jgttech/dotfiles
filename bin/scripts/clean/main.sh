#!/usr/bin/env bash
set -euo pipefail
purge=false
targets=(\
  ".build" \
  ".devbox" \
  ".opencode" \
  ".DS_Store" \
)

while [[ $# -gt 0 ]]; do
  case "$1" in
    --purge) purge=true; shift ;;
    *) shift ;;
  esac
done

echo "Cleaning devbox cache..."
devbox run -- nix store gc --extra-experimental-features nix-command

if $purge; then
  echo "Purging devbox store..."
  nix-collect-garbage -d
fi

echo "Cleaning repository..."

for target in "${targets[@]}"; do
  if [[ -e "$target" ]]; then
    rm -rf "$target"
    echo " > Deleted $target"
  fi
done

echo "Done"
