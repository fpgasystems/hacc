#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
HACC_PATH="/opt/hacc"
DEVICES_LIST="$HACC_PATH/devices_gpu"

#check on DEVICES_LIST
source "$CLI_PATH/common/device_list_check" "$DEVICES_LIST"

#get number of gpu devices present
MAX_DEVICES=$(grep -E "gpu" $DEVICES_LIST | wc -l)

#inputs
read -a flags <<< "$@"

#check on multiple Xilinx devices
#multiple_devices=$($CLI_PATH/common/get_multiple_devices $DEVICES_LIST)
if (( $MAX_DEVICES > 1 )); then
    multiple_devices=1
else
    multiple_devices=0
fi

echo $multiple_devices

#check on flags
device_found=""
device_index=""
if [ "$flags" = "" ]; then
    echo ""
    #print devices information
    for device_index in $(seq 1 $MAX_DEVICES); do 
        upstream_port=$($CLI_PATH/get/get_fpga_device_param $device_index upstream_port)
        bdf="${upstream_port::-1}1"
        if [ -n "$bdf" ]; then
            echo "$device_index: $bdf"
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
    #device_dialog (forgotten mandatory)
    if [[ $multiple_devices = "0" ]]; then
        device_found="1"
        device_index="1"
    elif [[ $device_found = "0" ]]; then
        $CLI_PATH/sgutil get bus -h
        exit
    fi
    #print
    upstream_port=$($CLI_PATH/get/get_fpga_device_param $device_index upstream_port)
    bdf="${upstream_port::-1}1"
    echo ""
    echo "$device_index: $bdf"
    echo ""
fi