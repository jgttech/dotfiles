#!/usr/bin/env bash
set -euo pipefail
purge=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --purge) purge=true; shift ;;
    *) shift ;;
  esac
done

dotfiles uninstall
