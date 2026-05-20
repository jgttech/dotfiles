# Dotfiles CLI reinstall script.
[script]
reinstall *argv:
    cwd="$(pwd)"
    cd "$DOTFILES_HOME"
    just reinstall {{ argv }}
    cd "$cwd"
