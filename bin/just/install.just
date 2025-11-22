install *argv='':
  #!/usr/bin/env bash
  env_type="{{argv}}"

  # Ensure env is latest.
  direnv reload
  source .envrc

  # Install system tools.
  aqua install

  # Install language tools.
  aqua exec -- mise install

  # Install githooks.
  aqua exec -- lefthook install

  if [[ "$env_type" != "prod" ]]; then
    just runtime dotfiles-dev
    dotfiles
  fi
