#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#echo "ES EL BUILD!"

#get username
username=$USER

# inputs
read -a flags <<< "$@"

# flags cannot be empty
if [ "$flags" = "" ]; then
    /opt/cli/sgutil build vitis -h
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
#if [[ $project_found = "1" ]] && [[ $target_found = "0" ]]; then 
#    use_help="1"
#fi

# forbiden combinations (serial_found and target_found only make sense with project_found = 1)
if [[ $project_found = "0" ]] && [[ $serial_found = "1" ]]; then
    use_help="1"
fi
#if [[ $project_found = "0" ]] && [[ $target_found = "1" ]]; then
#    use_help="1"
#fi

# check on target
#echo $target
#if [[ $target =~ "sw_emu" ]] || [[ $target =~ "hw_emu" ]] || [[ $target =~ "hw" ]]; then
#    echo "unexpected target"
#fi

#print help
if [[ $use_help = "1" ]]; then
    /opt/cli/sgutil build vitis -h
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
echo "${bold}sgutil build vitis${normal}"
echo ""
echo "Please, choose binary's compilation target:"
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

    #compilation
    BUILD_DIR="/home/$username/my_projects/vitis/$project_name/build_dir.$target.$platform" # build_dir.hw.xilinx_u55c_gen3x16_xdma_3_202210_1
    if ! [ -d "$BUILD_DIR" ]; then
        # BUILD_DIR does not exist
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
        echo "$BUILD_DIR already exists!"
        echo ""
    fi
fi

#compilation
#export CPATH="/usr/include/x86_64-linux-gnu" #https://support.xilinx.com/s/article/Fatal-error-sys-cdefs-h-No-such-file-or-directory?language=en_US

#echo "${bold}PL kernel compilation and linking: generating .xo and .xclbin:${normal}"
#echo ""
#echo "make all TARGET=$target PLATFORM=$platform" 
#echo ""
#eval "make all TARGET=$target PLATFORM=$platform"
#echo ""

#execution
#echo "${bold}Executing accelerated application:${normal}"
#echo ""
#echo "make run TARGET=$target PLATFORM=$platform" 
#echo ""
#eval "make run TARGET=$target PLATFORM=$platform"
#echo ""