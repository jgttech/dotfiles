import "../settings.just"
import "major.just"
import "minor.just"
import "patch.just"

# Print the dotfiles version.
[script]
default:
    echo "$DOTFILES_VERSION"
