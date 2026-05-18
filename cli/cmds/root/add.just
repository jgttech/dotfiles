# Add a new devbox package for the system.
[script]
add *argv:
    cd "$DOTFILES_HOME"
    devbox add {{ argv }}
