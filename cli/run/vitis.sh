#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="$(dirname "$(dirname "$0")")"
XILINX_PLATFORMS_PATH=$($CLI_PATH/common/get_constant $CLI_PATH XILINX_PLATFORMS_PATH)
XRT_PATH=$($CLI_PATH/common/get_constant $CLI_PATH XRT_PATH)
DEVICES_LIST="$CLI_PATH/devices_acap_fpga"
MY_PROJECTS_PATH=$($CLI_PATH/common/get_constant $CLI_PATH MY_PROJECTS_PATH)
WORKFLOW="vitis"

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#check on ACAP or FPGA servers (server must have at least one ACAP or one FPGA)
acap=$($CLI_PATH/common/is_acap $CLI_PATH $hostname)
fpga=$($CLI_PATH/common/is_fpga $CLI_PATH $hostname)
if [ "$acap" = "0" ] && [ "$fpga" = "0" ]; then
    echo ""
    echo "Sorry, this command is not available on ${bold}$hostname!${normal}"
    echo ""
    exit
fi

#check on valid XRT version
if [ ! -d $XRT_PATH ]; then
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
if ! [ -d "$MY_PROJECTS_PATH/$WORKFLOW/" ]; then
    echo ""
    echo "You must build and/or program (target = hw) your project/device first! Please, use sgutil build/program vitis"
    echo ""
    exit
fi

#inputs
read -a flags <<< "$@"

#check on flags
project_found=""
project_name=""
target_found=""
target_name=""
device_found=""
device_index=""
if [ "$flags" = "" ]; then
    #header (1/2)
    echo ""
    echo "${bold}sgutil run vitis${normal}"
    #project_dialog
    echo ""
    echo "${bold}Please, choose your $WORKFLOW project:${normal}"
    echo ""
    result=$($CLI_PATH/common/project_dialog $MY_PROJECTS_PATH/$WORKFLOW) #$USER $WORKFLOW
    project_found=$(echo "$result" | sed -n '1p')
    project_name=$(echo "$result" | sed -n '2p')
    multiple_projects=$(echo "$result" | sed -n '3p')
    if [[ $multiple_projects = "0" ]]; then
        echo $project_name
    fi
    #target_dialog
    echo ""
    echo "${bold}Please, choose binary's execution target:${normal}"
    echo ""
    target_name=$($CLI_PATH/common/target_dialog)
    #platform or device dialog
    if [ "$target_name" = "sw_emu" ] || [ "$target_name" = "hw_emu" ]; then
        #platform_dialog
        echo ""
        echo "${bold}Please, choose your platform:${normal}"
        echo ""
        result=$($CLI_PATH/common/platform_dialog $XILINX_PLATFORMS_PATH)
        platform_found=$(echo "$result" | sed -n '1p')
        platform_name=$(echo "$result" | sed -n '2p')
        multiple_platforms=$(echo "$result" | sed -n '3p')
        if [[ $multiple_platforms = "0" ]]; then
            echo $platform_name
        fi
        #set default device
        device_found="1"
        device_index="1"
    elif [ "$target_name" = "hw" ]; then 
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
    fi    
else
    #project_dialog_check
    result="$("$CLI_PATH/common/project_dialog_check" "${flags[@]}")"
    project_found=$(echo "$result" | sed -n '1p')
    project_name=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if [ "$project_found" = "1" ] && ([ "$project_name" = "" ] || [ ! -d "$MY_PROJECTS_PATH/$WORKFLOW/$project_name" ]); then 
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
    #platform_dialog_check
    result="$("$CLI_PATH/common/platform_dialog_check" "${flags[@]}")"
    platform_found=$(echo "$result" | sed -n '1p')
    platform_name=$(echo "$result" | sed -n '2p')    
    #forbidden combinations
    if ([ "$platform_found" = "1" ] && [ "$platform_name" = "" ]) || ([ "$platform_found" = "1" ] && [ ! -d "$XILINX_PLATFORMS_PATH/$platform_name" ]); then
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
    #forbidden target/device combinations (1)
    if [[ "$target_name" = "sw_emu" || "$target_name" = "hw_emu" ]] && [[ "$device_found" = "1" ]]; then
        $CLI_PATH/sgutil run vitis -h
        exit
    fi
    #forbidden target/device combinations (2)
    if [[ "$target_name" = "hw" ]] && [[ "$platform_found" = "1" ]]; then
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
        result=$($CLI_PATH/common/project_dialog $MY_PROJECTS_PATH/$WORKFLOW) #$USER $WORKFLOW
        project_found=$(echo "$result" | sed -n '1p')
        project_name=$(echo "$result" | sed -n '2p')
        multiple_projects=$(echo "$result" | sed -n '3p')
        if [[ $multiple_projects = "0" ]]; then
            echo $project_name
        fi
        #echo ""
    fi
    #target_dialog (forgotten mandatory 2)
    if [[ $target_found = "0" ]]; then
        echo "${bold}Please, choose binary's execution target:${normal}"
        echo ""
        target_name=$($CLI_PATH/common/target_dialog)
    fi
    #platform or device dialog
    if [ "$target_name" = "sw_emu" ] || [ "$target_name" = "hw_emu" ]; then
        #platform_dialog (forgotten mandatory emu)
        if [[ $platform_found = "0" ]]; then
            echo ""
            echo "${bold}Please, choose your platform:${normal}"
            echo ""
            result=$($CLI_PATH/common/platform_dialog $XILINX_PLATFORMS_PATH)
            platform_found=$(echo "$result" | sed -n '1p')
            platform_name=$(echo "$result" | sed -n '2p')
            multiple_platforms=$(echo "$result" | sed -n '3p')
            if [[ $multiple_platforms = "0" ]]; then
                echo $platform_name
            fi
        fi
        #set default device
        device_found="1"
        device_index="1"
    elif [ "$target_name" = "hw" ]; then 
        #device_dialog (forgotten mandatory hw)
        if [[ $multiple_devices = "0" ]]; then
            device_found="1"
            device_index="1"
        elif [[ $device_found = "0" ]]; then
            echo ""
            echo "${bold}Please, choose your device:${normal}"
            echo ""
            result=$($CLI_PATH/common/device_dialog $CLI_PATH $MAX_DEVICES $multiple_devices)
            device_found=$(echo "$result" | sed -n '1p')
            device_index=$(echo "$result" | sed -n '2p')
            echo ""
        fi
    fi
fi

#define directories (1)
DIR="$MY_PROJECTS_PATH/$WORKFLOW/$project_name"

#check if project exists
if ! [ -d "$DIR" ]; then
    echo ""
    echo "$DIR is not a valid --project name!"
    echo ""
    exit
fi

#get platform
if [ "$target_name" = "hw" ]; then 
    platform_name=$($CLI_PATH/get/get_fpga_device_param $device_index platform)
fi

#define directories (2)
APP_BUILD_DIR="$MY_PROJECTS_PATH/$WORKFLOW/$project_name/build_dir.$target_name.$platform_name"

#check for build directory
if ! [ -d "$APP_BUILD_DIR" ]; then
    echo ""
    echo "You must build your project first! Please, use sgutil build vitis"
    echo ""
    exit
fi

#revert to xrt first if FPGA is already in baremetal (this is needed also for sw_emu and hw_emu, i.e. when we do not use sgutil program vitis)
#$CLI_PATH/program/revert -d $device_index

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

#get bdf
upstream_port=$($CLI_PATH/get/get_fpga_device_param $device_index upstream_port)
bdf="${upstream_port::-1}1"

#execution
cd $DIR
echo "${bold}Running accelerated application:${normal}"
echo ""
#echo "make run TARGET=$target_name PLATFORM=$platform_name" 
#echo ""
#eval "make run TARGET=$target_name PLATFORM=$platform_name"
#echo ""

case "$target_name" in
    sw_emu|hw_emu)
        #echo "./$project_name -x ./build_dir.$target_name.$platform_name/vadd.xclbin" 
        #echo ""
        #eval "./$project_name -x ./build_dir.$target_name.$platform_name/vadd.xclbin"
        #echo ""
        echo "make run TARGET=$target_name PLATFORM=$platform_name" 
        echo ""
        eval "make run TARGET=$target_name PLATFORM=$platform_name"
        echo ""
        ;;
    hw)
        echo "./$project_name -x ./build_dir.$target_name.$platform_name/vadd.xclbin $bdf" 
        echo ""
        eval "./$project_name -x ./build_dir.$target_name.$platform_name/vadd.xclbin $bdf"
        echo ""
        ;;
esac