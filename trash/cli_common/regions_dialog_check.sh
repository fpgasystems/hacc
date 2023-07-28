#!/bin/bash

flags=("$@")  # Assign command-line arguments to the 'flags' array

# Declare global variables
declare -g regions_found="0"
declare -g regions_number=""

#read flags
for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " --regions " ]]; then
        regions_found="1"
        device_idx=$(($i+1))
        regions_number=${flags[$device_idx]}
    fi  
done

#return the values
echo "$regions_found"
echo "$regions_number"