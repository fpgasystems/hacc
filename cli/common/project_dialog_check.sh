#!/bin/bash

flags=("$@")  # Assign command-line arguments to the 'flags' array

# Declare global variables
declare -g project_found=""
declare -g project_idx=""
declare -g project_name=""
declare -g project_error=""

for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " -p " ]] || [[ " ${flags[$i]} " =~ " --project " ]]; then # flags[i] is -p or --project
        project_found="1"
        project_idx=$(($i+1))
        project_name=${flags[$project_idx]}
    fi
done

if [[ $project_found = "0" ]] || ([ "$project_found" = "1" ] && [ "$project_name" = "" ]) || ([ $project_found = "0" ] && [ $device_found = "1" ]) || ([ "$device_found" = "1" ] && [ "$device_index" = "" ]); then
    #$CLI_WORKDIR/sgutil program vitis -h
    #exit
    project_error="1"
fi

#return the values
echo "$project_found"
echo "$project_idx"
echo "$project_name"
echo "$project_error"