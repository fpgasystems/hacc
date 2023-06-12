#!/bin/bash

flags=("$@")  # Assign command-line arguments to the 'flags' array

# Declare global variables
declare -g target_found="0"
declare -g target_name=""

#read flags
for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " -t " ]] || [[ " ${flags[$i]} " =~ " --target " ]]; then
        target_found="1"
        target_idx=$(($i+1))
        target_name=${flags[$target_idx]}
    fi
done

#return the values
echo "$target_found"
echo "$target_name"