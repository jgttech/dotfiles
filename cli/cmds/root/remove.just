alias rm := remove

# Remove a package from the global devbox env. `devbox global rm` (not
# project-local `devbox rm`) is used so the nix profile reconciles in the
# same step — the binary is off PATH as soon as this returns. The autosync
# precmd hook handles the commit + push on the next prompt by detecting
# the devbox.{json,lock} fingerprint drift.
[script]
remove *argv:
    devbox global rm {{ argv }}
