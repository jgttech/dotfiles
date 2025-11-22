prod:
  #!/usr/bin/env bash
  state="$(docker compose ps --format=json dotfiles-prod | jq ".State" | tr -d '\"')"

  if [[ "$state" == "running" ]]; then
    echo "Terminating production environment..."
    docker compose kill dotfiles-prod --remove-orphans
    docker compose rm dotfiles-prod -f
    echo "Done"
  fi

  echo "Starting production runtime..."
  just runtime dotfiles-prod

  echo "Running production install..."

  # Testing using local files.
  # docker compose exec dotfiles-prod bash -c "export DOTFILES_DEV=\"true\"; cat /tmp/dotfiles/bin/install | bash"

  # Testing using git repo.
  docker compose exec dotfiles-prod bash -c "cat ~/.dotfiles/bin/install | bash"

  exit 0
