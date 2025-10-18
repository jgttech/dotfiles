dotfiles *args='':
  docker compose exec dotfiles bash -c "cd $PROJECT_DOCKER_HOME; go run main.go {{args}}"
