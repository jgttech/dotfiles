# Generate a commit based on the message input.
[script]
save *argv:
    commit={{ quote(argv) }}
    cwd="$(pwd)"
    cd "$DOTFILES_HOME"

    if [[ -z "$commit" ]]; then
      claude -p /dotfiles:commit
    else
      git add -A
      git commit -m "$commit"
    fi

    git push
    cd "$cwd"
