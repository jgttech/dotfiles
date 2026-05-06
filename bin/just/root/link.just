# Link the dotfiles into the system.
[group("root")]
[script]
link:
    main="$DOTFILES_HOME/bin/link/main.sh"

    if [[ "$OSTYPE" == "darwin"* ]]; then
      source "$main"
    elif [[ "$OSTYPE" == "linux"* ]]; then
      source "$main"
    fi
