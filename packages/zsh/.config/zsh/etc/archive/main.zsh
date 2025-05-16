#!/usr/bin/env zsh
function archive {
  local ext="tar.gz"

  function can_encrypt {
    if [ -n "$1" ] && [ -d "$1" ]; then
      return true
    fi

    return false
  }

  function can_decrypt {
    if [ -n "$1" ] && [ -f "$1" ] && [[ "$1" == *.tar.gz ]]; then
      return true
    fi

    return false
  }

  case "$1" in
    encrypt)
      if can_encrypt "$2"; then
        tar -cvzf - "$2" | gpg -c > "$2.$ext"
      fi
      ;;
    decrypt)
      if can_decrypt "$2"; then
        local archive=$(basename "$2")
        local dir="${archive%.${ext}}"

        mkdir -p "$dir"

        gpg -d "$2" | tar -xvzf - -C "$dir"
      fi
      ;;
  esac

  echo "Done."
}
