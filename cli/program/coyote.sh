#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
HACC_PATH="/opt/hacc"
DEVICES_LIST="$HACC_PATH/devices_reconfigurable"
WORKFLOW="coyote"
BIT_NAME="cyt_top.bit"
DRIVER_NAME="coyote_drv.ko"

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

#check for vivado_developers
member=$($CLI_PATH/common/is_member $username vivado_developers)
if [ "$member" = "false" ]; then
    echo ""
    echo "Sorry, ${bold}$username!${normal} You are not granted to use this command."
    echo ""
    exit
fi

#check if workflow exists
if ! [ -d "/home/$username/my_projects/$WORKFLOW/" ]; then
    echo ""
    echo "You must build your project first! Please, use sgutil build coyote"
    echo ""
    exit
fi

#inputs
read -a flags <<< "$@"

#----------------------------------------------------------

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
    if [ "$project_found" = "1" ] && ([ "$project_name" = "" ] || [ ! -d "/home/$username/my_projects/$WORKFLOW/$project_name" ]); then 
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

echo $project_found
echo $project_name
echo $device_found
echo $device_index
echo $deploy_option

#exit

#-------------




echo ""
echo "${bold}sgutil program coyote${normal}"

##check on flags (before: flags cannot be empty)
#name_found="0"
#project_found="0"
##serial_found="0"
#if [ "$flags" = "" ]; then
#    #no flags: start dialog
#    cd /home/$username/my_projects/coyote/
#    projects=( *"/" )
#    #delete validate folders from projects
#    j=0
#    for i in "${projects[@]}"
#    do
#        if [[ $i =~ validate_* ]]; then
#            echo "" >&/dev/null
#        else
#            aux[j]=$i
#            j=$(($j + 1))
#        fi
#    done
#    echo ""
#    echo "${bold}Please, choose your project:${normal}"
#    echo ""
#    PS3=""
#    select project_name in "${aux[@]}"; do
#        if [[ -z $project_name ]]; then
#            echo "" >&/dev/null
#        else
#            project_found="1"
#            project_name=${project_name::-1} #we remove the last character, i.e. "/""
#            break
#        fi
#    done
#else
#    #find flags and values
#    for (( i=0; i<${#flags[@]}; i++ ))
#    do
#        if [[ " ${flags[$i]} " =~ " -n " ]] || [[ " ${flags[$i]} " =~ " --name " ]]; then 
#            name_found="1"
#            name_idx=$(($i+1))
#            device_name=${flags[$name_idx]}
#        fi
#        if [[ " ${flags[$i]} " =~ " -p " ]] || [[ " ${flags[$i]} " =~ " --project " ]]; then
#            project_found="1"
#            project_idx=$(($i+1))
#            project_name=${flags[$project_idx]}
#        fi
#    done
#    #forbidden combinations
#    if [[ $project_found = "0" ]] || ([ "$project_found" = "1" ] && [ "$project_name" = "" ]) || ([ $project_found = "0" ] && [ $name_found = "1" ]) || ([ "$name_found" = "1" ] && [ "$device_name" = "" ]); then
#        $CLI_PATH/sgutil build coyote -h
#        exit
#    fi
#fi

#define directories (1)
DIR="/home/$username/my_projects/$WORKFLOW/$project_name"

#check if project exists
if ! [ -d "$DIR" ]; then
    echo ""
    echo "$DIR is not a valid --project name!"
    echo ""
    exit
fi

#device_name to coyote string 
FDEV_NAME=$(echo $HOSTNAME | grep -oP '(?<=-).*?(?=-)')
if [ "$FDEV_NAME" = "u50d" ]; then
    FDEV_NAME="u50"
fi

#define directories (2)
APP_BUILD_DIR="/home/$username/my_projects/$WORKFLOW/$project_name/build_dir.$FDEV_NAME/" #$device_name

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
#$CLI_PATH/sgutil program vivado --device $device_index -b $APP_BUILD_DIR$BIT_NAME --driver $APP_BUILD_DIR$DRIVER_NAME
#$CLI_PATH/sgutil program vivado --device $device_index -b $APP_BUILD_DIR$BIT_NAME --driver $DRIVER_NAME
$CLI_PATH/sgutil program vivado --device $device_index -b $BIT_NAME --driver $DRIVER_NAME
#driver 
#$CLI_PATH/sgutil program vivado -d $APP_BUILD_DIR$DRIVER_NAME
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
        ssh -t $username@$i "$CLI_PATH/program/vivado --device $device_index -b $APP_BUILD_DIR$BIT_NAME -d $APP_BUILD_DIR$DRIVER_NAME ; $CLI_PATH/program/get_N_REGIONS $DIR"
    done
fi

echo ""