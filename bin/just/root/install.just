# Install the required dependencies to use the Dotfiles.
[group("root")]
[script]
install *argv:
    # Can't install without the fabric.
    if [[ ! -d "$DOTFILES_BUILD" ]]; then
      script build $@
    fi

    dotfiles install
