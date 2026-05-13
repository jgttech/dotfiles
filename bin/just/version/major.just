# Bump the major version in dotfiles.yml, reset minor and patch to 0.
[script]
major:
    major="${DOTFILES_VERSION%%.*}"
    new="$((major + 1)).0.0"
    yq -y -i --arg new "$new" '.version = $new' "$DOTFILES_CONFIG"
    echo "$DOTFILES_VERSION -> $new"
