#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#get username
username=$USER

# inputs
read -a flags <<< "$@"

# flags cannot be empty
if [ "$flags" = "" ]; then
    /opt/cli/sgutil build coyote -h
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

# check if project exists
DIR="/home/$username/my_projects/coyote/$project_name"
if ! [ -d "$DIR" ]; then
    echo ""
    echo "$DIR is not a valid --project name!"
    echo ""
    exit
fi

echo ""
echo "${bold}sgutil build coyote${normal}"
echo ""
echo "Please, choose Coyote's configuration:"
echo ""
PS3=""
select config in perf_host perf_fpga gbm_dtrees hyperloglog perf_dram perf_hbm perf_rdma_host perf_rdma_card perf_tcp rdma_regex service_aes service_reconfiguration
do
    case $config in
        perf_host) break;;
        perf_fpga) break;;
        gbm_dtrees) break;;
        hyperloglog) break;;
        perf_dram) break;;
        perf_hbm) break;;
        perf_rdma_host) break;;
        perf_rdma_card) break;;
        perf_tcp) break;;
        rdma_regex) break;;
        service_aes) break;;
        service_reconfiguration) break;;
    esac
done

#sgutil get device if there is only one FPGA and not name_found
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $name_found = "0" ]]; then
    device_name=$(sgutil get device | cut -d "=" -f2)
fi

#echo $device_name

# device_name to coyote string <===========================================================================
case "$device_name" in
    xcu250_0) 
        FDEV_NAME="u250"
        ;;
    xcu50_u55n_0)
        FDEV_NAME="u50"
        ;;
    xcu280_u55c_0) 
        FDEV_NAME="u55c"
        ;;
    *)
        echo ""
        echo "Unknown device name."
        echo ""
    ;;  
esac

# serial to platform
cd /opt/xilinx/platforms
n=$(ls -l | grep -c ^d)
if [ $((n + 0)) -eq  1 ]; then
    platform=$(echo *)
fi

#change directory
DIR="/home/$username/my_projects/coyote/$project_name"
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

    #bitstream compilation
    BUILD_DIR="/home/$username/my_projects/coyote/$project_name/hw/build" #build_dir.hw_$config.$device_name
    if ! [ -d "$BUILD_DIR" ]; then
        echo "${bold}Bitstream compilation:${normal}"
        echo ""
        echo "cmake .. -DFDEV_NAME=$FDEV_NAME -DEXAMPLE=$config"
        echo ""
        mkdir $BUILD_DIR
        cd $BUILD_DIR
        cmake .. -DFDEV_NAME=$FDEV_NAME -DEXAMPLE=$config

        #generate bitstream
        echo ""
        echo "${bold}Bitstream generation:${normal}"
        echo ""
        echo "make shell && make compile"
        echo ""
        make shell && make compile
    else
        echo "${bold}Bitstream compilation and generation:${normal}"
        echo ""
        echo "cmake .. -DFDEV_NAME=$FDEV_NAME -DEXAMPLE=$config"
        echo "make shell && make compile"
        echo ""
        echo "$BUILD_DIR already exists!"
        #exit
    fi

    #driver compilation
    DRIVER_DIR="/home/$username/my_projects/coyote/$project_name/driver"
    echo ""
    echo "${bold}Driver compilation:${normal}"
    echo ""
    echo "cd $DRIVER_DIR && make"
    echo ""
    cd $DRIVER_DIR && make

    #application compilation
    #APP_DIR="/home/$username/my_projects/coyote/$project_name/sw"
    APP_DIR="/home/$username/my_projects/coyote/$project_name/sw/build" #build_dir.sw_$config
    echo ""
    echo "${bold}Application compilation:${normal}"
    echo ""
    echo "cmake ../ -DTARGET_DIR=../examples/$config && make"
    echo ""
    if ! [ -d "$APP_DIR" ]; then
        mkdir $APP_DIR
    fi
    cd $APP_DIR
    cmake ../ -DTARGET_DIR=../examples/$config && make

    echo ""
    cd $APP_DIR
    make

fi

echo ""