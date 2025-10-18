#!/usr/bin/env zsh
autoload -Uz compinit
compinit

[[ -d "/home/linuxbrew/.linuxbrew" ]] && {
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)";
}
