clean:
  #!/usr/bin/env bash
  [[ -d "${PROJECT_DIR}" ]] && rm -rfv "${PROJECT_DIR}"
  [[ -d "${PROJECT_BUILD_DIR}" ]] && rm -rfv "${PROJECT_BUILD_DIR}"

  exit 0
