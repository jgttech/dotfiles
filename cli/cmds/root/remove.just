alias rm := remove

# Dotfiles CLI uninstall script.
[script]
remove *argv:
    cwd="$(pwd)"
    cd "$DOTFILES_HOME"
    devbox rm {{ argv }}
    cd "$cwd"
