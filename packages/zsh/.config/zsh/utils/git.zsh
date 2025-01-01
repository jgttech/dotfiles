#!/usr/bin/env zsh
alias li="ls -lah"
alias add="git add"
alias cm="git commit -m"
alias commit="git commit"
alias pull="git pull"
alias push="git push"
alias co="git checkout"
alias status="git status"

function branch {
  git checkout -b $1
  git push --set-upstream origin $1
}

function merge {
  local cwb=`git rev-parse --abbrev-ref HEAD`

  git checkout $1
  git fetch
  git pull
  git checkout $cwb
  git merge $1
}

function wip {
  local msg="WIP (`date +%s`) $1"

  git add .
  git commit -m "`echo $msg | awk '{$1=$1};1'`"
  git push
}

function save {
  if [[ ! -z "$1" ]]; then
    git add .
    git commit -m "$1"
    git push
  else
    echo "Must pass a message as a string."
  fi
}
