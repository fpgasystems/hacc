#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#get username
username=$USER

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#constants
TARGET="hw"

# inputs
read -a flags <<< "$@"

echo ""
echo "${bold}sgutil program vitis${normal}"

#check on flags (before: flags cannot be empty)
project_found="0"
serial_found="0"
if [ "$flags" = "" ]; then
    #no flags: start dialog
    cd /home/$username/my_projects/vitis/
    projects=( *"/" )
    #delete common from projects
    j=0
    for i in "${projects[@]}"
    do
        if [[ $i =~ "common/" ]]; then
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
        if [[ " ${flags[$i]} " =~ " -p " ]] || [[ " ${flags[$i]} " =~ " --project " ]]; then # flags[i] is -p or --project
            project_found="1"
            project_idx=$(($i+1))
            project_name=${flags[$project_idx]}
        fi
        if [[ " ${flags[$i]} " =~ " -s " ]] || [[ " ${flags[$i]} " =~ " --serial " ]]; then 
            serial_found="1"
            serial_idx=$(($i+1))
            serial_number=${flags[$serial_idx]}
        fi
    done
    #forbidden combinations
    if [[ $project_found = "0" ]] || ([ "$project_found" = "1" ] && [ "$project_name" = "" ]) || ([ $project_found = "0" ] && [ $serial_found = "1" ]) || ([ "$serial_found" = "1" ] && [ "$serial_number" = "" ]); then
        /opt/cli/sgutil build vitis -h
        exit
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

#create or select a configuration ===> for programming, configs (config_000) are irrelevant
#cd $DIR/configs/
#if [[ $(ls -l | wc -l) = 2 ]]; then
#    #only config_000 exists and we create config_001
#    echo ""
#    echo "You must build your project first! Please, use sgutil build vitis (target = hw)"
#    echo ""
#    exit
#elif [[ $(ls -l | wc -l) = 4 ]]; then
#    #config_000, config_kernel and config_001 exist
#    cp -fr $DIR/configs/config_001.hpp $DIR/configs/config_000.hpp
#    config="config_001.hpp"
#    echo ""
#elif [[ $(ls -l | wc -l) > 4 ]]; then
#    cd $DIR/configs/
#    configs=( "config_"*.hpp )
#    echo ""
#    echo "${bold}Please, choose your configuration:${normal}"
#    echo ""
#    PS3=""
#    select config in "${configs[@]:1:${#configs[@]}-2}"; do # with :1 we avoid config_000.hpp and then config_kernel.hpp
#        if [[ -z $config ]]; then
#            echo "" >&/dev/null
#        else
#            break
#        fi
#    done
#    # copy selected config as config_000.hpp
#    cp -fr $DIR/configs/$config $DIR/configs/config_000.hpp
#    echo ""
#fi

# serial to platform
cd /opt/xilinx/platforms
n=$(ls -l | grep -c ^d)
if [ $((n + 0)) -eq  1 ]; then
    platform=$(echo *)
fi

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
servers=$(sudo /opt/cli/common/get_booking_system_servers_list | tail -n +2)
echo ""

#convert string to an array
servers=($servers)

#we only show likely servers (i.e., alveo-u55c)
server_family=$(sgutil get device)
server_family="${server_family%%=*}"

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

#get xclbin
cd $APP_BUILD_DIR
xclbin=$(echo *.xclbin | awk '{print $NF}')

#prgramming local server
echo ""
echo "Programming local server ${bold}$hostname...${normal}"
#sgutil get serial only when we have one FPGA and not serial_found
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $serial_found = "0" ]]; then
    #serial_number=$(sgutil get serial | cut -d "=" -f2)
    serial_number="--device"
fi
#revert to xrt first if FPGA is already in baremetal
sudo /opt/cli/program/revert
#reset device (we delete any xclbin)
/opt/xilinx/xrt/bin/xbutil reset $serial_number --force
#program xclbin
/opt/xilinx/xrt/bin/xbutil program $serial_number -u $xclbin

#echo "Local xclbin: $xclbin"

#programming remote servers (if applies)
for i in "${servers_family_list[@]}"
do
    #remote servers
    echo ""
    echo "Programming remote server ${bold}$i...${normal}"
    echo ""

    #we assume this for now
    serial_number="--device"

    #remotely...
    #revert to xrt first if FPGA is already in baremetal (-t forces a pseudo-tty allocation)
    ssh -t $username@$i "sudo /opt/cli/program/revert"
    #reset device (we delete any xclbin) and program
    #ssh $username@$i "/opt/xilinx/xrt/bin/xbutil reset $serial_number --force"
    #program xclbin
    #ssh $username@$i "/opt/xilinx/xrt/bin/xbutil program $serial_number -u $APP_BUILD_DIR/$xclbin"

    #reset device (we delete any xclbin) and program xclbin
    ssh $username@$i "/opt/xilinx/xrt/bin/xbutil reset $serial_number --force ; /opt/xilinx/xrt/bin/xbutil program $serial_number -u $APP_BUILD_DIR/$xclbin"
done

##sgutil get serial only when we have one FPGA and not serial_found
#if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $serial_found = "0" ]]; then
#    #serial_number=$(sgutil get serial | cut -d "=" -f2)
#    serial_number="--device"
#fi

#revert to xrt first if FPGA is already in baremetal
#sudo /opt/cli/program/revert

#reset device (we delete any xclbin)
#/opt/xilinx/xrt/bin/xbutil reset $serial_number --force

# program xclbin
#/opt/xilinx/xrt/bin/xbutil program $serial_number -u $xclbin

echo ""