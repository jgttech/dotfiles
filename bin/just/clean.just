clean:
  #!/usr/bin/env bash
  targets=(\
    "$PROJECT_DIR" \
    "$PROJECT_BUILD_DIR" \
  )

  for target in "${targets[@]}"; do
    [[ -e "$target" ]] && rm -rfv "$target"
  done
