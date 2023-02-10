#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# constants
BIT_NAME="cyt_top.bit"
DRIVER_NAME="coyote_drv.ko"

#get username
username=$USER

# inputs
read -a flags <<< "$@"

# flags cannot be empty
if [ "$flags" = "" ]; then
    /opt/cli/sgutil program coyote -h
    exit
fi

name_found="0"
project_found="0"
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

# mandatory flags (-p must be used)
use_help="0"
if [[ $project_found = "0" ]]; then
    /opt/cli/sgutil program coyote -h
    exit
fi

# when used, device_name or project_name cannot be empty
if [ "$name_found" = "1" ] && [ "$device_name" = "" ]; then
    /opt/cli/sgutil program coyote -h
    exit
fi

if [ "$project_found" = "1" ] && [ "$project_name" = "" ]; then
    /opt/cli/sgutil program coyote -h
    exit
fi

#sgutil get device if there is only one FPGA and not name_found
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $name_found = "0" ]]; then
    device_name=$(sgutil get device | cut -d "=" -f2)
fi

#define directories
DIR="/home/$username/my_projects/coyote/$project_name"
APP_BUILD_DIR="/home/$username/my_projects/coyote/$project_name/build_dir.$device_name/"

# check if project exists
if ! [ -d "$DIR" ]; then
    echo ""
    echo "$DIR is not a valid --project name!"
    echo ""
    exit
fi

# check if bitstream exists
#DIR="/home/$username/my_projects/coyote/$project_name/hw/build/bitstreams"
if ! [ -d "$APP_BUILD_DIR" ]; then
    echo ""
    echo "Please, generate your bitstream first with sgutil build coyote."
    echo ""
    exit
else
    #BIT_PATH="/home/$username/my_projects/coyote/$project_name/hw/build/bitstreams/" #$BIT_NAME
    #DRIVER_PATH="/home/$username/my_projects/coyote/$project_name/driver/" #$DRIVER_NAME
    #APP_BUILD_DIR="/home/$username/my_projects/coyote/$project_name/build_dir.$device_name/"

    # revert to xrt first if FPGA is already in baremetal
    if [[ $(lspci | grep Xilinx | wc -l) = 1 ]]; then
        /opt/cli/program/revert
    fi
    
    # bitstream
    sgutil program vivado -b $APP_BUILD_DIR$BIT_NAME #-d $DRIVER_PATH$DRIVER_NAME

    #driver (we first need to copy it as it is not working from the /home/ folder)
    #cp -f $APP_BUILD_DIR$DRIVER_NAME /local/home/$username/$DRIVER_NAME
    #sgutil program vivado -d /local/home/$username/$DRIVER_NAME
    sgutil program vivado -d $APP_BUILD_DIR$DRIVER_NAME #/local/home/$username/$DRIVER_NAME

    # get fpga_chmod for the total of regions (0 is already assigned)
    #get N_REGIONS
    line=$(grep -n "N_REGIONS" $DIR/configs/config_shell.hpp)
    #find equal (=)
    idx=$(sed 's/ /\n/g' <<< "$line" | sed -n "/=/=")
    #get index
    value_idx=$(($idx+1))
    #get data
    N_REGIONS=$(echo $line | awk -v i=$value_idx '{ print $i }' | sed 's/;//' )
    #fpga_chmod
    #N_REGIONS=$(($N_REGIONS-1));
    for (( i = 0; i < $N_REGIONS; i++ )) # we remove it from program/vivado (driver)
    do 
        sudo /opt/cli/program/fpga_chmod $i
    done

fi