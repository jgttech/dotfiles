clean:
  #!/usr/bin/env bash
  function rmi {
    local id=$(docker images | grep "$1" | awk '{ print $3 }')
    [[ ! -z "$id" ]] && docker rmi "$id" -f
  }

  docker compose kill --remove-orphans
  docker compose rm -f
  rmi dev

  [[ -d "${PROJECT_DIR}" ]] && rm -rfv "${PROJECT_DIR}"
  [[ -d "${PROJECT_BUILD_DIR}" ]] && rm -rfv "${PROJECT_BUILD_DIR}"

  exit 0
