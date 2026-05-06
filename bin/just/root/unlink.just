# Unlink the dotfiles from the system.
[group("root")]
[script]
unlink:
    main="$DOTFILES_HOME/bin/unlink/main.sh"

    if [[ "$OSTYPE" == "darwin"* ]]; then
      source "$main"
    elif [[ "$OSTYPE" == "linux"* ]]; then
      source "$main"
    fi
