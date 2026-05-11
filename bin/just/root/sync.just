# Search and optionally add a devbox CLI package.
[group("root")]
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
    elif [ "$REMOTE" = "$BASE" ]; then
      echo "Local is ahead. Nothing to pull."
    else
      echo "Diverged. Manual merge needed."
    fi

    cd "$cwd"
    unset cwd
