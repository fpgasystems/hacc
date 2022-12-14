#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#echo ""
#echo "${bold}iperf${normal}"
#echo ""

# constants
BIT_NAME="cyt_top.bit"
DRIVER_NAME="coyote_drv.ko"

# get hostname
#url="${HOSTNAME}"
#hostname="${url%%.*}"

#get username
username=$USER

#echo "This will program Coyote"
#exit

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

    #echo $BIT_PATH
    #echo $DRIVER_PATH

    #sgutil program vivado -b /mnt/scratch/runshi/coyote_perf_fpga/cyt_top.bit -d /mnt/scratch/runshi/coyote_perf_fpga/coyote_drv.ko
    
    # bitstream
    sgutil program vivado -b $BIT_PATH$BIT_NAME #-d $DRIVER_PATH$DRIVER_NAME

    #driver (we first need to copy it as it is not working from the /home/ folder)
    cp -f $DRIVER_PATH$DRIVER_NAME /local/home/$username/$DRIVER_NAME #cp -f /home/jmoyapaya/my_projects/coyote/U55C_01_02/driver/coyote_drv.ko /local/home/jmoyapaya/
    sgutil program vivado -d /local/home/$username/$DRIVER_NAME
fi

# --fpga to device_name and serial_number

#BIT_PATH="/home/$username/my_projects/coyote/$project_name/hw/build/bitstreams/cyt_top.bit"
#DRIVER_PATH="/home/$username/my_projects/coyote/$project_name/driver/coyote_drv.ko"

#echo $BIT_PATH
#echo $DRIVER_PATH

#echo "Arrived here"

#sudo /opt/cli/program/vivado -b $BIT_PATH -d $DRIVER_PATH
#sudo /opt/cli/sgutil program vivado -b $BIT_PATH -d $DRIVER_PATH

#/opt/cli/sgutil program vivado -b $BIT_PATH -d $DRIVER_PATH

#sudo bash -c "/opt/cli/sgutil program vivado -b $BIT_PATH -d $DRIVER_PATH"

#sgutil program vivado -b /mnt/scratch/runshi/coyote_perf_fpga/cyt_top.bit -d /mnt/scratch/runshi/coyote_perf_fpga/coyote_drv.ko