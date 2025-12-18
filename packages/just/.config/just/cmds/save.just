[doc("Generate a commit using AI")]
save:
  #!/usr/bin/env bash
  set -euo pipefail

  git add .

  # Check if opencode is available
  if ! command -v opencode &> /dev/null; then
    echo "❌ Error: This command requires 'opencode' to be installed."
    echo ""
    echo "Please install opencode to use this alignment check."
    echo "Visit: https://opencode.ai for installation instructions."
    exit 1
  fi

  # Construct the save instruction as an array
  instructions=(
    "Make 100% sure that the current path is under a git repo."
    "Create a commit with a high-level summary of changes:"
    "what was done and why (max 4 sentences, 80 chars/line)."
    "Don't list specific changes. Add '[Affected Files]' section with file list."
  )

  # Join array elements with newlines
  instruction=$(printf '%s\n' "${instructions[@]}")

  # Run opencode with the instruction
  opencode run "$instruction"
