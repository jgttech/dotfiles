alias healthcheck := doctor

# Print diagnostic information about the dotfiles install state.
[script]
doctor *argv:
    script doctor $@
