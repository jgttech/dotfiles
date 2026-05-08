#!/usr/bin/env bash
uninstall="#!/usr/bin/env bash\nset -euo pipefail\n"
uninstall+="source \"$DOTFILES_BUILD/environment\"\n\n"

uninstall+="while [[ \$# -gt 0 ]]; do\n"
uninstall+="  case \"\$1\" in\n"
uninstall+="    --purge)\n"
uninstall+="      shift\n"
uninstall+="      rm -rf ~/.local/share/devbox/global\n"
uninstall+="      nix-collect-garbage -d\n"
uninstall+="    ;;\n"
uninstall+="    *) shift ;;\n"
uninstall+="  esac\n"
uninstall+="done\n\n"

uninstall+="if [[ -f \"$brewfile\" ]]; then\n"
uninstall+="  brew bundle cleanup --file=\"$brewfile\" --force\n"
uninstall+="fi\n\n"

for ctx in "${contexts[@]}"; do
  dirs=()

  for dir in "${ctx}"/*; do
    dirs+=("$(basename "$dir")")
  done

  (( ${#dirs[@]} == 0 )) && continue

  uninstall+="stow -D -t \"\$HOME\" -d $(printf '%q' "$ctx") $(printf '%q ' "${dirs[@]}")\n"
done

uninstall+="\nif [[ -f \"$zshrc_backup\" ]]; then\n"
uninstall+="  mv \"$zshrc_backup\" \"\$HOME/.zshrc\"\n"
uninstall+="fi\n\n"

uninstall+="rm -f \"$HOME/.zshrc.environment\"\n"
uninstall+="rm -f \"$devbox_home/devbox.json\"\n"

printf '%b' "$uninstall" > "$DOTFILES_BUILD/uninstall"
chmod +x "$DOTFILES_BUILD/uninstall"
