#!/usr/bin/env zsh
function icf-docker-login() {
  aws ecr get-login-password --profile=new-icf-samhsa | docker login --username AWS --password-stdin 522578921706.dkr.ecr.us-east-1.amazonaws.com
}

function icf-aws-sso() {
  aws sso login --profile=new-icf-samhsa
}

function icf-aws-login() {
  icf-aws-sso
  icf-docker-login
}
