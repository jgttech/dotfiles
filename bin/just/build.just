build:
  #!/usr/bin/env bash
  # Clean the build dir (should not exist in the first place)
  [[ -e "$PROJECT_BUILD_DIR" ]] && rm -rf "$PROJECT_BUILD_DIR"

  # Build the new Go binary.
  just go build -o "$PROJECT_BUILD_DIR/$PROJECT_BUILD_NAME" main.go
