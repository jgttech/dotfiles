# Dotfiles setup status.
[script]
doctor *argv:
    cwd="$(pwd)"
    cd "$DOTFILES_HOME"
    just doctor {{ argv }}
    cd "$cwd"
