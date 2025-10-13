dotfiles *args='':
  docker compose exec dotfiles bash -c "cd /tmp/dotfiles; go run main.go {{args}}"
