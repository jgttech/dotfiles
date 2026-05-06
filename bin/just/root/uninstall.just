# Unlink the dotfiles from the system.
[group("root")]
[script]
uninstall *argv:
    script uninstall $@
