#!/usr/bin/env bash
shopt -s nullglob
host_name="$(hostname -s)"
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

# HOME-relative leaf install targets, derived from the package layout.
# A leaf is what stow folds to: a top-level file or directory in a
# package, or — when the top-level is a known shared parent like
# .config or Library — the next directory down. Pre-existing real
# (non-symlink) copies at these paths get moved aside before stow runs
# and restored on uninstall.
shared_parents=(".config" "Library")
declare -A _seen
backups=()
shopt -s dotglob
for _ctx in "${contexts[@]}"; do
  for _pkg in "$_ctx"/*; do
    [[ -d "$_pkg" ]] || continue
    for _entry in "$_pkg"/*; do
      _base="$(basename "$_entry")"
      _leaves=()
      if [[ -f "$_entry" ]]; then
        _leaves=("$_base")
      elif [[ -d "$_entry" ]]; then
        _is_shared=false
        for _sp in "${shared_parents[@]}"; do
          [[ "$_base" == "$_sp" ]] && { _is_shared=true; break; }
        done
        if $_is_shared; then
          for _sub in "$_entry"/*; do
            _leaves+=("$_base/$(basename "$_sub")")
          done
        else
          _leaves=("$_base")
        fi
      fi
      for _leaf in "${_leaves[@]}"; do
        [[ -n "${_seen[$_leaf]:-}" ]] && continue
        _seen[$_leaf]=1
        backups+=("$_leaf")
      done
    done
  done
done
shopt -u dotglob
unset _seen _ctx _pkg _entry _base _leaves _is_shared _sp _sub _leaf

if [[ -d "$DOTFILES_BUILD" ]]; then
  rm -rf "$DOTFILES_BUILD"
fi

mkdir -p "$DOTFILES_BUILD"

script build.install
script build.uninstall
script build.environment
script build.cli

echo "Done"
