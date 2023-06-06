#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
BIT_NAME="cyt_top.bit"
DRIVER_NAME="coyote_drv.ko"

#get username
username=$USER

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#inputs
read -a flags <<< "$@"

echo ""
echo "${bold}sgutil program coyote${normal}"

#check for vivado_developers
member=$($CLI_PATH/common/is_member $username vivado_developers)
if [ "$member" = "false" ]; then
    echo ""
    echo "Sorry, ${bold}$username!${normal} You are not granted to use this command."
    echo ""
    exit
fi

#check if workflow exists
if ! [ -d "/home/$username/my_projects/coyote/" ]; then
    echo ""
    echo "You must build your project first! Please, use sgutil build coyote"
    echo ""
    exit
fi

#check on flags (before: flags cannot be empty)
name_found="0"
project_found="0"
#serial_found="0"
if [ "$flags" = "" ]; then
    #no flags: start dialog
    cd /home/$username/my_projects/coyote/
    projects=( *"/" )
    #delete validate folders from projects
    j=0
    for i in "${projects[@]}"
    do
        if [[ $i =~ validate_* ]]; then
            echo "" >&/dev/null
        else
            aux[j]=$i
            j=$(($j + 1))
        fi
    done
    echo ""
    echo "${bold}Please, choose your project:${normal}"
    echo ""
    PS3=""
    select project_name in "${aux[@]}"; do
        if [[ -z $project_name ]]; then
            echo "" >&/dev/null
        else
            project_found="1"
            project_name=${project_name::-1} #we remove the last character, i.e. "/""
            break
        fi
    done
else
    #find flags and values
    for (( i=0; i<${#flags[@]}; i++ ))
    do
        if [[ " ${flags[$i]} " =~ " -n " ]] || [[ " ${flags[$i]} " =~ " --name " ]]; then 
            name_found="1"
            name_idx=$(($i+1))
            device_name=${flags[$name_idx]}
        fi
        if [[ " ${flags[$i]} " =~ " -p " ]] || [[ " ${flags[$i]} " =~ " --project " ]]; then
            project_found="1"
            project_idx=$(($i+1))
            project_name=${flags[$project_idx]}
        fi
    done
    #forbidden combinations
    if [[ $project_found = "0" ]] || ([ "$project_found" = "1" ] && [ "$project_name" = "" ]) || ([ $project_found = "0" ] && [ $name_found = "1" ]) || ([ "$name_found" = "1" ] && [ "$device_name" = "" ]); then
        $CLI_PATH/sgutil build coyote -h
        exit
    fi
fi

#define directories (1)
DIR="/home/$username/my_projects/coyote/$project_name"

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
APP_BUILD_DIR="/home/$username/my_projects/coyote/$project_name/build_dir.$FDEV_NAME/" #$device_name

#check for build directory
if ! [ -d "$APP_BUILD_DIR" ]; then
    echo "You must build your project first! Please, use sgutil build coyote"
    echo ""
    exit
fi

#get booked machines
echo ""
servers=$(sudo $CLI_PATH/common/get_booking_system_servers_list | tail -n +2)
echo ""

#convert string to an array
servers=($servers)

#we only show likely servers (hostname is alveo-u55c-01 and we remove the las three characters, i.e., alveo-u55c)
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

#prgramming local server
echo "Programming local server ${bold}$hostname...${normal}"
#sgutil get device if there is only one FPGA and not name_found
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $name_found = "0" ]]; then
    #device_name=$(sgutil get device | cut -d "=" -f2)
    device_name=$($CLI_PATH/get/device | awk -F': ' '{print $2}' | grep -v '^$')
fi
#bitstream
$CLI_PATH/sgutil program vivado -b $APP_BUILD_DIR$BIT_NAME
#driver 
$CLI_PATH/sgutil program vivado -d $APP_BUILD_DIR$DRIVER_NAME

#get permissions on N_REGIONS
$CLI_PATH/program/get_N_REGIONS $DIR

#programming remote servers (if applies)
for i in "${servers_family_list[@]}"
do
    #remote servers
    echo ""
    echo "Programming remote server ${bold}$i...${normal}"
    echo ""

    #sgutil get device if there is only one FPGA and not name_found (we assume this for now)
    if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $name_found = "0" ]]; then
        device_name=$($CLI_PATH/sgutil get device | awk -F': ' '{print $2}' | grep -v '^$')
    fi

    #remotely program bitstream, driver, and run get_N_REGIONS
    ssh -t $username@$i "$CLI_PATH/program/vivado -b $APP_BUILD_DIR$BIT_NAME ; $CLI_PATH/program/vivado -d $APP_BUILD_DIR$DRIVER_NAME ; $CLI_PATH/program/get_N_REGIONS $DIR"

done

echo ""
