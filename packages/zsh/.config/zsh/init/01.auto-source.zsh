#!/usr/bin/env zsh
dotfiles-auto-source() {
  local base="${DOTFILES_ZSHRC:-$HOME/.config/zsh}"

  # Files that should be ignored.
  local exclusions=()

  if [[ ! -d "$base" ]]; then
    echo "Target directory $base does not exist" >&2
    return 1
  fi

  # Enable nullglob for safe globbing.
  setopt localoptions nullglob

  # Find all main.zsh files recursively.
  local files=("$base/etc"/**/"main.zsh"(N))

  # No files found, stop here.
  if [[ ${#files[@]} -eq 0 ]]; then
    return 1
  fi

  # Source all readable files.
  for file in "${files[@]}"; do
    if [[ "$file" == "$base/main.zsh" ]]; then
      continue
    fi

    local basename="${file:t}"

    if [[ ${exclusions[(ie)$basename]} -le ${#exclusions} ]]; then
      continue
    fi

    if [[ -r "$file" ]]; then
      source "$file" || echo "Failed to source $file" >&2
    fi
  done
}

dotfiles-auto-source
