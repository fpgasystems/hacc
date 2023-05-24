#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_WORKDIR="/opt/cli"
DATABASE="/opt/hacc/devices"
WORKFLOW="vitis"
TARGET="hw"

#configuration parameters
MAX_DEVICES=$($CLI_WORKDIR/common/get_MAX_DEVICES)

#get username
username=$USER

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

# inputs
read -a flags <<< "$@"

echo ""
echo "${bold}sgutil program vitis${normal}"

#check if workflow exists
if ! [ -d "/home/$username/my_projects/vitis/" ]; then
    echo ""
    echo "You must create build your project first! Please, use sgutil build vitis"
    echo ""
    exit
fi

#check on multiple Xilinx devices
multiple_devices=$($CLI_WORKDIR/common/get_multiple_devices $DATABASE)

#check on flags (before: flags cannot be empty)
project_found=""
project_name=""
device_found=""
device_index=""
if [ "$flags" = "" ]; then
    #project
    echo ""
    echo "${bold}Please, choose your $WORKFLOW project:${normal}"
    echo ""
    result=$($CLI_WORKDIR/common/project_dialog $username $WORKFLOW)
    project_found=$(echo "$result" | sed -n '1p')
    project_name=$(echo "$result" | sed -n '2p')
    #device
    echo ""
    echo "${bold}Please, choose your device:${normal}"
    echo ""
    result=$($CLI_WORKDIR/common/device_dialog $CLI_WORKDIR $MAX_DEVICES $multiple_devices)
    device_found=$(echo "$result" | sed -n '1p')
    device_index=$(echo "$result" | sed -n '2p')
else
    #find flags and values
    #for (( i=0; i<${#flags[@]}; i++ ))
    #do
    #    if [[ " ${flags[$i]} " =~ " -p " ]] || [[ " ${flags[$i]} " =~ " --project " ]]; then # flags[i] is -p or --project
    #        project_found="1"
    #        project_idx=$(($i+1))
    #        project_name=${flags[$project_idx]}
    #    fi
    #done

    echo $flags
    echo "${flags[@]}"

    result="$("$CLI_WORKDIR/common/project_dialog_check" "${flags[@]}")"
    project_found=$(echo "$result" | sed -n '1p')
    project_idx=$(echo "$result" | sed -n '2p')
    project_name=$(echo "$result" | sed -n '3p')

    echo $project_found
    echo $project_idx
    echo $project_name


    for (( i=0; i<${#flags[@]}; i++ ))
    do
        if [[ " ${flags[$i]} " =~ " -d " ]] || [[ " ${flags[$i]} " =~ " --device " ]]; then # flags[i] is -d or --device
            device_found="1"
            device_idx=$(($i+1))
            device_index=${flags[$device_idx]}
        fi  
    done
    #forbidden combinations
    if [[ $project_found = "0" ]] || ([ "$project_found" = "1" ] && [ "$project_name" = "" ]) || ([ $project_found = "0" ] && [ $device_found = "1" ]) || ([ "$device_found" = "1" ] && [ "$device_index" = "" ]); then
        $CLI_WORKDIR/sgutil program vitis -h
        exit
    fi
    if [[ $device_found = "0" ]] || [[ $device_index = "" ]] || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 0 ))); then
        $CLI_WORKDIR/sgutil program vitis -h
        exit
    fi
fi

#device_index should be between {1 ... MAX_DEVICES}
#MAX_DEVICES=$(($MAX_DEVICES-1))
if [[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 1 ]]; then
    $CLI_WORKDIR/sgutil program vitis -h
    exit
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
platform=$($CLI_WORKDIR/get/get_device_param $device_index platform)

#define directories (2)
APP_BUILD_DIR="/home/$username/my_projects/vitis/$project_name/build_dir.$TARGET.$platform"

#check for build directory
if ! [ -d "$APP_BUILD_DIR" ]; then
    echo ""
    echo "You must build your project first! Please, use sgutil build vitis (target = hw)"
    echo ""
    exit
fi

#get booked machines
echo ""
servers=$(sudo $CLI_WORKDIR/common/get_booking_system_servers_list | tail -n +2)
echo ""

#convert string to an array
servers=($servers)

#we only show likely servers (i.e., alveo-u55c)
server_family="${hostname%???}"

#build servers_family_list
servers_family_list=()
for i in "${servers[@]}"
do
    if [[ $i == $server_family* ]] && [[ $i != $hostname ]]; then
        #append the matching element to the array
        servers_family_list+=("$i") 
    fi
done

#convert to string and remove the leading delimiter (:2)
servers_family_list_string=$(printf ", %s" "${servers_family_list[@]}")
servers_family_list_string=${servers_family_list_string:2}

#deployment dialog
if [ -n "$servers_family_list_string" ]; then
    echo "${bold}Where do you want to deploy your binary?${normal}"
    echo ""
    echo "    1) Only this server ($hostname)"
    echo "    2) All servers I have booked ($hostname, $servers_family_list_string)"
    while true; do
	    read -p "" deploy_option
        case $deploy_option in
            "1") 
                servers_family_list=()
                all_servers="0";
                break
                ;;
            "2") 
                all_servers="1"
                break
                ;;
        esac
    done
    echo ""
fi

#get xclbin
cd $APP_BUILD_DIR
xclbin=$(echo *.xclbin | awk '{print $NF}')

#get BDF (i.e., Bus:Device.Function) 
upstream_port=$($CLI_WORKDIR/get/get_device_param $device_index upstream_port)
bdf="${upstream_port%?}1"

#programming local server
echo "Programming local server ${bold}$hostname...${normal}"
#revert to xrt first if FPGA is already in baremetal
sudo $CLI_WORKDIR/program/revert -d $device_index
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
    ssh -t $username@$i "sudo $CLI_WORKDIR/program/revert ; /opt/xilinx/xrt/bin/xbutil reset --device $bdf --force ; /opt/xilinx/xrt/bin/xbutil program --device $bdf -u $APP_BUILD_DIR/$xclbin"
done

echo ""