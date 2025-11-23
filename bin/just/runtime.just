[private]
runtime *service='':
  #!/usr/bin/env bash
  state="$(docker compose ps --format=json {{service}} | jq ".State" | tr -d '\"')"

  if [[ "$state" != "running" ]]; then
    docker compose up {{service}} -d
  fi
