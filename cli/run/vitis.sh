#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#get username
username=$USER

# inputs
read -a flags <<< "$@"

echo ""
echo "${bold}sgutil run vitis${normal}"

#check if workflow exists
if ! [ -d "/home/$username/my_projects/vitis/" ]; then
    echo ""
    echo "You must build and/or program (target = hw) your project/device first! Please, use sgutil build/program vitis"
    echo ""
    exit
fi

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

#create or select a configuration
#cd $DIR/configs/
#if [[ $(ls -l | wc -l) = 2 ]]; then
#    #only config_000
#    echo ""
#    echo "You must build your project first! Please, use sgutil build vitis"
#    echo ""
#    exit
#elif [[ $(ls -l | wc -l) = 4 ]]; then
#    #config_000, config_shell and config_001 exist
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

echo ""
echo "${bold}Please, choose binary's execution target:${normal}"
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
n=$(ls -l | grep -c ^d)
if [ $((n + 0)) -eq  1 ]; then
    platform=$(echo *)
fi

#define directories (2)
APP_BUILD_DIR="/home/$username/my_projects/vitis/$project_name/build_dir.$target.$platform"

#check for build directory
if ! [ -d "$APP_BUILD_DIR" ]; then
    echo ""
    echo "You must build your project first! Please, use sgutil build vitis"
    echo ""
    exit
fi

#revert to xrt first if FPGA is already in baremetal (this is needed also for sw_emu and hw_emu, i.e. when we do not use sgutil program vitis)
sudo /opt/cli/program/revert

#change directory
echo ""
echo "${bold}Changing directory:${normal}"
echo ""
echo "cd $DIR"
echo ""
#cd $DIR

#display configuration
cd $DIR/configs/
config_id=$(ls *.active)
config_id="${config_id%%.*}"

echo "${bold}You are running $config_id:${normal}"
echo ""
cat $DIR/configs/config_000.hpp
echo ""

#execution
cd $DIR
echo "${bold}Running accelerated application:${normal}"
echo ""
echo "make run TARGET=$target PLATFORM=$platform" 
echo ""
eval "make run TARGET=$target PLATFORM=$platform"
echo ""

# This is equivalent to do ./$project_name path_to_target_xclbin, i.e.:
#   ./test_6 ./build_dir.sw_emu.xilinx_u55c_gen3x16_xdma_3_202210_1/vadd.xclbin