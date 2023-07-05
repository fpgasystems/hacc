#!/bin/bash

flags=("$@")  # Assign command-line arguments to the 'flags' array

# Declare global variables
declare -g version_found="0"
declare -g version_name=""

#read flags
for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " -v " ]] || [[ " ${flags[$i]} " =~ " --version " ]]; then # flags[i] is -p or --project
        version_found="1"
        version_idx=$(($i+1))
        version_name=${flags[$version_idx]}
    fi
done

#return the values
echo "$version_found"
echo "$version_name"