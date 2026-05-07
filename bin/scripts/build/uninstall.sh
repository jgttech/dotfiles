#!/usr/bin/env bash
uninstall="#!/usr/bin/env bash\nset -euo pipefail\n"
uninstall+="source \"$DOTFILES_BUILD/environment\"\n"

for ctx in "${contexts[@]}"; do
  dirs=()

  for dir in "${ctx}"/*; do
    dirs+=("$(basename "$dir")")
  done

  (( ${#dirs[@]} == 0 )) && continue

  uninstall+="stow -D -t \"\$HOME\" -d $(printf '%q' "$ctx") $(printf '%q ' "${dirs[@]}")\n"
done

uninstall+="if [[ -f \"$zshrc_backup\" ]]; then\n"
uninstall+="  mv \"$zshrc_backup\" \"\$HOME/.zshrc\"\n"
uninstall+="fi\n"
uninstall+="rm -f \"$HOME/.zshrc.environment\"\n"
uninstall+="rm -f \"$devbox_home/devbox.json\"\n"

if [[ -f "$brewfile" ]]; then
  uninstall+="brew bundle cleanup --file=\"$brewfile\" --force\n"
fi

printf '%b' "$uninstall" > "$outdir/uninstall"
chmod +x "$outdir/uninstall"
