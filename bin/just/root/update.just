# Update tracked entries managed by the dotfiles repo (e.g. plugins).
[script]
update target *argv:
    script update.{{ target }} {{ argv }}
