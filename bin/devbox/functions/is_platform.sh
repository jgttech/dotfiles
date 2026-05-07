#!/usr/bin/env bash
function is_platform {
  [[ "$OSTYPE" == "${1:-""}"* ]]
}
