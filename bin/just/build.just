build:
  #!/usr/bin/env bash
  aqua install

  [[ -e "$PROJECT_BUILD_DIR" ]] && rm -rf "$PROJECT_BUILD_DIR"
  go build -o "$PROJECT_BUILD_DIR/$PROJECT_BUILD_NAME" main.go
