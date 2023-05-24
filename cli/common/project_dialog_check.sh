#!/bin/bash

flags=$1 

# Declare global variables
declare -g project_found=""
declare -g project_idx=""
declare -g project_name=""

for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " -p " ]] || [[ " ${flags[$i]} " =~ " --project " ]]; then # flags[i] is -p or --project
        project_found="1"
        project_idx=$(($i+1))
        project_name=${flags[$project_idx]}
    fi
done

#return the values of device_found and device_index
echo "$project_found"
echo "$project_idx"
echo "$project_name"