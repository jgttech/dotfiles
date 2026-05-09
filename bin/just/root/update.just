# Update tracked entries managed by the dotfiles repo (e.g. plugins).
[group("root")]
[script]
update target *argv:
    script update.{{ target }} {{ argv }}
