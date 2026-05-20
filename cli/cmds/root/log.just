# Dotfiles CLI uninstall script.
[script]
log *argv:
    cwd="$(pwd)"
    cd "$DOTFILES_HOME"
    git log
    cd "$cwd"
