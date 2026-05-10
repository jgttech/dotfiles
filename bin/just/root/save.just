# Generate a commit based on the message input.
[group("root")]
[script]
save *argv:
    ts="$(date +%s%3N)"
    commit="${1:-"WIP $ts"}"

    git add -A
    git commit -m "$commit"
    git push
