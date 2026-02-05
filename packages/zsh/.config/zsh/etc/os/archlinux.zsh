#!/usr/bin/env zsh
autoload -Uz compinit
compinit

[[ -d "/home/linuxbrew/.linuxbrew" ]] && {
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)";
}

local brave_bin="/usr/bin/brave"
local lock="$HOME/.config/BraveSoftware/Brave-Browser/SingletonLock"

# Verify system binary exists
if [[ ! -x "$brave_bin" ]]; then
  echo "Error: $brave_bin not found or not executable" >&2
  return 1
fi

# Handle stale lock file
if [[ -L "$lock" ]]; then
  local pid="${$(readlink "$lock")##*-}"

  if ! kill -0 "$pid" 2>/dev/null; then
    rm "$lock"
  fi
fi
