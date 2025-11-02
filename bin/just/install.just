install:
  #!/usr/bin/env bash
  direnv reload
  aqua install
  mise install
  lefthook install

  for file in "$(pwd)/bin/dev"/*; do
    bin="$(basename $file)"

    if [[ ! -e "$PROJECT_BIN/$bin" ]]; then
      ln -s "../../bin/dev/$bin" "$PROJECT_BIN/$bin" &> /dev/null
    fi
  done

  # just runtime dotfiles-dev
  # dotfiles
