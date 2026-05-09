# Install the required dependencies to use the Dotfiles.
[group("root")]
[script]
install *argv:
    # Can't install without the fabric.
    if [[ ! -d "$DOTFILES_BUILD" ]]; then
      script build $@
    fi

    dotfiles install

    # Defensively re-create the project-local .claude symlink if missing.
    [ -L .claude ] || ln -s os/shared/claude/.claude .claude
