#!/bin/bash

CLI_WORKDIR=$1 
MAX_DEVICES=$2 
multiple_devices=$3

# Declare global variables
declare -g device_found=""
declare -g device_index=""

#get device index
if [[ "$multiple_devices" == "0" ]]; then
    #servers with only one FPGA (i.e., alveo-u55c-01)
    device_index="0"
elif [[ "$multiple_devices" == "1" ]]; then 
    #servers with four FPGAs (i.e., hacc-box-01)
    #declare an empty array to store the device strings
    devices=()
    #iterate over the indices 0 to MAX_DEVICES-1 using a for loop
    for ((i=0; i<MAX_DEVICES; i++)); do
        #retrieve the parameters for each device using the current index
        id=$($CLI_WORKDIR/get/get_device_param $i id)
        device_type=$($CLI_WORKDIR/get/get_device_param $i device_type)
        device_name=$($CLI_WORKDIR/get/get_device_param $i device_name)
        serial_number=$($CLI_WORKDIR/get/get_device_param $i serial_number)
        #concatenate the parameter values into a single string and add it to the array
        devices+=("$id [$device_type - $device_name - $serial_number]")
    done
    #multiple choice
    #echo ""
    #echo "${bold}Please, choose your device:${normal}"
    #echo ""
    PS3=""
    select device_index in "${devices[@]}"; do
        if [[ -z $device_index ]]; then
            echo "" >&/dev/null
        else
            device_found="1"
            device_index=${device_index:0:1}
            break
        fi
    done
fi

#return the values of device_found and device_index
echo "$device_found"
echo "$device_index"