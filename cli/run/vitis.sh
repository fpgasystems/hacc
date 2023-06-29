#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
HACC_PATH="/opt/hacc"
XRT_PATH="/opt/xilinx/xrt"
ACAP_SERVERS_LIST="$CLI_PATH/constants/ACAP_SERVERS_LIST"
FPGA_SERVERS_LIST="$CLI_PATH/constants/FPGA_SERVERS_LIST"
DEVICES_LIST="$HACC_PATH/devices_reconfigurable"
WORKFLOW="vitis"

#get username
username=$USER

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#check on ACAP or FPGA servers (GPU or build servers not allowed)
if ! (grep -q "^$hostname$" $FPGA_SERVERS_LIST || grep -q "^$hostname$" $ACAP_SERVERS_LIST); then
    echo ""
    echo "Sorry, this command is not available on ${bold}$hostname!${normal}"
    echo ""
    exit
fi

#check on valid XRT version
if [ ! -d $XRT_PATH ]; then #if [ -z "$(echo $XILINX_XRT)" ]; then
    echo ""
    echo "Please, source a valid XRT and Vitis version for ${bold}$hostname!${normal}"
    echo ""
    exit 1
fi

#check on DEVICES_LIST
source "$CLI_PATH/common/device_list_check" "$DEVICES_LIST"

#get number of fpga and acap devices present
MAX_DEVICES=$(grep -E "fpga|acap" $DEVICES_LIST | wc -l)

#check on multiple devices
multiple_devices=$($CLI_PATH/common/get_multiple_devices $MAX_DEVICES)

#check if workflow exists
if ! [ -d "/home/$username/my_projects/$WORKFLOW/" ]; then
    echo ""
    echo "You must build and/or program (target = hw) your project/device first! Please, use sgutil build/program vitis"
    echo ""
    exit
fi

# inputs
read -a flags <<< "$@"

#check on flags
project_found=""
project_name=""
device_found=""
device_index=""
target_found=""
target_name=""
if [ "$flags" = "" ]; then
    #header (1/2)
    echo ""
    echo "${bold}sgutil run vitis${normal}"
    #project_dialog
    echo ""
    echo "${bold}Please, choose your $WORKFLOW project:${normal}"
    echo ""
    result=$($CLI_PATH/common/project_dialog $username $WORKFLOW)
    project_found=$(echo "$result" | sed -n '1p')
    project_name=$(echo "$result" | sed -n '2p')
    multiple_projects=$(echo "$result" | sed -n '3p')
    if [[ $multiple_projects = "0" ]]; then
        echo $project_name
    fi
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
    #target_dialog
    echo ""
    echo "${bold}Please, choose binary's execution target:${normal}"
    echo ""
    target_name=$($CLI_PATH/common/target_dialog)
else
    #project_dialog_check
    result="$("$CLI_PATH/common/project_dialog_check" "${flags[@]}")"
    project_found=$(echo "$result" | sed -n '1p')
    project_name=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if [ "$project_found" = "1" ] && ([ "$project_name" = "" ] || [ ! -d "/home/$username/my_projects/$WORKFLOW/$project_name" ]); then 
        $CLI_PATH/sgutil run vitis -h
        exit
    fi
    #device_dialog_check
    result="$("$CLI_PATH/common/device_dialog_check" "${flags[@]}")"
    device_found=$(echo "$result" | sed -n '1p')
    device_index=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if ([ "$device_found" = "1" ] && [ "$device_index" = "" ]) || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 1 ))) || ([ "$device_found" = "1" ] && ([[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 1 ]])); then
        $CLI_PATH/sgutil run vitis -h
        exit
    fi
    #target_dialog_check
    result="$("$CLI_PATH/common/target_dialog_check" "${flags[@]}")"
    target_found=$(echo "$result" | sed -n '1p')
    target_name=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if [[ "$target_found" = "1" && ! ( "$target_name" = "sw_emu" || "$target_name" = "hw_emu" || "$target_name" = "hw" ) ]]; then
        $CLI_PATH/sgutil run vitis -h
        exit
    fi
    #header (2/2)
    echo ""
    echo "${bold}sgutil run vitis${normal}"
    echo ""
    #project_dialog (forgotten mandatory 1)
    if [[ $project_found = "0" ]]; then
        #echo ""
        echo "${bold}Please, choose your $WORKFLOW project:${normal}"
        echo ""
        result=$($CLI_PATH/common/project_dialog $username $WORKFLOW)
        project_found=$(echo "$result" | sed -n '1p')
        project_name=$(echo "$result" | sed -n '2p')
        multiple_projects=$(echo "$result" | sed -n '3p')
        if [[ $multiple_projects = "0" ]]; then
            echo $project_name
        fi
        #echo ""
    fi
    #device_dialog (forgotten mandatory 2)
    if [[ $multiple_devices = "0" ]]; then
        device_found="1"
        device_index="1"
    elif [[ $device_found = "0" ]]; then
        echo "${bold}Please, choose your device:${normal}"
        echo ""
        result=$($CLI_PATH/common/device_dialog $CLI_PATH $MAX_DEVICES $multiple_devices)
        device_found=$(echo "$result" | sed -n '1p')
        device_index=$(echo "$result" | sed -n '2p')
        echo ""
    fi
    #target_dialog (forgotten mandatory 3)
    if [[ $target_found = "0" ]]; then
        echo "${bold}Please, choose binary's execution target:${normal}"
        echo ""
        target_name=$($CLI_PATH/common/target_dialog)
    fi
fi

#define directories (1)
DIR="/home/$username/my_projects/$WORKFLOW/$project_name"

#check if project exists
if ! [ -d "$DIR" ]; then
    echo ""
    echo "$DIR is not a valid --project name!"
    echo ""
    exit
fi

#get platform
platform=$($CLI_PATH/get/get_fpga_device_param $device_index platform)

#define directories (2)
APP_BUILD_DIR="/home/$username/my_projects/$WORKFLOW/$project_name/build_dir.$target_name.$platform"

#check for build directory
if ! [ -d "$APP_BUILD_DIR" ]; then
    echo ""
    echo "You must build your project first! Please, use sgutil build vitis"
    echo ""
    exit
fi

#revert to xrt first if FPGA is already in baremetal (this is needed also for sw_emu and hw_emu, i.e. when we do not use sgutil program vitis)
sudo $CLI_PATH/program/revert -d $device_index

#change directory
echo ""
echo "${bold}Changing directory:${normal}"
echo ""
echo "cd $DIR"
echo ""
#cd $DIR

#display configuration
cd $DIR/configs/
config_id=$(ls *.active)
config_id="${config_id%%.*}"

echo "${bold}You are running $config_id:${normal}"
echo ""
cat $DIR/configs/config_000.hpp
echo ""

echo "We should be running Vitis on device=$device_index"
echo ""

#execution
cd $DIR
echo "${bold}Running accelerated application:${normal}"
echo ""
echo "make run TARGET=$target_name PLATFORM=$platform" 
echo ""
eval "make run TARGET=$target_name PLATFORM=$platform"
echo ""

# This is equivalent to do ./$project_name path_to_target_xclbin, i.e.:
#   ./test_6 ./build_dir.sw_emu.xilinx_u55c_gen3x16_xdma_3_202210_1/vadd.xclbin