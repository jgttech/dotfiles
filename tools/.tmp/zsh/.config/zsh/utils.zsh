#!/usr/bin/env zsh
dotfiles_json() {
  printf "`cat ${DOTFILES_BUILD_JSON} | jq "$1" | tr -d '\"'`"
}

installed() {
  which $1 &> /dev/null
}
