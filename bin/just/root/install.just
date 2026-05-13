# Install the required dependencies to use the dotfiles.
[script]
install *argv:
    # Defensively re-create the project-local .claude symlink if missing.
    [ -L .claude ] || ln -s os/shared/claude/.claude .claude

    just build $@
    devbox install
