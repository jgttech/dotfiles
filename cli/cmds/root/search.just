# Dotfiles CLI uninstall script.
[script]
search *argv:
    cwd="$(pwd)"
    cd "$DOTFILES_HOME"
    just search {{ argv }}
    cd "$cwd"
