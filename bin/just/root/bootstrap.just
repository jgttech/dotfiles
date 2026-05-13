# Install prerequisites for the dotfiles install pipeline (brew, devbox, just, yq, Xcode CLT).
[script]
bootstrap *argv:
    script bootstrap $@
