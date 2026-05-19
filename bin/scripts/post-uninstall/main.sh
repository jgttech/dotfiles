#!/usr/bin/env bash
# Post-uninstall OS dispatcher. Sourced via the `script` helper
# (bin/devbox/functions/script.sh) so it runs in the enclosing devbox bash
# without spawning a nested `devbox run`.
case "${OSTYPE:-}" in
  darwin*) script post-uninstall.darwin "$@" ;;
esac
