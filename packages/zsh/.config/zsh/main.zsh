#!/usr/bin/env zsh
# Iteraltes through all the directries and
# automatically sources the "main.zsh" file
# within each one.
#
# Adding a new utilities directory is as easy
# as just creating a directory and then adding
# a "main.zsh" file and it will get sourced
# automatically when the shell is reloaded.
for dir in "${DOTFILES_ZSHRC}"/*; do
  if [[ -d "$dir" ]]; then
    local main_file="$dir/main.zsh"

    if [[ -f "$main_file" ]]; then
      source "$main_file"
    fi
  fi
done
