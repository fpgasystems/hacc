#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
HACC_PATH="/opt/hacc"
DEVICES_LIST="$HACC_PATH/devices_reconfigurable"

#get number of fpga and acap devices present
MAX_DEVICES=$(grep -E "fpga|acap" $DEVICES_LIST | wc -l)

#inputs
read -a flags <<< "$@"

#check on multiple Xilinx devices
multiple_devices=$($CLI_PATH/common/get_multiple_devices $DEVICES_LIST)

#check on flags
device_found=""
device_index=""
if [ "$flags" = "" ]; then
    #print devices information
    echo ""
    for device_index in $(seq 1 $MAX_DEVICES); do 
        name=$($CLI_PATH/get/get_fpga_device_param $device_index device_name)
        if [ -n "$name" ]; then
            echo "$device_index: $name"
        fi
    done
    echo ""
else
    #device_dialog_check
    result="$("$CLI_PATH/common/device_dialog_check" "${flags[@]}")"
    device_found=$(echo "$result" | sed -n '1p')
    device_index=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if ([ "$device_found" = "1" ] && [ "$device_index" = "" ]) || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 1 ))) || ([ "$device_found" = "1" ] && ([[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 1 ]])); then
        $CLI_PATH/sgutil get device -h
        exit
    fi
    #device_dialog (forgotten mandatory 2)
    if [[ $multiple_devices = "0" ]]; then
        device_found="1"
        device_index="1"
    elif [[ $device_found = "0" ]]; then
        $CLI_PATH/sgutil get device -h
        exit
    fi
    #print
    name=$($CLI_PATH/get/get_fpga_device_param $device_index device_name)
    echo "$device_index: $name"
fi