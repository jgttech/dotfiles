dotfiles *args='':
  docker compose exec repo bash -c "cd /tmp/dotfiles; go run main.go {{args}}"
