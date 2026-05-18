# Unlink the dotfiles from the system.
[script]
uninstall *argv:
    dotfiles uninstall $@
