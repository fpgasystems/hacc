#!/bin/bash

flags=("$@")  # Assign command-line arguments to the 'flags' array

# Declare global variables
declare -g deployment_option_found="0"
declare -g deployment_option=""
#declare -g device_index=""

#read flags
for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " -s " ]] || [[ " ${flags[$i]} " =~ " --server " ]]; then # flags[i] is -d or --device
        deployment_option_found="1"
        option_idx=$(($i+1))
        deployment_option=${flags[$option_idx]}
    fi  
done

#return the values
echo "$deployment_option_found"
echo "$deployment_option"
#echo "$option_idx"
#echo "$device_index"