#!/usr/bin/env zsh
function samhsa-ecr-login() {
  aws ecr get-login-password --profile=new-icf-samhsa | docker login --username AWS --password-stdin 522578921706.dkr.ecr.us-east-1.amazonaws.com
}

function samhsa-aws-sso() {
  aws sso login --profile=new-icf-samhsa
}

function samhsa-login() {
  samhsa-aws-sso
  samhsa-ecr-login
}
