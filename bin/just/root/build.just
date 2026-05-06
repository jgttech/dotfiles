# Install the required dependencies to use the Dotfiles.
[group("root")]
[script]
build *argv:
    script build $@
