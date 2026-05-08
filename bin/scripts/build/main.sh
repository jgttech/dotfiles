#!/usr/bin/env bash
shopt -s nullglob
host_name="$(hostname -s)"
platform="$os"
zshrc_backup="$HOME/.zshrc.$(date +%s%3N).bak"

if [[ -z "$devbox_home" ]]; then
  echo "[ERROR] 'devbox global path' returned empty. Is devbox installed?"
  exit 1
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  platform+="/darwin"
elif [[ "$OSTYPE" == "linux"* ]]; then
  platform+="/linux"
else
  echo "Unsupported OSTYPE: $OSTYPE" >&2
  exit 1
fi

contexts=(\
  "$shared" \
)

if [[ -d "$platform" ]]; then
  contexts+=("$platform")
fi

if [[ -d "$host_dir/$host_name" ]]; then
  host_dir+="/$host_name"
  contexts+=("$host_dir")
fi

if [[ -d "$DOTFILES_BUILD" ]]; then
  rm -rf "$DOTFILES_BUILD"
fi

mkdir -p "$DOTFILES_BUILD"

script build.install
script build.uninstall
script build.environment
script build.cli

echo "Done"
