#!/bin/bash

flags=("$@")  # Assign command-line arguments to the 'flags' array
#CLI_WORKDIR="$1"                 # Assign the first argument to the variable cli_workdir
#shift                            # Shift the remaining arguments by one position
#flags=("$@")                     # Assign the shifted arguments to the flags array
#multiple_devices="${flags[-1]}"  # Retrieve the last element as the value for multiple_devices

# Declare global variables
declare -g device_found="0"
declare -g device_idx=""
declare -g device_index=""
#declare -g device_error=""

#read flags
for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " -d " ]] || [[ " ${flags[$i]} " =~ " --device " ]]; then # flags[i] is -d or --device
        device_found="1"
        device_idx=$(($i+1))
        device_index=${flags[$device_idx]}
    fi  
done

#forbidden combinations
#if [[ $device_index = "" ]] || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 0 ))); then #[[ $device_found = "0" ]] || 
#    $CLI_WORKDIR/sgutil program vitis -h
#    exit
#    #device_error="1"
#fi

#return the values
echo "$device_found"
echo "$device_idx"
echo "$device_index"
#echo "$device_error"