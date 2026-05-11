# Generate a commit based on the message input.
[group("root")]
[script]
save *argv:
    commit="{{ quote(argv) }}"

    if [[ -z "$commit" ]]; then
      claude /commit
    else
      git add -A
      git commit -m "$commit"
    fi

    git push
