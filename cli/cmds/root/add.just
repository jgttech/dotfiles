# Add a package to the global devbox env. `devbox global add` (not
# project-local `devbox add`) is used so the nix profile reconciles in
# the same step — the binary is on PATH as soon as this returns. The
# autosync precmd hook handles the commit + push on the next prompt by
# detecting the devbox.{json,lock} fingerprint drift.
[script]
add *argv:
    devbox global add {{ argv }}
