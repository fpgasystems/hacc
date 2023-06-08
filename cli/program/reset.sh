#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
HACC_PATH="/opt/hacc"
XRT_PATH="/opt/xilinx/xrt"
DEVICES_LIST="$HACC_PATH/devices_reconfigurable"

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#check on DEVICES_LIST
source "$CLI_PATH/common/device_list_check" "$DEVICES_LIST"

#get number of fpga and acap devices present
MAX_DEVICES=$(grep -E "fpga|acap" $DEVICES_LIST | wc -l)

#check on multiple devices
multiple_devices=$($CLI_PATH/common/get_multiple_devices $MAX_DEVICES)

# inputs
read -a flags <<< "$@"

echo ""
echo "${bold}sgutil program reset${normal}"

##derive actions to perform
#serial_found="0"
#for (( i=0; i<${#flags[@]}; i++ ))
#do
#    if [[ " ${flags[$i]} " =~ " -s " ]] || [[ " ${flags[$i]} " =~ " --serial " ]]; then 
#        serial_found="1"
#    fi
#done

##sgutil get serial if there is only one FPGA and not serial_found
#if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $serial_found = "0" ]]; then
#    #serial_number=$(/opt/cli/get/serial | cut -d "=" -f2)
#    serial_number="--device"
#fi

#check on flags
device_found=""
device_index=""
if [ "$flags" = "" ]; then
    #device_dialog
    if [[ $multiple_devices = "0" ]]; then
        device_found="1"
        device_index="1"
    else
        echo ""
        echo "${bold}Please, choose your device:${normal}"
        echo ""
        result=$($CLI_PATH/common/device_dialog $CLI_PATH $MAX_DEVICES $multiple_devices)
        device_found=$(echo "$result" | sed -n '1p')
        device_index=$(echo "$result" | sed -n '2p')
    fi
else
    #device_dialog_check
    result="$("$CLI_PATH/common/device_dialog_check" "${flags[@]}")"
    device_found=$(echo "$result" | sed -n '1p')
    device_index=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if ([ "$device_found" = "1" ] && [ "$device_index" = "" ]) || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 1 ))) || ([ "$device_found" = "1" ] && ([[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 1 ]])); then
        $CLI_PATH/sgutil program reset -h
        exit
    fi
    #device_dialog (forgotten mandatory)
    if [[ $multiple_devices = "0" ]]; then
        device_found="1"
        device_index="1"
    elif [[ $device_found = "0" ]]; then
        $CLI_PATH/sgutil program reset -h
        exit
    fi
fi

#revert
$CLI_PATH/program/revert -d $device_index

#get BDF (i.e., Bus:Device.Function) 
upstream_port=$($CLI_PATH/get/get_fpga_device_param $device_index upstream_port)
bdf="${upstream_port%?}1"

#reset device (we delete any xclbin) if xx:xx.1 (bdf) function is present
if lspci | grep -q "$bdf"; then
    $XRT_PATH/bin/xbutil reset --device $bdf --force
    echo ""
fi