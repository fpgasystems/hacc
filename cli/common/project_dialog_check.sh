#!/bin/bash

flags=("$@")  # Assign command-line arguments to the 'flags' array
#CLI_WORKDIR=$1        # Assign the first argument to the variable cli_workdir
#shift                 # Shift the remaining arguments by one position
#flags=("$@")          # Assign the shifted arguments to the flags array

# Declare global variables
declare -g project_found="0"
declare -g project_idx=""
declare -g project_name=""
#declare -g project_error=""

#read flags
for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " -p " ]] || [[ " ${flags[$i]} " =~ " --project " ]]; then # flags[i] is -p or --project
        project_found="1"
        project_idx=$(($i+1))
        project_name=${flags[$project_idx]}
    fi
done

##forbidden combinations
#if ([ "$project_found" = "1" ] && [ "$project_name" = "" ]) || ([ $project_found = "0" ] && [ $device_found = "1" ]) || ([ "$device_found" = "1" ] && [ "$device_index" = "" ]); then #[[ $project_found = "0" ]] || 
#    $CLI_WORKDIR/sgutil program vitis -h
#    exit
#    #project_error="1"
#fi

#return the values
echo "$project_found"
echo "$project_idx"
echo "$project_name"
#echo "$project_error"