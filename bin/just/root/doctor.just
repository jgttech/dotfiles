# Print diagnostic information about the dotfiles install state.
[group("root")]
[script]
doctor *argv:
    script doctor $@
