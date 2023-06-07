#!/bin/bash

flags=("$@")  # Assign command-line arguments to the 'flags' array

# Declare global variables
declare -g device_found="0"
#declare -g device_idx=""
declare -g device_index=""

#read flags
for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " -d " ]] || [[ " ${flags[$i]} " =~ " --device " ]]; then # flags[i] is -d or --device
        device_found="1"
        device_idx=$(($i+1))
        device_index=${flags[$device_idx]}
    fi  
done

#return the values
echo "$device_found"
#echo "$device_idx"
echo "$device_index"