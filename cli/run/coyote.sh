#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#echo ""
#echo "${bold}iperf${normal}"
#echo ""

# constants
#CLI_WORKDIR="/opt/cli"

# get hostname
#url="${HOSTNAME}"
#hostname="${url%%.*}"

#get username
username=$USER

#echo "This will run Coyote"
#exit

# inputs
read -a flags <<< "$@"

# flags cannot be empty
if [ "$flags" = "" ]; then
    /opt/cli/sgutil run coyote -h
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
    /opt/cli/sgutil build coyote -h
    exit
fi

# when used, device_name or project_name cannot be empty
if [ "$name_found" = "1" ] && [ "$device_name" = "" ]; then
    /opt/cli/sgutil run coyote -h
    exit
fi

if [ "$project_found" = "1" ] && [ "$project_name" = "" ]; then
    /opt/cli/sgutil run coyote -h
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

#create or select a configuration
cd $DIR/configs/
if [[ $(ls -l | wc -l) = 2 ]]; then
    #only config_000 exists and we create config_001
    #we compile create_config (in case there were changes)
    cd $DIR/src
    g++ -std=c++17 create_config.cpp -o ../create_config >&/dev/null
    cd $DIR
    ./create_config
    cp -fr $DIR/configs/config_001.hpp $DIR/configs/config_000.hpp
elif [[ $(ls -l | wc -l) = 4 ]]; then
    #config_000, config_shell and config_001 exist
    cp -fr $DIR/configs/config_001.hpp $DIR/configs/config_000.hpp
    echo ""
elif [[ $(ls -l | wc -l) > 4 ]]; then
    cd $DIR/configs/
    configs=( "config_"*.hpp )
    echo ""
    echo "${bold}Please, choose your configuration:${normal}"
    echo ""
    PS3=""
    select config in "${configs[@]:1:${#configs[@]}-2}"; do # with :1 we avoid config_000.hpp and then config_shell.hpp
        if [[ -z $config ]]; then
            echo "" >&/dev/null
        else
            break
        fi
    done
    # copy selected config as config_000.hpp
    cp -fr $DIR/configs/$config $DIR/configs/config_000.hpp
fi

#sgutil get device if there is only one FPGA and not name_found ------------------> this will change with the fpga_idx concept
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $name_found = "0" ]]; then
    device_name=$(sgutil get device | cut -d "=" -f2)
fi

#define directories
DIR="/home/$username/my_projects/coyote/$project_name"
APP_BUILD_DIR="/home/$username/my_projects/coyote/$project_name/build_dir.$device_name/"

#change directory
#DIR="/home/$username/my_projects/coyote/$project_name"
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

    # this will change... we need to use $APP_DIR where we should find a file we can properly execute
    #APP_DIR="/home/$username/my_projects/coyote/$project_name/sw/build"

    # workaround working if we do sgutil program coyote -p U55C_01_02 first
    #cd /mnt/scratch/runshi/coyote_perf_fpga
    #./perf_fpga
    echo "${bold}sgutil run coyote${normal}"
    
    cd $APP_BUILD_DIR
    ./main

fi

echo ""