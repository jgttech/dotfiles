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

# Counters feed the final "Install state" summary. Sections call push_* as
# they emit ✓ / ✗ / · marks so the summary stays in sync with the body.
checks_ok=0
checks_fail=0
push_ok()   { checks_ok=$((checks_ok+1)); }
push_fail() { checks_fail=$((checks_fail+1)); }

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
    push_ok
  else
    echo "  ✗ $path (missing)"
    push_fail
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
        push_ok
      elif echo "$filtered" | grep -qv '^LINK: '; then
        # Anything other than pure LINK lines means stow hit a conflict.
        echo "    ✗ $pkg (conflict)"
        echo "$filtered" | sed 's/^/        /'
        push_fail
      else
        echo "    · $pkg (not linked yet — run 'just install')"
        push_fail
      fi
    done
  done
fi

section "Environment hookup"
env_link="$HOME/.zshrc.environment"
env_link_ok=false
if [[ -L "$env_link" ]]; then
  target="$(readlink "$env_link")"
  if [[ -e "$env_link" ]]; then
    echo "  ✓ $env_link -> $target"
    push_ok
    env_link_ok=true
  else
    echo "  ✗ $env_link -> $target (broken — target does not exist)"
    push_fail
  fi
elif [[ -e "$env_link" ]]; then
  echo "  ! $env_link exists but is not a symlink"
  push_fail
else
  echo "  ✗ $env_link (not present — run 'just install')"
  push_fail
fi

section "Devbox"
if ! command -v devbox >/dev/null 2>&1; then
  echo "  · devbox not on PATH (skipped)"
else
  devbox_path="$(devbox global path 2>/dev/null || true)"
  if [[ -z "$devbox_path" ]]; then
    echo "  ✗ devbox global path not resolvable"
    push_fail
  else
    devbox_link="$devbox_path/devbox.json"
    devbox_src="$DOTFILES_HOME/devbox.json"
    if [[ -L "$devbox_link" && "$(readlink "$devbox_link")" == "$devbox_src" ]]; then
      echo "  ✓ $devbox_link -> $devbox_src"
      push_ok
    elif [[ -e "$devbox_link" ]]; then
      echo "  ✗ $devbox_link exists but does not link to $devbox_src"
      push_fail
    else
      echo "  ✗ $devbox_link (not linked — run 'just install')"
      push_fail
    fi

    fpfile="$DOTFILES_HOME/devbox.fingerprint"
    if [[ ! -r "$fpfile" ]]; then
      echo "  ✗ $fpfile (missing — run 'just install')"
      push_fail
    else
      cur="$(stat -c '%Y:%s' "$devbox_path/devbox.json" "$devbox_path/devbox.lock" 2>/dev/null || true)"
      last="$(<"$fpfile")"
      if [[ -n "$cur" && "$cur" == "$last" ]]; then
        echo "  ✓ devbox fingerprint matches"
        push_ok
      else
        echo "  ✗ devbox fingerprint out of date (precmd autosync will reconcile)"
        push_fail
      fi
    fi
  fi
fi

section "Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  echo "  · brew not on PATH (skipped)"
else
  brewfile="$DOTFILES_HOME/hosts/$host_name/brew/.config/brew/Brewfile"
  if [[ ! -f "$brewfile" ]]; then
    echo "  · $brewfile (no host Brewfile)"
  else
    echo "  Brewfile: $brewfile"
    if brew bundle check --file="$brewfile" >/dev/null 2>&1; then
      echo "    ✓ brew bundle in sync with Brewfile"
      push_ok
    else
      echo "    ✗ brew bundle drift — 'brew bundle check' reports missing items"
      push_fail
    fi

    fpfile="$HOME/.config/brew/Brewfile.fingerprint"
    if [[ ! -r "$fpfile" ]]; then
      echo "    ✗ $fpfile (missing — run 'just install')"
      push_fail
    else
      prefix="$(brew --prefix 2>/dev/null || true)"
      if [[ -z "$prefix" ]]; then
        echo "    ✗ brew --prefix returned empty"
        push_fail
      else
        brewfp_paths=()
        for d in Cellar Caskroom Library/Taps; do
          [[ -e "$prefix/$d" ]] && brewfp_paths+=("$prefix/$d")
        done
        cur=""
        (( ${#brewfp_paths[@]} )) && cur="$(stat -c '%Y:%s' "${brewfp_paths[@]}" 2>/dev/null || true)"
        last="$(<"$fpfile")"
        if [[ -n "$cur" && "$cur" == "$last" ]]; then
          echo "    ✓ Brewfile.fingerprint matches"
          push_ok
        else
          echo "    ✗ Brewfile.fingerprint out of date (precmd autobackup will reconcile)"
          push_fail
        fi
      fi
    fi
  fi
fi

section "Claude plugin"
if ! command -v claude >/dev/null 2>&1; then
  echo "  · claude not on PATH (skipped)"
else
  marketplaces_state="$HOME/.claude/plugins/known_marketplaces.json"
  plugins_state="$HOME/.claude/plugins/installed_plugins.json"

  if [[ -f "$marketplaces_state" ]] && yq -e '.local' "$marketplaces_state" >/dev/null 2>&1; then
    echo "  ✓ local marketplace registered"
    push_ok
  else
    echo "  ✗ local marketplace not registered (run 'just install')"
    push_fail
  fi

  if [[ -f "$plugins_state" ]] && yq -e '.plugins["dotfiles@local"][]?' "$plugins_state" >/dev/null 2>&1; then
    echo "  ✓ dotfiles@local plugin installed"
    push_ok
  else
    echo "  ✗ dotfiles@local plugin not installed (run 'just install')"
    push_fail
  fi
fi

section "Git hooks (lefthook)"
hook="$DOTFILES_HOME/.git/hooks/pre-commit"
if [[ ! -d "$DOTFILES_HOME/.git" ]]; then
  echo "  · not a git checkout (skipped)"
elif [[ -f "$hook" ]] && grep -q lefthook "$hook" 2>/dev/null; then
  echo "  ✓ $hook (lefthook installed)"
  push_ok
else
  echo "  ✗ $hook (lefthook not installed — run 'just install' or 'lefthook install')"
  push_fail
fi

section "Install state"
if ! $all_built; then
  echo "  NOT BUILT — run 'just build'"
elif ! $env_link_ok; then
  echo "  NOT INSTALLED — run 'just install'"
elif (( checks_fail == 0 )); then
  echo "  INSTALLED — $checks_ok checks passed"
else
  echo "  PARTIAL — $checks_ok ok, $checks_fail need attention (see ✗ entries above)"
  echo "  Try 'just reinstall' to re-apply, or address individual items."
fi

echo
