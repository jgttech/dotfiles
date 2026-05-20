# Dotfiles CLI uninstall script.
[script]
install *argv:
    cwd="$(pwd)"
    cd "$DOTFILES_HOME"
    just dotfiles install {{ argv }}
    cd "$cwd"
