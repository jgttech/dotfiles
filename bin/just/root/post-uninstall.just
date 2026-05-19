# Runs after uninstalling the dotfiles
[private]
[script]
post-uninstall *argv:
    script post-uninstall $@
