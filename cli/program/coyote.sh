#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
XRT_PATH="/opt/xilinx/xrt"
HACC_PATH="/opt/hacc"
VIVADO_DEVICES_MAX=$(cat $CLI_PATH/constants/VIVADO_DEVICES_MAX)
DEVICES_LIST="$HACC_PATH/devices_reconfigurable"
MY_PROJECTS_PATH="/home/$USER/my_projects"
WORKFLOW="coyote"
BIT_NAME="cyt_top.bit"
DRIVER_NAME="coyote_drv.ko"

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
    echo "Please, source a valid XRT and Vivado version for ${bold}$hostname!${normal}"
    echo ""
    exit 1
fi

#check on DEVICES_LIST
source "$CLI_PATH/common/device_list_check" "$DEVICES_LIST"

#get number of fpga and acap devices present
MAX_DEVICES=$(grep -E "fpga|acap" $DEVICES_LIST | wc -l)

#check on multiple devices
multiple_devices=$($CLI_PATH/common/get_multiple_devices $MAX_DEVICES)

#check for vivado_developers
member=$($CLI_PATH/common/is_member $USER vivado_developers)
if [ "$member" = "false" ]; then
    echo ""
    echo "Sorry, ${bold}$USER!${normal} You are not granted to use this command."
    echo ""
    exit
fi

#check if workflow exists
if ! [ -d "$MY_PROJECTS_PATH/$WORKFLOW/" ]; then
    echo ""
    echo "You must build your project first! Please, use sgutil build coyote"
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
if [ "$flags" = "" ]; then
    #header (1/2)
    echo ""
    echo "${bold}sgutil program coyote${normal}"
    #project_dialog
    echo ""
    echo "${bold}Please, choose your $WORKFLOW project:${normal}"
    echo ""
    result=$($CLI_PATH/common/project_dialog $USER $WORKFLOW)
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
        #check on VIVADO_DEVICES_MAX
        vivado_devices=$($CLI_PATH/common/get_vivado_devices $CLI_PATH $MAX_DEVICES $device_index)
        if [ $vivado_devices -ge $((VIVADO_DEVICES_MAX)) ]; then
            echo ""
            echo "Sorry, you have reached the maximum number of devices in ${bold}Vivado workflow!${normal}"
            echo ""
            exit
        fi
        #check on acap (temporal until Coyote works on Versal)
        device_type=$($CLI_PATH/get/get_fpga_device_param $device_index device_type)
        if [[ $device_type = "acap" ]]; then
            echo ""
            echo "Sorry, this command is not available on ${bold}$device_type!${normal}"
            echo ""
            exit
        fi
    fi
    #get_servers
    echo ""
    result=$($CLI_PATH/common/get_servers $CLI_PATH $hostname)
    servers_family_list=$(echo "$result" | sed -n '1p' | sed -n '1p')
    servers_family_list_string=$(echo "$result" | sed -n '2p' | sed -n '1p')
    num_remote_servers=$(echo "$servers_family_list" | wc -w)
    echo ""
    #deployment_dialog
    deploy_option="0"
    if [ "$num_remote_servers" -ge 1 ]; then
        echo "${bold}Please, choose your deployment servers:${normal}"
        echo ""
        echo "0) $hostname"
        echo "1) $hostname, $servers_family_list_string"
        deploy_option=$($CLI_PATH/common/deployment_dialog $servers_family_list_string)
        echo ""
    fi
else
    #project_dialog_check
    result="$("$CLI_PATH/common/project_dialog_check" "${flags[@]}")"
    project_found=$(echo "$result" | sed -n '1p')
    project_name=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if [ "$project_found" = "1" ] && ([ "$project_name" = "" ] || [ ! -d "$MY_PROJECTS_PATH/$WORKFLOW/$project_name" ]); then 
        $CLI_PATH/sgutil program coyote -h
        exit
    fi
    #device_dialog_check
    result="$("$CLI_PATH/common/device_dialog_check" "${flags[@]}")"
    device_found=$(echo "$result" | sed -n '1p')
    device_index=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if ([ "$device_found" = "1" ] && [ "$device_index" = "" ]) || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 1 ))) || ([ "$device_found" = "1" ] && ([[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 1 ]])); then
        $CLI_PATH/sgutil program coyote -h
        exit
    fi
    #check on VIVADO_DEVICES_MAX
    vivado_devices=$($CLI_PATH/common/get_vivado_devices $CLI_PATH $MAX_DEVICES $device_index)
    if ([ "$device_found" = "1" ] && [ $vivado_devices -ge $((VIVADO_DEVICES_MAX)) ]); then
        echo ""
        echo "Sorry, you have reached the maximum number of devices in ${bold}Vivado workflow!${normal}"
        echo ""
        exit
    fi
    #check on acap (temporal until Coyote works on Versal)
    device_type=$($CLI_PATH/get/get_fpga_device_param $device_index device_type)
    if ([ "$device_found" = "1" ] && [[ $device_type = "acap" ]]); then
        echo ""
        echo "Sorry, this command is not available on ${bold}$device_type!${normal}"
        echo ""
        exit
    fi
    #deployment_dialog_check
    result="$("$CLI_PATH/common/deployment_dialog_check" "${flags[@]}")"
    deploy_option_found=$(echo "$result" | sed -n '1p')
    deploy_option=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if [ "$deploy_option_found" = "1" ] && { [ "$deploy_option" -ne 0 ] && [ "$deploy_option" -ne 1 ]; }; then #if [ "$deploy_option_found" = "1" ] && [ -n "$deploy_option" ]; then 
        $CLI_PATH/sgutil program coyote -h
        exit
    fi
    #header (2/2)
    echo ""
    echo "${bold}sgutil program coyote${normal}"
    echo ""
    #project_dialog (forgotten mandatory 1)
    if [[ $project_found = "0" ]]; then
        #echo ""
        echo "${bold}Please, choose your $WORKFLOW project:${normal}"
        echo ""
        result=$($CLI_PATH/common/project_dialog $USER $WORKFLOW)
        project_found=$(echo "$result" | sed -n '1p')
        project_name=$(echo "$result" | sed -n '2p')
        multiple_projects=$(echo "$result" | sed -n '3p')
        if [[ $multiple_projects = "0" ]]; then
            echo $project_name
        fi
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
        #check on VIVADO_DEVICES_MAX
        vivado_devices=$($CLI_PATH/common/get_vivado_devices $CLI_PATH $MAX_DEVICES $device_index)
        if [ $vivado_devices -ge $((VIVADO_DEVICES_MAX)) ]; then
            echo ""
            echo "Sorry, you have reached the maximum number of devices in ${bold}Vivado workflow!${normal}"
            echo ""
            exit
        fi
        #check on acap (temporal until Coyote works on Versal)
        device_type=$($CLI_PATH/get/get_fpga_device_param $device_index device_type)
        if [[ $device_type = "acap" ]]; then
            echo ""
            echo "Sorry, this command is not available on ${bold}$device_type!${normal}"
            echo ""
            exit
        fi
        echo ""
    fi
    #get_servers
    result=$($CLI_PATH/common/get_servers $CLI_PATH $hostname)
    servers_family_list=$(echo "$result" | sed -n '1p' | sed -n '1p')
    servers_family_list_string=$(echo "$result" | sed -n '2p' | sed -n '1p')
    num_remote_servers=$(echo "$servers_family_list" | wc -w)
    echo ""
    #deployment_dialog (forgotten mandatory 3)
    if [ "$deploy_option_found" = "0" ]; then
        #deployment_dialog
        deploy_option="0"
        if [ "$num_remote_servers" -ge 1 ]; then
            echo "${bold}Please, choose your deployment servers:${normal}"
            echo ""
            echo "0) $hostname"
            echo "1) $hostname, $servers_family_list_string"
            deploy_option=$($CLI_PATH/common/deployment_dialog $servers_family_list_string)
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

#platform to FDEV_NAME
platform=$(/opt/cli/get/get_fpga_device_param $device_index platform)
FDEV_NAME=$(echo "$platform" | cut -d'_' -f2)

#define directories (2)
APP_BUILD_DIR="$MY_PROJECTS_PATH/$WORKFLOW/$project_name/build_dir.$FDEV_NAME/"

#check for build directory
if ! [ -d "$APP_BUILD_DIR" ]; then
    echo "You must build your project first! Please, use sgutil build coyote"
    echo ""
    exit
fi

#change directory
cd $APP_BUILD_DIR

#prgramming local server
echo "Programming local server ${bold}$hostname...${normal}"
#bitstream and driver
$CLI_PATH/sgutil program vivado --device $device_index -b $BIT_NAME --driver $DRIVER_NAME
#get permissions on N_REGIONS
$CLI_PATH/program/get_N_REGIONS $DIR

#programming remote servers (if applies)
if [ "$deploy_option" -eq 1 ]; then 
    #convert string to array
    IFS=" " read -ra servers_family_list_array <<< "$servers_family_list"
    for i in "${servers_family_list_array[@]}"; do
        #remote servers
        echo ""
        echo "Programming remote server ${bold}$i...${normal}"
        echo ""
        #remotely program bitstream, driver, and run get_N_REGIONS
        ssh -t $USER@$i "cd $APP_BUILD_DIR ; $CLI_PATH/program/vivado --device $device_index -b $BIT_NAME --driver $DRIVER_NAME ; $CLI_PATH/program/get_N_REGIONS $DIR"
    done
fi

echo ""