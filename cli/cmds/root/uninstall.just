# Dotfiles CLI uninstall script.
[script]
uninstall *argv:
    cwd="$(pwd)"
    cd "$DOTFILES_HOME"
    just dotfiles uninstall {{ argv }}
    cd "$cwd"
