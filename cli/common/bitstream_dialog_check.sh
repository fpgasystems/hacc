#!/bin/bash

flags=("$@")  # Assign command-line arguments to the 'flags' array

# Declare global variables
declare -g bitstream_found="0"
declare -g bitstream_name=""

#read flags
for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " -b " ]] || [[ " ${flags[$i]} " =~ " --bitstream " ]]; then # flags[i] is -d or --device
        bitstream_found="1"
        bitstream_idx=$(($i+1))
        bitstream_name=${flags[$bitstream_idx]}
    fi  
done

#return the values
echo "$bitstream_found"
echo "$bitstream_name"