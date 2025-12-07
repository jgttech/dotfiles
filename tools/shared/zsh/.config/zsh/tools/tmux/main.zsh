#!/usr/bin/env zsh
alias ctop='TERM="${TERM/#tmux/screen}" ctop'

function tsession {
  tmux new-session -s "$1"
}
