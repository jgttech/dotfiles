# Delete ephemoral resources/dependencies
[group("root")]
[script]
clean *argv:
    script clean $@
