#!/usr/bin/env zsh
[[ -d "/home/linuxbrew/.linuxbrew" ]] && {
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)";
}

# Terraform autocomplete
if installed "terraform"; then
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C /usr/local/bin/terraform terraform
fi
