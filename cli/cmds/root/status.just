# Add a new devbox package for the system.
[script]
status *argv:
    cwd="$(pwd)"
    cd "$DOTFILES_HOME"
    git status
    cd "$cwd"
