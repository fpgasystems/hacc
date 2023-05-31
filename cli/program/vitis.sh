#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
HACC_PATH="/opt/hacc"
DEVICES_LIST="$HACC_PATH/devices_reconfigurable"
WORKFLOW="vitis"
TARGET="hw"

#get number of fpga and acap devices present
MAX_DEVICES=$(grep -E "fpga|acap" $DEVICES_LIST | wc -l)

#get username
username=$USER

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#inputs
read -a flags <<< "$@"

#check if workflow exists
if ! [ -d "/home/$username/my_projects/vitis/" ]; then
    echo ""
    echo "You must create build your project first! Please, use sgutil build vitis"
    echo ""
    exit
fi

#check on multiple Xilinx devices
multiple_devices=$($CLI_PATH/common/get_multiple_devices $DEVICES_LIST)

#check on flags
project_found=""
project_name=""
device_found=""
device_index=""
if [ "$flags" = "" ]; then
    #header (1/2)
    echo ""
    echo "${bold}sgutil program vitis${normal}"
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
    #deployment_dialog
    echo ""
    result=$($CLI_PATH/common/get_servers $CLI_PATH $hostname)
    servers_family_list=$(echo "$result" | sed -n '1p' | sed -n '1p')
    servers_family_list_string=$(echo "$result" | sed -n '2p' | sed -n '1p')
    echo ""
    if [ -n "$servers_family_list_string" ]; then
        echo "${bold}Please, choose your deployment servers:${normal}"
        echo ""
        echo "0) $hostname"
        echo "1) $hostname, $servers_family_list_string"
        while true; do
            read -p "" deploy_option
            case $deploy_option in
                "0") 
                    servers_family_list=()
                    break
                    ;;
                "1") 
                    break
                    ;;
            esac
        done
        echo ""
    fi
else
    #project_dialog_check
    result="$("$CLI_PATH/common/project_dialog_check" "${flags[@]}")"
    project_found=$(echo "$result" | sed -n '1p')
    project_name=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if ([ "$project_found" = "1" ] && [ "$project_name" = "" ]); then 
        $CLI_PATH/sgutil program vitis -h
        exit
    fi
    #device_dialog_check
    result="$("$CLI_PATH/common/device_dialog_check" "${flags[@]}")"
    device_found=$(echo "$result" | sed -n '1p')
    device_index=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if ([ "$device_found" = "1" ] && [ "$device_index" = "" ]) || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 1 ))) || ([ "$device_found" = "1" ] && ([[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 1 ]])); then
        $CLI_PATH/sgutil program vitis -h
        exit
    fi
    #deployment_dialog_check
    result="$("$CLI_PATH/common/deployment_dialog_check" "${flags[@]}")"
    remote_option_found=$(echo "$result" | sed -n '1p')
    remote_option=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if [ "$remote_option_found" = "1" ] && { [ "$remote_option" -ne 0 ] && [ "$remote_option" -ne 1 ]; }; then #if [ "$remote_option_found" = "1" ] && [ -n "$remote_option" ]; then 
        $CLI_PATH/sgutil program vitis -h
        exit
    fi
    #header (2/2)
    echo ""
    echo "${bold}sgutil program vitis${normal}"
    echo ""
    #project_dialog (forgotten mandatory 1)
    if [[ $project_found = "0" ]]; then
        #echo ""
        echo "${bold}Please, choose your $WORKFLOW project:${normal}"
        echo ""
        result=$($CLI_PATH/common/project_dialog $username $WORKFLOW)
        project_found=$(echo "$result" | sed -n '1p')
        project_name=$(echo "$result" | sed -n '2p')
    fi
    #device_dialog (forgotten mandatory 2)
    if [[ $multiple_devices = "0" ]]; then
        device_found="1"
        device_index="1"
    elif [[ $device_found = "0" ]]; then
        #echo ""
        echo "${bold}Please, choose your device:${normal}"
        echo ""
        result=$($CLI_PATH/common/device_dialog $CLI_PATH $MAX_DEVICES $multiple_devices)
        device_found=$(echo "$result" | sed -n '1p')
        device_index=$(echo "$result" | sed -n '2p')
    fi
    #deployment_dialog (forgotten mandatory 3)
    if [ "$remote_option_found" = "0" ]; then
        #servers_family_list=()
        #echo ""
        result=$($CLI_PATH/common/get_servers $CLI_PATH $hostname)
        servers_family_list=$(echo "$result" | sed -n '1p' | sed -n '1p')
        servers_family_list_string=$(echo "$result" | sed -n '2p' | sed -n '1p')
        echo ""
        if [ -n "$servers_family_list_string" ]; then
            echo "${bold}Please, choose your deployment servers:${normal}"
            echo ""
            echo "0) $hostname"
            echo "1) $hostname, $servers_family_list_string"
            while true; do
                read -p "" deploy_option
                case $deploy_option in
                    "0") 
                        servers_family_list=()
                        break
                        ;;
                    "1") 
                        break
                        ;;
                esac
            done
            echo ""
        fi
    fi
fi

#define directories (1)
DIR="/home/$username/my_projects/vitis/$project_name"

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
APP_BUILD_DIR="/home/$username/my_projects/vitis/$project_name/build_dir.$TARGET.$platform"

#check for build directory
if ! [ -d "$APP_BUILD_DIR" ]; then
    echo ""
    echo "You must build your project first! Please, use sgutil build vitis (target = hw)"
    echo ""
    exit
fi

##get booked machines
#echo ""
#result=$($CLI_PATH/common/get_servers $CLI_PATH $hostname)
#servers_family_list=$(echo "$result" | sed -n '1p' | sed -n '1p')
#servers_family_list_string=$(echo "$result" | sed -n '2p' | sed -n '1p')
#echo ""

##deployment dialog
#if [ -n "$servers_family_list_string" ]; then
#    echo "${bold}Please, choose your deployment servers:${normal}"
#    echo ""
#    echo "1) $hostname"
#    echo "2) $hostname, $servers_family_list_string"
#    while true; do
#	    read -p "" deploy_option
#        case $deploy_option in
#            "1") 
#                servers_family_list=()
#                all_servers="0";
#                break
#                ;;
#            "2") 
#                all_servers="1"
#                break
#                ;;
#        esac
#    done
#    echo ""
#fi

#get xclbin
cd $APP_BUILD_DIR
xclbin=$(echo *.xclbin | awk '{print $NF}')

#get BDF (i.e., Bus:Device.Function) 
upstream_port=$($CLI_PATH/get/get_fpga_device_param $device_index upstream_port)
bdf="${upstream_port%?}1"

#programming local server
echo "Programming local server ${bold}$hostname...${normal}"
#revert to xrt first if FPGA is already in baremetal
sudo $CLI_PATH/program/revert -d $device_index
#reset device (we delete any xclbin)
/opt/xilinx/xrt/bin/xbutil reset --device $bdf --force
#program xclbin
/opt/xilinx/xrt/bin/xbutil program --device $bdf -u $xclbin

#programming remote servers (if applies)
for i in "${servers_family_list[@]}"
do
    #remote servers
    echo ""
    echo "Programming remote server ${bold}$i...${normal}"
    echo ""

    #remotely revert to xrt, reset device (we delete any xclbin) and program xclbin
    ssh -t $username@$i "sudo $CLI_PATH/program/revert ; /opt/xilinx/xrt/bin/xbutil reset --device $bdf --force ; /opt/xilinx/xrt/bin/xbutil program --device $bdf -u $APP_BUILD_DIR/$xclbin"
done

echo ""