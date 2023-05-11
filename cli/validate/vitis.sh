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

echo "multiple_devices=$multiple_devices"

#check on flags
device_found=""
device_index=""
if [ "$flags" = "" ]; then

    echo "no flags"

    #get device index
    if [[ "$multiple_devices" == "0" ]]; then
        #servers with only one FPGA (i.e., alveo-u55c-01)
        device_index="0"
    elif [[ "$multiple_devices" == "1" ]]; then #$(lspci | grep Xilinx | wc -l) = 8
        #servers with four FPGAs (i.e., hacc-box-01)
        echo "hola!"
        #we need to ask for the index
        #0
        #1
        #2
        #3

    fi
else

    echo "flags"

    #find flags and values
    for (( i=0; i<${#flags[@]}; i++ ))
    do
        if [[ " ${flags[$i]} " =~ " -d " ]] || [[ " ${flags[$i]} " =~ " --device " ]]; then # flags[i] is -d or --device
            device_found="1"
            device_idx=$(($i+1))
            device_index=${flags[$device_idx]}
        fi  
    done

    echo "device_found=$device_found"
    echo "device_idx=$device_idx"
    echo "device_index=$device_index"

    #forbidden combinations
    if [[ $device_found = "0" ]] || [[ $device_index = "" ]] || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 0 ))); then
        #$CLI_WORKDIR/sgutil validate vitis -h
        echo "Forbidden comb."
        /opt/cli/sgutil validate vitis -h
        exit
    fi
fi

#device_index should be between {0 .. MAX_DEVICES - 1}
MAX_DEVICES=$(($MAX_DEVICES-1))
if [[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 0 ]]; then
    echo "Not in range"
    /opt/cli/sgutil validate vitis -h
    exit
fi

echo ""
echo "${bold}sgutil validate vitis${normal}"
echo ""

#get BDF from device_idx
bdf="xxx"

#validate
#/opt/xilinx/xrt/bin/xbutil validate --device $bdf



echo ""