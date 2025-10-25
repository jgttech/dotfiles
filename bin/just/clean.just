clean:
  #!/usr/bin/env bash
  docker compose kill --remove-orphans &> /dev/null
  docker compose rm -f &> /dev/null

  id=$(docker images | grep dotfiles | awk '{ print $3 }')

  if [[ ! -z "$id" ]]; then
    docker rmi "$id" -f &> /dev/null
  fi

  targets=(\
    "$PROJECT_DIR" \
    "$PROJECT_BUILD_DIR" \
  )

  for target in "${targets[@]}"; do
    [[ -e "$target" ]] && rm -rfv "$target" &> /dev/null
  done

  exit 0
