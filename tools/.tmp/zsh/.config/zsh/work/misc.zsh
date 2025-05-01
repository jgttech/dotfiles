#!/usr/bin/env zsh
function get_default_branch {
  GIT_DEFAULT_BRANCH=`git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'`
}

function gpgtty {
  export GPG_TTY=$(tty)
}

function aws-profile () {
  builtin export AWS_DEFAULT_PROFILE=$1
  aws s3 ls
}

