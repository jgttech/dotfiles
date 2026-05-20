# Automatically update the repo.
[script]
sync *argv="":
    cwd="$(pwd)"
    cd "$DOTFILES_HOME" || return $?

    git fetch --quiet

    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u})
    BASE=$(git merge-base @ @{u})

    if [ "$LOCAL" = "$REMOTE" ]; then
      # Already up-to-date
      :
    elif [ "$LOCAL" = "$BASE" ]; then
      git pull --ff-only
      if git diff --name-only "$LOCAL" "$REMOTE" | grep -qE '^devbox\.(json|lock)$'; then
        devbox global install
        stat -c '%Y:%s' "$(devbox global path)/devbox.json" "$(devbox global path)/devbox.lock" > "$DOTFILES_HOME/devbox.fingerprint"
      fi
      if git diff --name-only "$LOCAL" "$REMOTE" | grep -qE "^hosts/$(hostname -s)/brew/\.config/brew/Brewfile$"; then
        brew bundle install --file="$HOME/.config/brew/Brewfile"
        stat -c '%Y:%s' "$(brew --prefix)/Cellar" "$(brew --prefix)/Caskroom" "$(brew --prefix)/Library/Taps" > "$HOME/.config/brew/Brewfile.fingerprint"
      fi
    elif [ "$REMOTE" = "$BASE" ]; then
      echo "Local is ahead. Nothing to pull."
    else
      echo "Diverged. Manual merge needed."
    fi

    cd "$cwd"
    unset cwd
