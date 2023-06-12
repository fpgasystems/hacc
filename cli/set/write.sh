#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"

#get username
username=$USER

#inputs
read -a flags <<< "$@"

#check for vivado_developers
member=$($CLI_PATH/common/is_member $username vivado_developers)
if [ "$member" = "false" ]; then
    echo ""
    echo "Sorry, ${bold}$username!${normal} You are not granted to use this command."
    echo ""
    exit
fi

# flags cannot be empty
if [ "$flags" = "" ]; then
    eval "$CLI_PATH/sgutil set write -h"
    exit
fi

index_found="0"
index=""
for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " -i " ]] || [[ " ${flags[$i]} " =~ " --index " ]]; then 
        index_found="1"
        index_idx=$(($i+1))
        index=${flags[$index_idx]}
    fi
done

#apply fpga_chmod
if [[ $index = "" ]]; then
    eval "$CLI_PATH/sgutil set write -h"
    exit
else
    echo ""
    echo "${bold}sgutil set write${normal}"
    sudo $CLI_PATH/program/fpga_chmod $index
fi