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

# check if project exists
DIR="/home/$username/my_projects/coyote/$project_name"
if ! [ -d "$DIR" ]; then
    echo ""
    echo "$DIR is not a valid --project name!"
    echo ""
    exit
fi

# check if bitstream exists
DIR="/home/$username/my_projects/coyote/$project_name/hw/build/bitstreams"
if ! [ -d "$DIR" ]; then
    echo ""
    echo "Please, generate your bitstream first with sgutil build coyote."
    echo ""
    exit
else
    BIT_PATH="/home/$username/my_projects/coyote/$project_name/hw/build/bitstreams/" #$BIT_NAME
    DRIVER_PATH="/home/$username/my_projects/coyote/$project_name/driver/" #$DRIVER_NAME
    
    # bitstream
    sgutil program vivado -b $BIT_PATH$BIT_NAME #-d $DRIVER_PATH$DRIVER_NAME

    #driver (we first need to copy it as it is not working from the /home/ folder)
    cp -f $DRIVER_PATH$DRIVER_NAME /local/home/$username/$DRIVER_NAME
    sgutil program vivado -d /local/home/$username/$DRIVER_NAME
fi