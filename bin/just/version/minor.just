# Bump the minor version in dotfiles.yml, reset patch to 0.
[script]
minor:
    major="${DOTFILES_VERSION%%.*}"
    rest="${DOTFILES_VERSION#*.}"
    minor="${rest%%.*}"
    new="${major}.$((minor + 1)).0"
    yq -y -i --arg new "$new" '.version = $new' "$DOTFILES_CONFIG"
    echo "$DOTFILES_VERSION -> $new"
