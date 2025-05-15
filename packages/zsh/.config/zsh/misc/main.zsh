#!/usr/bin/env zsh
function gpgtty {
  export GPG_TTY=$(tty)
}
