#!/usr/bin/env zsh

function is_installed {
  # Check if a value is provided.
  if [ -z "$1" ]; then
    return 1
  fi

  # Try checking the 'type'. This
  # is builtin and reliable, generally.
  if type "$1" >/dev/null 2>&1; then
    return 0
  fi

  # Fallback to 'which'.
  if which "$1" >/dev/null 2>&1; then
    return 0
  fi

  # Last resort: try to execute with --version or --help
  # (some programs exist but aren't in PATH detection).
  if "$1" --version >/dev/null 2>&1 || "$1" --help >/dev/null 2>&1; then
    return 0
  fi

  return 1
}
