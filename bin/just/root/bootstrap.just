# Install prerequisites for the dotfiles install pipeline (brew, devbox, just, yq, Xcode CLT).
[group("root")]
[script]
bootstrap *argv:
    script bootstrap $@
