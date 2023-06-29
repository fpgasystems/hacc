#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
HACC_PATH="/opt/hacc"
XILINX_PATH="/opt/xilinx"
CPU_SERVERS_LIST="$CLI_PATH/constants/CPU_SERVERS_LIST"
DEVICES_LIST="$HACC_PATH/devices_reconfigurable"

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#check on build server
if grep -q "^$hostname$" $CPU_SERVERS_LIST; then
    echo ""
    ls -l $XILINX_PATH/platforms/ | grep '^d' | awk '{print $NF}'
    echo ""
    exit
fi

#check on DEVICES_LIST
source "$CLI_PATH/common/device_list_check" "$DEVICES_LIST"

#get number of fpga and acap devices present
MAX_DEVICES=$(grep -E "fpga|acap" $DEVICES_LIST | wc -l)

#check on multiple devices
multiple_devices=$($CLI_PATH/common/get_multiple_devices $MAX_DEVICES)

#inputs
read -a flags <<< "$@"

#check on flags
device_found=""
device_index=""
if [ "$flags" = "" ]; then
    echo ""
    #print devices information
    for device_index in $(seq 1 $MAX_DEVICES); do 
        platform=$($CLI_PATH/get/get_fpga_device_param $device_index platform)
        if [ -n "$platform" ]; then
            echo "$device_index: $platform"
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
        $CLI_PATH/sgutil get platform -h
        exit
    fi
    #device_dialog (forgotten mandatory)
    if [[ $multiple_devices = "0" ]]; then
        device_found="1"
        device_index="1"
    elif [[ $device_found = "0" ]]; then
        $CLI_PATH/sgutil get platform -h
        exit
    fi
    #print
    platform=$($CLI_PATH/get/get_fpga_device_param $device_index platform)
    echo ""
    echo "$device_index: $platform"
    echo ""
fi