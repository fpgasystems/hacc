#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#get username
username=$USER

# inputs
read -a flags <<< "$@"

# flags cannot be empty
if [ "$flags" = "" ]; then
    /opt/cli/sgutil program vitis -h
    exit
fi

project_found="0"
serial_found="0"
for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " -p " ]] || [[ " ${flags[$i]} " =~ " --project " ]]; then # flags[i] is -p or --project
        project_found="1"
        project_idx=$(($i+1))
        project_name=${flags[$project_idx]}
    fi
    if [[ " ${flags[$i]} " =~ " -s " ]] || [[ " ${flags[$i]} " =~ " --serial " ]]; then # =====> will be --fpga 0
        serial_found="1"
        serial_idx=$(($i+1))
        serial_number=${flags[$serial_idx]}
    fi
done

# mandatory flags (-p and -t must be used)
use_help="0"
if [[ $project_found = "0" ]]; then
    use_help="1"
fi

# forbiden combinations (serial_found and target_found only make sense with project_found = 1)
if [[ $project_found = "0" ]] && [[ $serial_found = "1" ]]; then
    use_help="1"
fi

#print help
if [[ $use_help = "1" ]]; then
    /opt/cli/sgutil program vitis -h
    exit
fi

# verify directory
DIR="/home/$username/my_projects/vitis/$project_name"
if ! [ -d "$DIR" ]; then
    echo ""
    echo "$DIR is not a valid --project name!"
    echo ""
    exit
fi

#sgutil get serial only when we have one FPGA and not serial_found
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $serial_found = "0" ]]; then
    #serial_number=$(sgutil get serial | cut -d "=" -f2)
    serial_number="--device"
fi

# serial to platform
cd /opt/xilinx/platforms
n=$(ls -l | grep -c ^d)
if [ $((n + 0)) -eq  1 ]; then
    platform=$(echo *)
fi

#change directory
if ! [ -d "$DIR" ]; then
    echo ""
    echo "$DIR not found!"
    echo ""
    exit
else
    echo ""
    echo "${bold}Changing directory:${normal}"
    echo ""
    echo "cd $DIR"
    echo ""
    cd $DIR
fi

# verify hw target 
target="hw"
DIR="/home/$username/my_projects/vitis/$project_name/build_dir.$target.$platform"
if ! [ -d "$DIR" ]; then
    # project_name does not exist
    echo "Please, generate your hw binary first with sgutil build vitis."
    echo ""
    exit
fi

# get xclbin
cd $DIR
xclbin=$(echo *.xclbin | awk '{print $NF}')

# program xclbin
/opt/xilinx/xrt/bin/xbutil program $serial_number -u $xclbin

echo ""