dotfiles *args='':
  just build
  just exec "cd $PROJECT_DOCKER_HOME; go run main.go {{args}}"
