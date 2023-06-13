#!/bin/bash

flags=("$@")  # Assign command-line arguments to the 'flags' array

# Declare global variables
declare -g platform_found="0"
declare -g platform_name=""

#read flags
for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " --platform " ]]; then
        platform_found="1"
        platform_idx=$(($i+1))
        platform_name=${flags[$platform_idx]}
    fi
done

#return the values
echo "$platform_found"
echo "$platform_name"