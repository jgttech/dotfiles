# Bump the patch version in dotfiles.yml.
[script]
patch:
    major="${DOTFILES_VERSION%%.*}"
    rest="${DOTFILES_VERSION#*.}"
    minor="${rest%%.*}"
    patch="${rest##*.}"
    new="${major}.${minor}.$((patch + 1))"
    yq -y -i --arg new "$new" '.version = $new' "$DOTFILES_CONFIG"
    echo "$DOTFILES_VERSION -> $new"
