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

uninstall+="\n"
for rel in "${backups[@]}"; do
  uninstall+="if [[ -e \"\$HOME/$rel.$ts.bak\" ]]; then\n"
  uninstall+="  mv \"\$HOME/$rel.$ts.bak\" \"\$HOME/$rel\"\n"
  uninstall+="fi\n\n"
done

uninstall+="rm -f \"$HOME/.zshrc.environment\"\n"
uninstall+="rm -f \"$devbox_home/devbox.json\"\n\n"

# Uninstall the dotfiles plugin from every scope it was installed at, then
# remove the local marketplace. Iterating scopes from installed_plugins.json
# avoids leaving orphan scope-specific records behind.
uninstall+="if command -v claude >/dev/null 2>&1; then\n"
uninstall+="  _plugins_state=\"\$HOME/.claude/plugins/installed_plugins.json\"\n"
uninstall+="  _marketplaces_state=\"\$HOME/.claude/plugins/known_marketplaces.json\"\n"
uninstall+="  if [[ -f \"\$_plugins_state\" ]] && yq -e '.plugins[\"dotfiles@local\"][]?' \"\$_plugins_state\" >/dev/null 2>&1; then\n"
uninstall+="    yq -r '.plugins[\"dotfiles@local\"][]?.scope' \"\$_plugins_state\" | while read -r _scope; do\n"
uninstall+="      claude plugin uninstall dotfiles@local --scope \"\$_scope\" -y || true\n"
uninstall+="    done\n"
uninstall+="  fi\n"
uninstall+="  if [[ -f \"\$_marketplaces_state\" ]] && yq -e '.local' \"\$_marketplaces_state\" >/dev/null 2>&1; then\n"
uninstall+="    claude plugin marketplace remove local || true\n"
uninstall+="  fi\n"
uninstall+="  unset _plugins_state _marketplaces_state\n"
uninstall+="fi\n"

printf '%b' "$uninstall" > "$DOTFILES_BUILD/uninstall"
chmod +x "$DOTFILES_BUILD/uninstall"
