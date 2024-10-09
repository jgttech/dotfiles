#!/usr/bin/env bash
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
DIM='\e[2m'
BOLD='\e[1m'

# Clear the color
CLEAR='\033[0m'

function red { printf "${RED}$@${CLEAR}\n"; }
function green { printf "${GREEN}$@${CLEAR}\n"; }
function yellow { printf "${YELLOW}$@${CLEAR}\n"; }

function dim { printf "${DIM}$@${CLEAR}\n"; }
function bold { printf "${BOLD}$@${CLEAR}\n"; }
