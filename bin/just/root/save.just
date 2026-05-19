# Generate a commit based on the message input.
[script]
save *argv:
    commit={{ quote(argv) }}

    if [[ -z "$commit" ]]; then
      # Stream the skill's text output (status lines, narrative, final report)
      # plus a one-line marker per tool call. Stream-json + jq filter is the
      # only way to get progressive output from `claude -p`; plain text mode
      # buffers until the end.
      # jq extracts streaming text + a "  ↳ <description>" line per tool
      # call, dropping tool calls that lack a description (internal/utility
      # tools like ToolSearch produce noise without signal). Leading \n on
      # the marker keeps it from gluing onto the AI's previous line when
      # sonnet omits a trailing \n. awk then collapses two cases: the blank
      # line immediately before "  ↳" (artifact of the leading \n when the
      # AI does emit \n), and exact-consecutive duplicate markers (the AI
      # retrying the same operation back-to-back). fflush keeps the output
      # flowing through the pipe.
      claude -p /dotfiles:commit --model sonnet --output-format stream-json --include-partial-messages --verbose \
        | jq -j --unbuffered 'if .type=="stream_event" and .event.type=="content_block_delta" and .event.delta.type=="text_delta" then .event.delta.text elif .type=="assistant" then (.message.content[]? | select(.type=="tool_use") | select(.input.description != null) | "\n  ↳ " + .input.description + "\n") else empty end' \
        | awk '/^$/ {h++; next} /^  ↳/ {h=0; if ($0 != prev) {print; prev=$0}; fflush(); next} {while (h>0) {print ""; h--} prev=""; print; fflush()}'
      echo
    else
      git add -A
      git commit -m "$commit"
    fi

    git push
