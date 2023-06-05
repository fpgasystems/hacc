#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
HACC_PATH="/opt/hacc"
DEVICES_LIST="$HACC_PATH/devices_reconfigurable"

#check on DEVICES_LIST
source "$CLI_PATH/common/device_list_check" "$DEVICES_LIST"

#get number of fpga and acap devices present
MAX_DEVICES=$(grep -E "fpga|acap" $DEVICES_LIST | wc -l)

#inputs
read -a flags <<< "$@"

#check on multiple Xilinx devices
multiple_devices=$($CLI_PATH/common/get_multiple_devices $DEVICES_LIST)

echo ""

#check on flags
device_found=""
device_index=""
if [ "$flags" = "" ]; then
    #print devices information
    for device_index in 1 2 3 4; do #0 1 2 3
        name=$($CLI_PATH/get/get_fpga_device_param $device_index serial_number)
        if [ -n "$name" ]; then
            #type=$($CLI_PATH/get/get_fpga_device_param $device_index device_type)
            echo "$device_index: $name" #"$device_index: $type - $name"
        fi
    done
    echo ""
else
    #find flags and values
    for (( i=0; i<${#flags[@]}; i++ ))
    do
        if [[ " ${flags[$i]} " =~ " -d " ]] || [[ " ${flags[$i]} " =~ " --device " ]]; then # flags[i] is -d or --device
            device_found="1"
            device_idx=$(($i+1))
            device_index=${flags[$device_idx]}
        fi  
    done
    #forbidden combinations
    if [[ $device_found = "0" ]] || [[ $device_index = "" ]] || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 1 ))); then
        $CLI_PATH/sgutil get device -h
        exit
    fi
    #device_index should be between {0 .. MAX_DEVICES - 1}
    #MAX_DEVICES=$(($MAX_DEVICES-1))
    if [[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 1 ]]; then
        $CLI_PATH/sgutil get device -h
        exit
    fi
    #print
    name=$($CLI_PATH/get/get_fpga_device_param $device_index serial_number)
    #type=$($CLI_PATH/get/get_fpga_device_param $device_index device_type)
    echo "$device_index: $name" #"$device_index: $type - $name"
    echo ""
fi