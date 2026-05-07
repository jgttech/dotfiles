#!/usr/bin/env bash
shopt -s nullglob

zshrc_backup="$HOME/.zshrc.$(date +%s%3N).bak"

brewfile="$DOTFILES_HOME/hosts/$host_name/brew/.config/brew/Brewfile"

devbox_home="$(devbox global path 2>/dev/null)"
outdir="$DOTFILES_BUILD"

host_dir="$DOTFILES_HOME/hosts"
host_name="$(hostname -s)"

os="$DOTFILES_HOME/os"
shared="$os/shared"
platform="$os"

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

if [[ -d "$outdir" ]]; then
  rm -rf "$outdir"
fi

mkdir -p "$outdir"

script build.install
script build.uninstall
script build.environment
script build.cli

echo "Done"
