#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_WORKDIR="/opt/cli"
MAX_DEVICES=4

#get username
username=$USER

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

# get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

# inputs
read -a flags <<< "$@"

#check on multiple Xilinx devices
if [[ -z $(lspci | grep Xilinx) ]]; then
    multiple_devices=""
    echo "No Xilinx device found."
    echo ""
    exit
elif [[ $(lspci | grep Xilinx | wc -l) = 2 ]]; then
    #servers with only one FPGA (i.e., alveo-u55c-01)
    multiple_devices="0"
elif [[ $(lspci | grep Xilinx | wc -l) -gt 2 ]]; then
    #servers with eight FPGAs (i.e., alveo-u280)
    multiple_devices="1"
else
    echo "Unexpected number of Xilinx devices."
    echo ""
    exit
fi

#check on flags
device_found=""
device_index=""
if [ "$flags" = "" ]; then
    #get device index
    if [[ "$multiple_devices" == "0" ]]; then
        #servers with only one FPGA (i.e., alveo-u55c-01)
        device_index="0"
    elif [[ "$multiple_devices" == "1" ]]; then #$(lspci | grep Xilinx | wc -l) = 8
        #servers with four FPGAs (i.e., hacc-box-01)
        #device_0
        id_0=$($CLI_WORKDIR/get/get_device_param 0 id)
        device_type_0=$($CLI_WORKDIR/get/get_device_param 0 device_type)
        device_name_0=$($CLI_WORKDIR/get/get_device_param 0 device_name)
        serial_number_0=$($CLI_WORKDIR/get/get_device_param 0 serial_number)
        #device_1
        id_1=$($CLI_WORKDIR/get/get_device_param 1 id)
        device_type_1=$($CLI_WORKDIR/get/get_device_param 1 device_type)
        device_name_1=$($CLI_WORKDIR/get/get_device_param 1 device_name)
        serial_number_1=$($CLI_WORKDIR/get/get_device_param 1 serial_number)
        #device_2
        id_2=$($CLI_WORKDIR/get/get_device_param 2 id)
        device_type_2=$($CLI_WORKDIR/get/get_device_param 2 device_type)
        device_name_2=$($CLI_WORKDIR/get/get_device_param 2 device_name)
        serial_number_2=$($CLI_WORKDIR/get/get_device_param 2 serial_number)
        #device_3
        id_3=$($CLI_WORKDIR/get/get_device_param 3 id)
        device_type_3=$($CLI_WORKDIR/get/get_device_param 3 device_type)
        device_name_3=$($CLI_WORKDIR/get/get_device_param 3 device_name)
        serial_number_3=$($CLI_WORKDIR/get/get_device_param 3 serial_number)
        #concatenate strings
        devices=( "$id_0 [$device_type_0 - $device_name_0 - $serial_number_0]" "$id_1 [$device_type_1 - $device_name_1 - $serial_number_1]" "$id_2 [$device_type_2 - $device_name_2 - $serial_number_2]" "$id_3 [$device_type_3 - $device_name_3 - $serial_number_3]")
        #multiple choice
        echo ""
        echo "${bold}Please, choose your device:${normal}"
        echo ""
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
    if [[ $device_found = "0" ]] || [[ $device_index = "" ]] || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 0 ))); then
        $CLI_WORKDIR/sgutil validate vitis -h
        exit
    fi
fi

#device_index should be between {0 .. MAX_DEVICES - 1}
MAX_DEVICES=$(($MAX_DEVICES-1))
if [[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 0 ]]; then
    echo "Not in range"
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