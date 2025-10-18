[private]
runtime:
  #!/usr/bin/env bash
  state="$(docker compose ps --format=json dotfiles | jq ".State" | tr -d '\"')"

  if [[ "$state" != "running" ]]; then
    docker compose up dotfiles -d
  fi
