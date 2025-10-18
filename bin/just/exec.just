alias x := exec

exec *args='':
  docker compose exec dotfiles bash -c "{{args}}"
