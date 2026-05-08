# Switch .git/ to an authenticated clone via gh so changes can be pushed.
[group("root")]
[script]
unlock *argv:
    script unlock $@
