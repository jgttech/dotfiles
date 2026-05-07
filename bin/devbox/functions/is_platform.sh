#!/usr/bin/env bash
function is_platform {
  local target="${1:-""}"
  [[ "$OSTYPE" == "${target}"* ]]
}
