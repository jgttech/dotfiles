#!/usr/bin/env bash
# Bump the ref + sha for each url-source GitHub plugin in the local
# marketplace to the latest release tag (or main HEAD if no releases).
# Modifies marketplace.json in place; staging and commit are the caller's
# responsibility (`just update plugins` locally; the update-plugins GHA
# opens a PR).
set -euo pipefail

mp_file="$DOTFILES_HOME/os/shared/claude/.claude/plugins/local/.claude-plugin/marketplace.json"

if [[ ! -f "$mp_file" ]]; then
  echo "marketplace.json not found at: $mp_file" >&2
  exit 1
fi

for tool in gh jq; do
  command -v "$tool" >/dev/null 2>&1 || {
    echo "required tool not found: $tool" >&2
    exit 1
  }
done

entries=()
while IFS= read -r line; do
  entries+=("$line")
done < <(jq -r '
  .plugins[]
  | select((.source | type) == "object")
  | select(.source.source == "url" and (.source.url | contains("github.com")))
  | [.name, .source.url] | @tsv
' "$mp_file")

if [[ ${#entries[@]} -eq 0 ]]; then
  echo "no url-source github plugins to update"
  exit 0
fi

changed=0
for entry in "${entries[@]}"; do
  IFS=$'\t' read -r name url <<< "$entry"
  repo="$(echo "$url" | sed -E 's#https?://github.com/([^/]+/[^/.]+)(\.git)?$#\1#')"

  if new_ref="$(gh api "repos/$repo/releases/latest" --jq '.tag_name' 2>/dev/null)"; then
    new_sha="$(gh api "repos/$repo/git/refs/tags/$new_ref" --jq '.object.sha')"
  else
    new_ref="main"
    new_sha="$(gh api "repos/$repo/commits/main" --jq '.sha')"
  fi

  cur_ref="$(jq -r --arg n "$name" '.plugins[] | select(.name == $n) | .source.ref // ""' "$mp_file")"
  cur_sha="$(jq -r --arg n "$name" '.plugins[] | select(.name == $n) | .source.sha // ""' "$mp_file")"

  if [[ "$cur_ref" == "$new_ref" && "$cur_sha" == "$new_sha" ]]; then
    printf '%-20s up to date (%s @ %s)\n' "$name" "$new_ref" "${new_sha:0:8}"
    continue
  fi

  jq --arg n "$name" --arg r "$new_ref" --arg s "$new_sha" '
    (.plugins[] | select(.name == $n) | .source.ref) = $r |
    (.plugins[] | select(.name == $n) | .source.sha) = $s
  ' "$mp_file" > "$mp_file.tmp" && mv "$mp_file.tmp" "$mp_file"

  printf '%-20s bumped %s -> %s (%s)\n' "$name" "$cur_ref" "$new_ref" "${new_sha:0:8}"
  changed=$((changed + 1))
done

echo "---"
echo "updated: $changed plugin(s)"
