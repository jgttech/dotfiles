#!/usr/bin/env zsh
# Hooks the devbox global packages into the shell.
eval "$(devbox global shellenv)"

# ORDER MATTERS
_dotfiles=(\
  # Hooks the dotfiles .build/environment into the shell.
  "$HOME/.zshrc.environment" \

  # Hook the hosts ZSH config into the shell.
  # This is where the ZSH config should live for each host.
  "$HOME/.config/zsh/main.zsh" \
)

# Track which files failed to load.
_dotfiles_failed=()

for src in "${_dotfiles[@]}"; do
  if [[ -f "$src" ]]; then
    source "$src"

    if [[ "$src" == *".zshrc.environment"* ]]; then
      source "$DOTFILES_BUILD/cli"
    fi
  else
    _dotfiles_failed+=("$src")
  fi
done

if [[ ${#_dotfiles_failed[@]} -ne 0 ]]; then
  echo "[ERROR]"
  echo "Failed to load (${#_dotfiles_failed[@]}) dotfiles environment configs:"

  for failed in "${_dotfiles_failed[@]}"; do
    echo " - $failed"
  done

  echo
fi

# Just to keep the global space from being polluted.
unset _dotfiles
unset _dotfiles_failed
