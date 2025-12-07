#!/usr/bin/env zsh
function aws-profile () {
  builtin export AWS_DEFAULT_PROFILE=$1
  aws s3 ls
}
