# Add a new devbox package for the system.
[script]
add *argv:
    cwd="$(pwd)"
    cd "$DOTFILES_HOME"
    just add {{ argv }}
    cd "$cwd"
