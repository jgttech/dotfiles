#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

# Mirrors the context resolution in bin/scripts/build/main.sh so the doctor
# reports on exactly what the build pipeline would act on.
host_name="$(hostname -s)"
host_dir="$DOTFILES_HOME/hosts/$host_name"
shared="$DOTFILES_HOME/os/shared"

case "$OSTYPE" in
  darwin*) platform="$DOTFILES_HOME/os/darwin"; os_label="macOS" ;;
  linux*)  platform="$DOTFILES_HOME/os/linux"; os_label="Linux" ;;
  *)       platform=""; os_label="UNSUPPORTED ($OSTYPE)" ;;
esac

contexts=()
[[ -d "$shared"   ]] && contexts+=( "$shared"   )
[[ -n "$platform" && -d "$platform" ]] && contexts+=( "$platform" )
[[ -d "$host_dir" ]] && contexts+=( "$host_dir" )

hr() { printf -- '─%.0s' $(seq 1 80); echo; }
section() { echo; hr; echo "$1"; hr; }

section "Environment"
printf '  %-18s %s\n' "DOTFILES_HOME"    "${DOTFILES_HOME:-<unset>}"
printf '  %-18s %s\n' "DOTFILES_BUILD"   "${DOTFILES_BUILD:-<unset>}"
printf '  %-18s %s\n' "DOTFILES_CONFIG"  "${DOTFILES_CONFIG:-<unset>}"
printf '  %-18s %s\n' "DOTFILES_VERSION" "${DOTFILES_VERSION:-<unset>}"
printf '  %-18s %s\n' "OS"               "$os_label ($OSTYPE)"
printf '  %-18s %s\n' "Hostname"         "$host_name"

section "Resolved contexts"
if (( ${#contexts[@]} == 0 )); then
  echo "  (none — neither shared, platform, nor host context exists)"
else
  for ctx in "${contexts[@]}"; do
    echo "  $ctx"
    pkgs=( "$ctx"/*/ )
    if (( ${#pkgs[@]} == 0 )); then
      echo "    (no packages)"
    else
      for p in "${pkgs[@]}"; do
        echo "    • $(basename "$p")"
      done
    fi
  done
fi

# Note expected-but-missing contexts so it's clear when a layer is opt-in.
missing_ctx=()
[[ ! -d "$shared"   ]] && missing_ctx+=( "$shared (shared layer)" )
[[ -n "$platform" && ! -d "$platform" ]] && missing_ctx+=( "$platform (platform layer — empty is fine)" )
[[ ! -d "$host_dir" ]] && missing_ctx+=( "$host_dir (host overlay — empty is fine)" )
if (( ${#missing_ctx[@]} > 0 )); then
  echo
  echo "  Not present:"
  for m in "${missing_ctx[@]}"; do
    echo "    · $m"
  done
fi

section "Build artifacts"
all_built=true
for f in install uninstall environment; do
  path="$DOTFILES_BUILD/$f"
  if [[ -f "$path" ]]; then
    echo "  ✓ $path"
  else
    echo "  ✗ $path (missing)"
    all_built=false
  fi
done
if ! $all_built; then
  echo
  echo "  Run 'just build' to generate."
fi

section "Stow status (per-package dry run)"
if (( ${#contexts[@]} == 0 )); then
  echo "  (skipped — no contexts)"
elif ! command -v stow >/dev/null 2>&1; then
  echo "  (skipped — 'stow' not on PATH)"
else
  for ctx in "${contexts[@]}"; do
    pkgs=()
    for d in "$ctx"/*/; do
      pkgs+=( "$(basename "$d")" )
    done
    (( ${#pkgs[@]} == 0 )) && continue

    echo "  $ctx"
    for pkg in "${pkgs[@]}"; do
      out="$(stow --no -v -t "$HOME" -d "$ctx" "$pkg" 2>&1 || true)"
      # Drop the simulation-mode disclaimer and stow's own framing; leave only
      # actionable lines (LINK / UNLINK / conflict messages).
      filtered="$(echo "$out" \
        | grep -v '^$' \
        | grep -v '^stow ' \
        | grep -v 'WARNING: in simulation mode' \
        || true)"

      if [[ -z "$filtered" ]]; then
        echo "    ✓ $pkg (in sync)"
      elif echo "$filtered" | grep -qv '^LINK: '; then
        # Anything other than pure LINK lines means stow hit a conflict.
        echo "    ✗ $pkg (conflict)"
        echo "$filtered" | sed 's/^/        /'
      else
        echo "    · $pkg (not linked yet — run 'just install')"
      fi
    done
  done
fi

section "Environment hookup"
env_link="$HOME/.zshrc.environment"
if [[ -L "$env_link" ]]; then
  target="$(readlink "$env_link")"
  if [[ -e "$env_link" ]]; then
    echo "  ✓ $env_link -> $target"
  else
    echo "  ✗ $env_link -> $target (broken — target does not exist)"
  fi
elif [[ -e "$env_link" ]]; then
  echo "  ! $env_link exists but is not a symlink"
else
  echo "  ✗ $env_link (not present — run 'just install')"
fi

echo
