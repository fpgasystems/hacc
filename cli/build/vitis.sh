#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#get username
username=$USER

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

# inputs
read -a flags <<< "$@"

echo ""
echo "${bold}sgutil build vitis${normal}"

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

#check for project directory
if ! [ -d "$DIR" ]; then
    echo ""
    echo "You must create your project first! Please, use sgutil new vitis"
    echo ""
    exit
fi

#select vivado release
if [ "$hostname" = "alveo-build-01" ]; then
    echo ""
    echo "${bold}Please, select your favourite Vivado release:${normal}" 
    echo ""
    PS3=""
    select release in 2022.1 2022.2
    do
        case $release in
            2022.1) break;;
            2022.2) break;;
        esac
    done
    #enable release
    eval "source xrt_select $release"
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
    config="config_001.hpp"
elif [[ $(ls -l | wc -l) = 3 ]]; then
    #config_000 and config_001 exist
    cp -fr $DIR/configs/config_001.hpp $DIR/configs/config_000.hpp
    config="config_001.hpp"
    echo ""
elif [[ $(ls -l | wc -l) > 3 ]]; then
    cd $DIR/configs/
    configs=( "config_"*.hpp )
    echo ""
    echo "${bold}Please, choose your configuration:${normal}"
    echo ""
    PS3=""
    select config in "${configs[@]:1}"; do # with :1 we avoid config_000.hpp :${#configs[@]}-2
        if [[ -z $config ]]; then
            echo "" >&/dev/null
        else
            break
        fi
    done
    # copy selected config as config_000.hpp
    cp -fr $DIR/configs/$config $DIR/configs/config_000.hpp
    echo ""
fi

echo "${bold}Please, choose binary's compilation target:${normal}"
echo ""
PS3=""
select target in sw_emu hw_emu hw
do
    case $target in
        sw_emu) break;;
        hw_emu) break;;
        hw) break;;
    esac
done

#sgutil get serial only when we have one FPGA and not serial_found
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $serial_found = "0" ]]; then
    serial_number=$(sgutil get serial | cut -d "=" -f2)
fi

# serial to platform
cd /opt/xilinx/platforms
if [ "$hostname" = "alveo-build-01" ]; then
    platforms=( "xilinx_"* )
    echo ""
    echo "${bold}Please, choose the device (or platform):${normal}" 
    echo ""
    PS3=""
    select platform in "${platforms[@]}"; do 
        if [[ -z $platform ]]; then
            echo "" >&/dev/null
        else
            break
        fi
    done
else
    n=$(ls -l | grep -c ^d)
    if [ $((n + 0)) -eq  1 ]; then
        platform=$(echo *)
    fi
fi

#define directories (2)
APP_BUILD_DIR="/home/$username/my_projects/vitis/$project_name/build_dir.$target.$platform"

echo ""
echo "${bold}Changing directory:${normal}"
echo ""
echo "cd $DIR"
echo ""
cd $DIR

#compilation
if ! [ -d "$APP_BUILD_DIR" ]; then
    # APP_BUILD_DIR does not exist
    export CPATH="/usr/include/x86_64-linux-gnu" #https://support.xilinx.com/s/article/Fatal-error-sys-cdefs-h-No-such-file-or-directory?language=en_US
    echo "${bold}PL kernel compilation and linking: generating .xo and .xclbin:${normal}"
    echo ""
    echo "make all TARGET=$target PLATFORM=$platform" 
    echo ""
    eval "make all TARGET=$target PLATFORM=$platform"
    echo ""        
else
    echo "${bold}PL kernel compilation and linking: generating .xo and .xclbin:${normal}"
    echo ""
    echo "make all TARGET=$target PLATFORM=$platform" 
    echo ""
    echo "$APP_BUILD_DIR already exists!"
    echo ""
fi