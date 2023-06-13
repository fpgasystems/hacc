#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
HACC_PATH="/opt/hacc"
XILINX_PATH="/opt/xilinx"
XRT_PATH="$XILINX_PATH/xrt"
DEVICES_LIST="$HACC_PATH/devices_reconfigurable"
WORKFLOW="vitis"

#get username
username=$USER

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#check on DEVICES_LIST
source "$CLI_PATH/common/device_list_check" "$DEVICES_LIST"

#get number of fpga and acap devices present
MAX_DEVICES=$(grep -E "fpga|acap" $DEVICES_LIST | wc -l)

#check on multiple devices
multiple_devices=$($CLI_PATH/common/get_multiple_devices $MAX_DEVICES)

#check if workflow exists
if ! [ -d "/home/$username/my_projects/$WORKFLOW/" ]; then
    echo ""
    echo "You must create your project first! Please, use sgutil new vitis"
    echo ""
    exit
fi

#inputs
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
    echo "${bold}sgutil build vitis${normal}"
    #project_dialog
    echo ""
    echo "${bold}Please, choose your $WORKFLOW project:${normal}"
    echo ""
    result=$($CLI_PATH/common/project_dialog $username $WORKFLOW)
    project_found=$(echo "$result" | sed -n '1p')
    project_name=$(echo "$result" | sed -n '2p')
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
        $CLI_PATH/sgutil build vitis -h
        exit
    fi
    #device_dialog_check
    result="$("$CLI_PATH/common/device_dialog_check" "${flags[@]}")"
    device_found=$(echo "$result" | sed -n '1p')
    device_index=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if ([ "$device_found" = "1" ] && [ "$device_index" = "" ]) || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 1 ))) || ([ "$device_found" = "1" ] && ([[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 1 ]])); then
        $CLI_PATH/sgutil build vitis -h
        exit
    fi
    #target_dialog_check
    result="$("$CLI_PATH/common/target_dialog_check" "${flags[@]}")"
    target_found=$(echo "$result" | sed -n '1p')
    target_name=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if [[ "$target_found" = "1" && ! ( "$target_name" = "sw_emu" || "$target_name" = "hw_emu" || "$target_name" = "hw" ) ]]; then
        $CLI_PATH/sgutil build vitis -h
        exit
    fi
    #header (2/2)
    echo ""
    echo "${bold}sgutil build vitis${normal}"
    echo ""
    #project_dialog (forgotten mandatory 1)
    if [[ $project_found = "0" ]]; then
        #echo ""
        echo "${bold}Please, choose your $WORKFLOW project:${normal}"
        echo ""
        result=$($CLI_PATH/common/project_dialog $username $WORKFLOW)
        project_found=$(echo "$result" | sed -n '1p')
        project_name=$(echo "$result" | sed -n '2p')
        echo ""
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

#check for project directory
if ! [ -d "$DIR" ]; then
    echo ""
    echo "$DIR is not a valid --project name!"
    echo ""
    exit
fi

#select vivado release
if [ "$hostname" = "alveo-build-01" ]; then
    echo ""
    echo "${bold}Please, select your favourite Vivado release:${normal}" 
    echo ""
    PS3=""
    select release in 2022.1 2022.2
    do
        case $release in
            2022.1) break;;
            2022.2) break;;
        esac
    done
    #enable release
    eval "source xrt_select $release"
fi

#create or select a configuration
cd $DIR/configs/
if [[ $(ls -l | wc -l) = 2 ]]; then
    #only config_000 exists and we create config_kernel and config_001
    #we compile create_config (in case there were changes)
    cd $DIR/src
    g++ -std=c++17 create_config.cpp -o ../create_config >&/dev/null
    cd $DIR
    ./create_config
    cp -fr $DIR/configs/config_001.hpp $DIR/configs/config_000.hpp
    config="config_001.hpp"
elif [[ $(ls -l | wc -l) = 5 ]]; then
    #config_000, config_kernel and config_001 exist
    cp -fr $DIR/configs/config_001.hpp $DIR/configs/config_000.hpp
    config="config_001.hpp"
    echo ""
elif [[ $(ls -l | wc -l) > 5 ]]; then
    cd $DIR/configs/
    configs=( "config_"*.hpp )
    echo ""
    echo "${bold}Please, choose your configuration:${normal}"
    echo ""
    PS3=""
    select config in "${configs[@]:1:${#configs[@]}-2}"; do # with :1 we avoid config_000.hpp and then config_kernel.hpp
        if [[ -z $config ]]; then
            echo "" >&/dev/null
        else
            break
        fi
    done
    # copy selected config as config_000.hpp
    cp -fr $DIR/configs/$config $DIR/configs/config_000.hpp
    echo ""
fi

#save config id
cd $DIR/configs/
if [ -e config_*.active ]; then
    rm *.active
fi
config_id="${config%%.*}"
touch $config_id.active

#serial to platform
cd $XILINX_PATH/platforms
if [ "$hostname" = "alveo-build-01" ]; then
    platforms=( "xilinx_"* )
    echo ""
    echo "${bold}Please, choose the device (or platform):${normal}" 
    echo ""
    PS3=""
    select platform in "${platforms[@]}"; do 
        if [[ -z $platform ]]; then
            echo "" >&/dev/null
        else
            break
        fi
    done
else
    #get platform
    platform=$($CLI_PATH/get/get_fpga_device_param $device_index platform)
fi

#define directories (2)
APP_BUILD_DIR="/home/$username/my_projects/$WORKFLOW/$project_name/build_dir.$target_name.$platform"

echo ""
echo "${bold}Changing directory:${normal}"
echo ""
echo "cd $DIR"
echo ""
cd $DIR

#compilation
if ! [ -d "$APP_BUILD_DIR" ]; then
    # APP_BUILD_DIR does not exist
    export CPATH="/usr/include/x86_64-linux-gnu" #https://support.xilinx.com/s/article/Fatal-error-sys-cdefs-h-No-such-file-or-directory?language=en_US
    echo "${bold}PL kernel compilation and linking: generating .xo and .xclbin:${normal}"
    echo ""
    echo "make all TARGET=$target_name PLATFORM=$platform" 
    echo ""
    eval "make all TARGET=$target_name PLATFORM=$platform"
    echo ""        

    #send email at the end
    if [ "$target_name" = "hw" ]; then
        user_email=$username@ethz.ch
        echo "Subject: Good news! sgutil build vitis ($project_name / TARGET=$target_name / PLATFORM=$platform) is done!" | sendmail $user_email
    fi
    
else
    echo "${bold}PL kernel compilation and linking: generating .xo and .xclbin:${normal}"
    echo ""
    echo "make all TARGET=$target_name PLATFORM=$platform" 
    echo ""
    echo "$APP_BUILD_DIR already exists!"
    echo ""

    #get xrt version
    branch=$($XRT_PATH/bin/xbutil --version | grep -i -w 'Branch' | tr -d '[:space:]')
    branch=${branch:7:6}
    
    #application compilation
    echo "${bold}Application compilation:${normal}"
    echo ""
    echo "g++ -o $project_name /home/$username/my_projects/$WORKFLOW/common/includes/xcl2/xcl2.cpp src/host.cpp -I$XRT_PATH/include -I/tools/Xilinx//Vivado/$branch/include -Wall -O0 -g -std=c++1y -I/home/$username/my_projects/$WORKFLOW/common/includes/xcl2 -fmessage-length=0 -L$XRT_PATH/lib -pthread -lOpenCL -lrt -lstdc++"
    echo ""

    g++ -o $project_name /home/$username/my_projects/$WORKFLOW/common/includes/xcl2/xcl2.cpp src/host.cpp -I$XRT_PATH/include -I/tools/Xilinx//Vivado/$branch/include -Wall -O0 -g -std=c++1y -I/home/$username/my_projects/$WORKFLOW/common/includes/xcl2 -fmessage-length=0 -L$XRT_PATH/lib -pthread -lOpenCL -lrt -lstdc++

fi