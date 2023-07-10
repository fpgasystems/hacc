#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="$(dirname "$(dirname "$0")")"

#inputs
read -a flags <<< "$@"

echo ""
echo "${bold}sgutil set keys${normal}"
echo ""

# setup keys
$CLI_PATH/common/ssh_key_add