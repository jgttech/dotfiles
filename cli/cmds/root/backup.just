# Dotfiles setup status.
[script]
backup *argv:
    cwd="$(pwd)"
    cd "$DOTFILES_HOME"
    just backup {{ argv }}
    cd "$cwd"
