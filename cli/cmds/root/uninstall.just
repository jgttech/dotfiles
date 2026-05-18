# Dotfiles CLI uninstall script.
[script]
uninstall *argv:
    cwd="$(pwd)"
    cd "$DOTFILES_HOME"
    just uninstall {{ argv }}
    cd "$cwd"
