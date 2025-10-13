#!/usr/bin/env zsh
function ds {
  echo ""

  echo "[CONTAINERS]"
  docker ps -a
  echo ""

  echo "[IMAGES]"
  docker images -a
  echo ""

  echo "[VOLUMES]"
  docker volume ls
  echo ""

  echo "[NETWORKS]"
  docker network ls
  echo ""
}

function dn {
  echo "Nuking docker..."
  docker container prune -f &>/dev/null
  docker rm -f $(docker ps -qa) &>/dev/null
  docker rmi -f $(docker images -qa) &>/dev/null
  docker volume rm -f $(docker volume ls -q) &>/dev/null
  docker network rm -f $(docker network ls -q) &>/dev/null
  echo "Done"
  echo ""

  echo "Showing latest state..."
  ds
}
