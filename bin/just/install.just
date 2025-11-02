install:
  #!/usr/bin/env bash
  # Ensure env is latest.
  direnv reload

  # Install system tools.
  aqua install

  # Install language tools.
  mise install

  # Install githooks.
  lefthook install

  just runtime dotfiles-dev
  dotfiles
