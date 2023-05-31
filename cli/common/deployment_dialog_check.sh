#!/bin/bash

flags=("$@")  # Assign command-line arguments to the 'flags' array

# Declare global variables
declare -g remote_option_found="0"
declare -g remote_option=""

#read flags
for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " -r " ]] || [[ " ${flags[$i]} " =~ " --remote " ]]; then # flags[i] is -d or --device
        remote_option_found="1"
        remote_option_idx=$(($i+1))
        remote_option=${flags[$remote_option_idx]}
    fi  
done

#return the values
echo "$remote_option_found"
echo "$remote_option"