#!/usr/bin/env zsh
alias li="ls -lah"
alias add="git add"
# alias cm="git commit -m"
alias commit="git commit"
alias pull="git pull"
alias push="git push"
alias co="git checkout"
alias status="git status"
alias lg="lazygit"
alias gs="git-switcher"
alias cl="clone"

function cm {
  # if installed "better-commits"; then
  #   better-commits
  # else
  #   git commit -m $@
  # fi

  git commit -m $@
}

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

# function save {
#   just -g save
# }

function save {
  if [[ ! -z "$1" ]]; then
    git add .
    git commit -m "$1"
    git push
  else
    echo "Generating a commit, please wait..."
    just -g save
  fi
}

function get_default_branch {
  GIT_DEFAULT_BRANCH=`git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'`
}

function clone {
  local ssh_host="github.com"

  if [[ $1 == *"ICF-Corp"* ]]; then
    ssh_host="icf-corp"
  elif [[ $1 == *"ICF-Next-Government"* ]]; then
    ssh_host="icf-nextgov"
  fi

  git clone git@$ssh_host:$1
}
