# Reapply the dotfiles to the system: backup -> uninstall -> build -> install. Pass --no-backup to skip the preflight backup.
[script]
reinstall *argv:
    # The uninstall step runs the script that matches what's on disk now,
    # then `build` regenerates from source, and install lays down the new
    # state. The preflight `backup` captures any drift (e.g. brew packages
    # installed since the last autobackup) into the Brewfile so that
    # `brew bundle cleanup --force` doesn't prune them. Use --no-backup
    # when deliberately reverting the system to the committed Brewfile.
    no_backup=0
    args=()

    for arg in "$@"; do
      case "$arg" in
        --no-backup) no_backup=1 ;;
        *) args+=("$arg") ;;
      esac
    done

    if (( no_backup == 0 )); then
      just backup
    fi

    just dotfiles uninstall "${args[@]}"
    just build "${args[@]}"
    just dotfiles install "${args[@]}"
