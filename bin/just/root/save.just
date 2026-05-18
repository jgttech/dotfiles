# Generate a commit based on the message input.
[script]
save *argv:
    commit={{ quote(argv) }}

    if [[ -z "$commit" ]]; then
      claude -p /commit
    else
      git add -A
      git commit -m "$commit"
    fi

    git push
