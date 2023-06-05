#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
HACC_PATH="/opt/hacc"
DEVICE_LIST_FPGA="$HACC_PATH/devices_reconfigurable"

#check on DEVICES_LIST
source "$CLI_PATH/common/device_list_check" "$DEVICE_LIST_FPGA"

#get number of fpga and acap devices present
MAX_DEVICES=$(grep -E "fpga|acap" $DEVICE_LIST_FPGA | wc -l)

#inputs
read -a flags <<< "$@"

#check on multiple Xilinx devices
multiple_devices=$($CLI_PATH/common/get_multiple_devices $DEVICE_LIST_FPGA)

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
        $CLI_PATH/sgutil get device -h
        exit
    fi
    #print
    upstream_port=$($CLI_PATH/get/get_fpga_device_param $device_index upstream_port)
    bdf="${upstream_port::-1}1"
    echo ""
    echo "$device_index: $bdf"
    echo ""
fi