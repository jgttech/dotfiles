clean:
  #!/usr/bin/env bash
  docker compose kill --remove-orphans
  docker compose rm -f

  devId=$(docker images | grep dotfiles-dev | awk '{ print $3 }')
  prodId=$(docker images | grep dotfiles-prod | awk '{ print $3 }')

  function rmi {
    local id=$(docker images | grep "$1" | awk '{ print $3 }')
    [[ ! -z "$id" ]] && docker rmi "$id" -f
  }

  rmi dotfiles-dev
  rmi dotfiles-prod

  targets=(\
    "$PROJECT_DIR" \
    "$PROJECT_BUILD_DIR" \
  )

  for target in "${targets[@]}"; do
    [[ -e "$target" ]] && rm -rfv "$target"
  done

  exit 0
