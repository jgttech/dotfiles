#!/usr/bin/env bash
set -euo pipefail
build=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --build) build=true; shift ;;
    *) shift ;;
  esac
done

if $build; then
  just build
fi

dotfiles install
