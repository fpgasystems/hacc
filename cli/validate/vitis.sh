#!/bin/bash

DATABASE="/opt/hacc/devices"

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_WORKDIR="/opt/cli"
MAX_DEVICES=4

#get username
username=$USER

# get hostname
#url="${HOSTNAME}"
#hostname="${url%%.*}"

# create my_projects directory
#DIR="/home/$username/my_projects"
#if ! [ -d "$DIR" ]; then
#    mkdir ${DIR}
#fi

# create hip directory
#DIR="/home/$username/my_projects/hip"
#if ! [ -d "$DIR" ]; then
#    mkdir ${DIR}
#fi

# inputs
read -a flags <<< "$@"

# Check if the DATABASE exists
#if [[ ! -f "$DATABASE" ]]; then
#  echo ""
#  echo "Please, update $DATABASE according to your infrastructure."
#  echo ""
#  exit 1
#fi

#the file exists - check its contents by evaluating first row (device_0)
#device_0=$(head -n 1 "$DATABASE")

#extract the second, third, and fourth columns (upstream_port, root_port, LinkCtl) using awk
#upstream_port_0=$(echo "$device_0" | awk '{print $2}')
#root_port_0=$(echo "$device_0" | awk '{print $3}')
#LinkCtl_0=$(echo "$device_0" | awk '{print $4}')

#check on non-edited contents
#if [[ $upstream_port_0 == "xx:xx.x" || $root_port_0 == "xx:xx.x" || $LinkCtl_0 == "xx" ]]; then
#  echo ""
#  echo "Please, update $DATABASE according to your infrastructure."
#  echo ""
#  exit
#fi

#check on multiple Xilinx devices
#multiple_devices=""
#devices=$(wc -l < $DATABASE)
#if [ -s $DATABASE ]; then
#    if [ "$devices" -eq 1 ]; then
#        multiple_devices="0"
#    else
#        multiple_devices="1"
#    fi
#else
#    echo ""
#    echo "Please, update $DATABASE according to your infrastructure."
#    echo ""
#    exit
#fi

#check on multiple Xilinx devices
num_devices=$(/opt/cli/common/get_num_devices)
if [[ -z "$num_devices" ]] || [[ "$num_devices" -eq 0 ]]; then
    echo ""
    echo "Please, update $DATABASE according to your infrastructure."
    echo ""
    exit
elif [[ "$num_devices" -eq 1 ]]; then
    multiple_devices="0"
else
    multiple_devices="1"
fi

#if [[ -z $(lspci | grep Xilinx) ]]; then
#    multiple_devices=""
#    echo "No Xilinx device found."
#    echo ""
#    exit
#elif [[ $(lspci | grep Xilinx | wc -l) = 2 ]]; then
#    #servers with only one FPGA (i.e., alveo-u55c-01)
#    multiple_devices="0"
#elif [[ $(lspci | grep Xilinx | wc -l) -gt 2 ]]; then
#    #servers with eight FPGAs (i.e., alveo-u280)
#    multiple_devices="1"
#else
#    echo "Unexpected number of Xilinx devices."
#    echo ""
#    exit
#fi

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
    if ([ "$device_found" = "1" ] && [ "$device_index" = "" ]) || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 1 ))) || ([ "$device_found" = "1" ] && ([[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 1 ]])); then #[[ $device_found = "0" ]] || 
        $CLI_WORKDIR/sgutil validate vitis -h
        exit
    fi
    #header (2/2)
    echo ""
    echo "${bold}sgutil validate vitis${normal}"
    #forgotten mandatories
    #device_dialog
    if [[ $device_found = "0" ]]; then
        echo ""
        echo "${bold}Please, choose your device:${normal}"
        echo ""
        result=$($CLI_WORKDIR/common/device_dialog $CLI_WORKDIR $MAX_DEVICES $multiple_devices)
        device_found=$(echo "$result" | sed -n '1p')
        device_index=$(echo "$result" | sed -n '2p')
    fi
fi

#device_index should be between {0 .. MAX_DEVICES - 1}
#MAX_DEVICES=$(($MAX_DEVICES-1))
if [[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 1 ]]; then
    $CLI_WORKDIR/sgutil validate vitis -h
    exit
fi

echo ""
echo "${bold}sgutil validate vitis${normal}"
echo ""

#get BDF from device_idx
upstream_port=$($CLI_WORKDIR/get/get_device_param $device_index upstream_port)
bdf=$(echo "$upstream_port" | sed 's/0$/1/')

#validate
/opt/xilinx/xrt/bin/xbutil validate --device $bdf

echo ""