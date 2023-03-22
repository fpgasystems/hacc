#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# inputs
read -a flags <<< "$@"

echo ""
echo "${bold}sgutil set keys${normal}"
echo ""

# setup keys
/opt/cli/common/ssh_key_add