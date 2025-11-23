release type="patch":
  #!/usr/bin/env bash
  set -euo pipefail

  release_type="{{type}}"

  # Get the latest tag
  latest_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")

  # Strips the "v" prefix if present
  version="${latest_tag#v}"

  # Split the version into parts
  IFS="." read -r MAJOR MINOR PATCH <<< "${version}"

  # Increment based on release type
  case "${release_type}" in
    major)
      MAJOR=$((MAJOR + 1))
      MINOR=0
      PATCH=0
    ;;
    minor)
      MINOR=$((MINOR + 1))
      PATCH=0
    ;;
    patch)
      PATCH=$((PATCH + 1))
    ;;
    *)
      echo "Error: Release type must be 'major', 'minor', or 'patch'"
      exit 1
    ;;
  esac

  new_version="v${MAJOR}.${MINOR}.${PATCH}"

  echo "Current version.: ${latest_tag}"
  echo -e "New version.....: ${new_version}\n"

  # Prompt for confirmation
  read -p "Create and push tag ${new_version} (y/N) " -n 1 -r
  echo

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Update version in the dotfiles.yml
    yq eval ".version = \"${new_version}\"" -i dotfiles.yml

    # Generate a commit
    just save

    # Push new version
    git push

    git tag -a "${new_version}" -m "Release ${new_version}"
    git push origin "${new_version}"

    echo -e "\n✓ Tagged and pushed ${new_version}"
  else
    echo "Cancelled"
    exit 0
  fi

  exit 0
