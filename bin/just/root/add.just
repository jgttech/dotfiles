# Add devbox dependencies.
[group("root")]
[script]
add *argv:
    devbox add {{ argv }}
