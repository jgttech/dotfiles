set quiet
set positional-arguments

# Prepend bin/devbox to PATH so that `set script-interpreter` can
# resolve `bash.sh` via PATH lookup rather than a relative path.
#
# This matters because:
#   1. `set script-interpreter` is const — it cannot use functions
#      like justfile_directory() or env_var().
#   2. Submodules declared via `mod` change recipe cwd to the
#      submodule directory, breaking any relative interpreter path.
#
# PATH-based resolution is cwd-independent and applies uniformly
# across every submodule via this file's `import`.
# export PATH := justfile_directory() + "/runtime:" + env("PATH")
# set script-interpreter := ["shell.zsh"]
