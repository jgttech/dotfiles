[private]
runtime:
  #!/usr/bin/env bash
  state="$(docker compose ps --format=json dotfiles-dev | jq ".State" | tr -d '\"')"

  if [[ "$state" != "running" ]]; then
    docker compose up dotfiles-dev -d
  fi
