#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#get username
username=$USER

# inputs
read -a flags <<< "$@"

# flags cannot be empty
if [ "$flags" = "" ]; then
    eval "/opt/cli/sgutil set write -h"
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
    eval "/opt/cli/sgutil set write -h"
    exit
else
    sudo /opt/cli/program/fpga_chmod $index
fi