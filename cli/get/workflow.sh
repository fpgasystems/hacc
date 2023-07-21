#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="$(dirname "$(dirname "$0")")"
DEVICES_LIST="$CLI_PATH/devices_acap_fpga"

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
        #get Bus Device Function
        upstream_port=$($CLI_PATH/get/get_fpga_device_param $device_index upstream_port)
	    bdf="${upstream_port%??}" #i.e., we transform 81:00.0 into 81:00    
        if [[ $(lspci | grep Xilinx | grep $bdf | wc -l) = 1 ]]; then
            echo "$device_index: vivado"
        elif [[ $(lspci | grep Xilinx | grep $bdf | wc -l) = 2 ]]; then
            echo "$device_index: vitis"
        else
            echo "$device_index: unknown"
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
        $CLI_PATH/sgutil get workflow -h
        exit
    fi
    #device_dialog (forgotten mandatory)
    if [[ $multiple_devices = "0" ]]; then
        device_found="1"
        device_index="1"
    elif [[ $device_found = "0" ]]; then
        $CLI_PATH/sgutil get workflow -h
        exit
    fi
    #get Bus Device Function
    upstream_port=$($CLI_PATH/get/get_fpga_device_param $device_index upstream_port)
    bdf="${upstream_port%??}" #i.e., we transform 81:00.0 into 81:00    
    #print
    echo ""
    if [[ $(lspci | grep Xilinx | grep $bdf | wc -l) = 1 ]]; then
        echo "$device_index: vivado"
    elif [[ $(lspci | grep Xilinx | grep $bdf | wc -l) = 2 ]]; then
        echo "$device_index: vitis"
    else
        echo "$device_index: unknown"
    fi
    echo ""
fi