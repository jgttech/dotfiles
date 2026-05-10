# Generate a commit based on the message input.
[group("root")]
[script]
save *argv:
    ts="$(date +%s%3N)"
    commit={{ quote(argv) }}
    [[ -z "$commit" ]] && commit="WIP $ts"

    git add -A
    git commit -m "$commit"
    git push
