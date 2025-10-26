alias x := exec

exec *args='':
  docker compose exec dotfiles-dev bash -c "{{args}}"
