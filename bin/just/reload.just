reload:
  #!/usr/bin/env bash
  echo "Reloading container(s)..."
  out=$(docker compose kill --remove-orphans 2>&1)

  # If output doesn't end with newline and matches the message
  if [[ "$out" == "no container to kill" && "$out" != *$'\n' ]]; then
    echo ""
  fi

  docker compose down dotfiles-dev --remove-orphans
  just runtime
  just exec "cd $PROJECT_DOCKER_HOME; go mod tidy"
