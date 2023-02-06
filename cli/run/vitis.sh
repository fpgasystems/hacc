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

# inputs
read -a flags <<< "$@"

# flags cannot be empty
if [ "$flags" = "" ]; then
    /opt/cli/sgutil run vitis -h
    exit
fi

project_found="0"
serial_found="0"
#target_found="0"
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
    #if [[ " ${flags[$i]} " =~ " -t " ]] || [[ " ${flags[$i]} " =~ " --target " ]]; then 
    #    target_found="1"
    #    target_idx=$(($i+1))
    #    target=${flags[$target_idx]}
    #fi
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
    /opt/cli/sgutil run vitis -h
    exit
fi

# when used, project_name or serial_found cannot be empty
if [ "$project_found" = "1" ] && [ "$project_name" = "" ]; then
    /opt/cli/sgutil run vitis -h
    exit
fi

if [ "$serial_found" = "1" ] && [ "$serial_number" = "" ]; then
    /opt/cli/sgutil run vitis -h
    exit
fi

DIR="/home/$username/my_projects/vitis/$project_name"
if ! [ -d "$DIR" ]; then
    echo ""
    echo "$DIR is not a valid --project name!"
    echo ""
    exit
fi

echo ""
echo "${bold}sgutil run vitis${normal}"

#create or select a configuration
cd $DIR/configs/
if [[ $(ls -l | wc -l) = 2 ]]; then
    #only config_000 exists and we create config_001
    #cp -fr $DIR/configs/config_001.hpp $DIR/configs/config_000.hpp
    #cd $DIR
    #./create_config
    #cp -fr $DIR/configs/config_001.hpp $DIR/configs/config_000.hpp

    echo "Please run build first."


elif [[ $(ls -l | wc -l) = 3 ]]; then
    #config_000 and config_001 exist
    cp -fr $DIR/configs/config_001.hpp $DIR/configs/config_000.hpp
elif [[ $(ls -l | wc -l) > 3 ]]; then
    cd $DIR/configs/
    configs=( "config_"*.hpp )
    echo ""
    echo "${bold}Please, choose your configuration:${normal}"
    echo ""
    PS3=""
    select config in "${configs[@]:1}"; do # with :1 we avoid config_000.hpp
        if [[ -z $config ]]; then
            echo "" >&/dev/null
        else
            break
        fi
    done
    # copy selected config as config_000.hpp
    cp -fr $DIR/configs/$config $DIR/configs/config_000.hpp
fi

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
#else
    # Multiple platforms are on the server but we need to pick 
    # the one matching the serial_number
fi

#echo $serial_number
#echo $platform

#change directory
#echo ""
#echo "${bold}Changing directory:${normal}"
#echo ""
#echo "cd /home/$username/my_projects/vitis/$project_name"
#echo ""
#cd /home/$username/my_projects/vitis/$project_name
DIR="/home/$username/my_projects/vitis/$project_name"
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

#compilation
#export CPATH="/usr/include/x86_64-linux-gnu" #https://support.xilinx.com/s/article/Fatal-error-sys-cdefs-h-No-such-file-or-directory?language=en_US

#echo "${bold}PL kernel compilation and linking: generating .xo and .xclbin:${normal}"
#echo ""
#echo "make all TARGET=$target PLATFORM=$platform" 
#echo ""
#eval "make all TARGET=$target PLATFORM=$platform"
#echo ""

DIR="/home/$username/my_projects/vitis/$project_name/build_dir.$target.$platform"
if ! [ -d "$DIR" ]; then
    # project_name does not exist
    echo "Please, generate your binary first with sgutil build vitis."
    echo ""
    exit
fi

#execution
echo "${bold}Running accelerated application:${normal}"
echo ""
echo "make run TARGET=$target PLATFORM=$platform" 
echo ""
eval "make run TARGET=$target PLATFORM=$platform"
echo ""

# This is equivalent to do ./$project_name path_to_target_xclbin, i.e.:
#   ./test_6 ./build_dir.sw_emu.xilinx_u55c_gen3x16_xdma_3_202210_1/vadd.xclbin