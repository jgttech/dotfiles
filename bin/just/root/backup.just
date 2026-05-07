# Generate exports from the system, based on what system you have.
[group("root")]
[script]
backup *argv:
    script backup $@
