prod:
  docker compose up dotfiles-prod -d
  docker compose exec dotfiles-prod bash -c "pwd; ls -la"
