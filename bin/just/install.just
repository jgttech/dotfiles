install:
  #!/usr/bin/env bash
  aqua install
  lefthook install
  just start

  for file in "$(pwd)/bin/dev"/*; do
    bin="$(basename $file)"

    if [[ ! -e "$PROJECT_BIN/$bin" ]]; then
      ln -s "../../../bin/dev/$bin" "$PROJECT_BIN/$bin" &> /dev/null
    fi
  done

