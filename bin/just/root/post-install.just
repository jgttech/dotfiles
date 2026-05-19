# Runs after installing the dotfiles
[private]
[script]
post-install *argv:
    script post-install $@
