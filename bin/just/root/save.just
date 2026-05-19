# Generate a commit based on the message input.
[script]
save *argv:
    commit={{ quote(argv) }}

    if [[ -z "$commit" ]]; then
      # Stream the skill's text output (status lines, narrative, final report)
      # plus a one-line marker per tool call. Stream-json + jq filter is the
      # only way to get progressive output from `claude -p`; plain text mode
      # buffers until the end.
      claude -p /dotfiles:commit --output-format stream-json --include-partial-messages --verbose \
        | jq -j --unbuffered 'if .type=="stream_event" and .event.type=="content_block_delta" and .event.delta.type=="text_delta" then .event.delta.text elif .type=="assistant" then (.message.content[]? | select(.type=="tool_use") | "\n→ " + (.input.description // ("Running " + .name)) + "\n") else empty end'
      echo
    else
      git add -A
      git commit -m "$commit"
    fi

    git push
