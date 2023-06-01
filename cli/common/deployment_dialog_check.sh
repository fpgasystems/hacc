#!/bin/bash

flags=("$@")  # Assign command-line arguments to the 'flags' array

# Declare global variables
declare -g deploy_option_found="0"
declare -g deploy_option=""

#read flags
for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " -r " ]] || [[ " ${flags[$i]} " =~ " --remote " ]]; then # flags[i] is -d or --device
        deploy_option_found="1"
        deploy_option_idx=$(($i+1))
        deploy_option=${flags[$deploy_option_idx]}
    fi  
done

#return the values
echo "$deploy_option_found"
echo "$deploy_option"