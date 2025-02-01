#!/usr/bin/env bash
set -euo pipefail

function json {
  local file="$1"
  local selector="$2"
  local var=$(cat $file | jq $selector)

  var=$(echo "$var" | tr -d '"')

  printf '%s' "$var"
}
