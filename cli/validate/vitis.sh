#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)



#constants
CLI_WORKDIR="/opt/cli"
DATABASE="/opt/hacc/devices"

#configuration parameters
MAX_DEVICES=$($CLI_WORKDIR/common/get_MAX_DEVICES)

#get username
username=$USER

#inputs
read -a flags <<< "$@"

#check on multiple Xilinx devices
multiple_devices=$($CLI_WORKDIR/common/get_multiple_devices $DATABASE)

#check on flags
device_found=""
device_index=""
if [ "$flags" = "" ]; then
    #header (1/2)
    echo ""
    echo "${bold}sgutil validate vitis${normal}"
    #device_dialog
    if [[ $multiple_devices = "0" ]]; then
        device_found="1"
        device_index="1"
    else
        echo ""
        echo "${bold}Please, choose your device:${normal}"
        echo ""
        result=$($CLI_WORKDIR/common/device_dialog $CLI_WORKDIR $MAX_DEVICES $multiple_devices)
        device_found=$(echo "$result" | sed -n '1p')
        device_index=$(echo "$result" | sed -n '2p')
    fi
else
    #device_dialog_check
    result="$("$CLI_WORKDIR/common/device_dialog_check" "${flags[@]}")"
    device_found=$(echo "$result" | sed -n '1p')
    device_index=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if ([ "$device_found" = "1" ] && [ "$device_index" = "" ]) || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 1 ))) || ([ "$device_found" = "1" ] && ([[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 1 ]])); then
        $CLI_WORKDIR/sgutil validate vitis -h
        exit
    fi
    #header (2/2)
    echo ""
    echo "${bold}sgutil validate vitis${normal}"
    #device_dialog (forgotten mandatory)
    if [[ $device_found = "0" ]]; then
        echo ""
        echo "${bold}Please, choose your device:${normal}"
        echo ""
        result=$($CLI_WORKDIR/common/device_dialog $CLI_WORKDIR $MAX_DEVICES $multiple_devices)
        device_found=$(echo "$result" | sed -n '1p')
        device_index=$(echo "$result" | sed -n '2p')
    fi
fi

echo ""

#get BDF from device_idx
upstream_port=$($CLI_WORKDIR/get/get_device_param $device_index upstream_port)
bdf=$(echo "$upstream_port" | sed 's/0$/1/')

#validate
/opt/xilinx/xrt/bin/xbutil validate --device $bdf

echo ""