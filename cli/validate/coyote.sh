#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
HACC_PATH="/opt/hacc"
DEVICES_LIST="$HACC_PATH/devices_reconfigurable"
WORKFLOW="coyote"
BIT_NAME="cyt_top.bit"
DRIVER_NAME="coyote_drv.ko"

#get username
username=$USER

#check on DEVICES_LIST
source "$CLI_PATH/common/device_list_check" "$DEVICES_LIST"

#get number of fpga and acap devices present
MAX_DEVICES=$(grep -E "fpga|acap" $DEVICES_LIST | wc -l)

#check on multiple devices
multiple_devices=$($CLI_PATH/common/get_multiple_devices $MAX_DEVICES)

#inputs
read -a flags <<< "$@"

#create coyote directory (we do not know if sgutil new coyote has been run)
DIR="/home/$username/my_projects/$WORKFLOW"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

#header (1/1)
echo ""
echo "${bold}sgutil validate $WORKFLOW${normal}"

#check on flags
device_found=""
device_index=""
if [ "$flags" = "" ]; then
    #header (1/2)
    #echo ""
    #echo "${bold}sgutil program coyote${normal}"
    #device_dialog
    if [[ $multiple_devices = "0" ]]; then
        device_found="1"
        device_index="1"
    else
        echo ""
        echo "${bold}Please, choose your device:${normal}"
        echo ""
        result=$($CLI_PATH/common/device_dialog $CLI_PATH $MAX_DEVICES $multiple_devices)
        device_found=$(echo "$result" | sed -n '1p')
        device_index=$(echo "$result" | sed -n '2p')
    fi
else
    #device_dialog_check
    result="$("$CLI_PATH/common/device_dialog_check" "${flags[@]}")"
    device_found=$(echo "$result" | sed -n '1p')
    device_index=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if ([ "$device_found" = "1" ] && [ "$device_index" = "" ]) || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 1 ))) || ([ "$device_found" = "1" ] && ([[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 1 ]])); then
        $CLI_PATH/sgutil program coyote -h
        exit
    fi
    #header (2/2)
    #echo ""
    #echo "${bold}sgutil program coyote${normal}"
    #echo ""
    #device_dialog (forgotten mandatory 2)
    if [[ $multiple_devices = "0" ]]; then
        device_found="1"
        device_index="1"
    elif [[ $device_found = "0" ]]; then
        echo "${bold}Please, choose your device:${normal}"
        echo ""
        result=$($CLI_PATH/common/device_dialog $CLI_PATH $MAX_DEVICES $multiple_devices)
        device_found=$(echo "$result" | sed -n '1p')
        device_index=$(echo "$result" | sed -n '2p')
        echo ""
    fi
fi

echo ""
echo "${bold}Please, choose your configuration:${normal}" # this refers to a software (sw/examples) configuration
echo ""
PS3=""
select config in perf_host perf_fpga perf_mem gbm_dtrees hyperloglog #perf_host perf_fpga gbm_dtrees hyperloglog perf_dram perf_hbm perf_mem perf_rdma perf_rdma_host perf_rdma_card perf_tcp rdma_regex service_aes service_reconfiguration
do
    case $config in
        perf_host) break;;                  #1
        perf_fpga) break;;                  #2
        perf_mem) break;;                   #7
        gbm_dtrees) break;;                 #3
        hyperloglog) break;;                #4
    esac
done
# perf_host) break;;                  #1
# perf_fpga) break;;                  #2
# gbm_dtrees) break;;                 #3
# hyperloglog) break;;                #4
# perf_dram) break;;                  #5
# perf_hbm) break;;                   #6
# perf_mem) break;;                   #7
# perf_rdma) break;;                  #7  #8
# perf_rdma_host) break;;             #8  #9
# perf_rdma_card) break;;             #9  #10
# perf_tcp) break;;                   #10 #11
# rdma_regex) break;;                 #11 #12
# service_aes) break;;                #12 #13
# service_reconfiguration) break;;    #13 #14

#get device_name
device_name=$($CLI_PATH/get/get_fpga_device_param $device_index device_name)

#device_name to FDEV_NAME
#if [ "$device_name" = "xcu250_0" ]; then
#    FDEV_NAME=u250
#elif [ "$device_name" = "xcu280_u55c_0" ]; then
#    if [[ $multiple_devices = "0" ]]; then
#        FDEV_NAME=u280
#    else
#        FDEV_NAME=u55c
#    fi
#elif [ "$device_name" = "xcu50_u55n_0" ]; then
#    FDEV_NAME=u50    
#fi

#get FDEV_NAME
platform=$(/opt/cli/get/get_fpga_device_param $device_index platform)
FDEV_NAME=$(echo "$platform" | cut -d'_' -f2)


#set project name
project_name="validate_$config.$FDEV_NAME"

#define directories (1)
DIR="/home/$username/my_projects/$WORKFLOW/$project_name"
SHELL_BUILD_DIR="$DIR/hw/build"
DRIVER_DIR="$DIR/driver"
APP_BUILD_DIR="$DIR/sw/examples/$config/build"

# adjust perf_mem validation
if [ "$config" = "perf_mem" ]; then
    case "$FDEV_NAME" in
        u250) 
            config_hw="perf_dram"
            ;;
        u280) 
            config_hw="perf_hbm"
            ;;
        u50)
            config_hw="perf_hbm"
            ;;
        u55c)
            config_hw="perf_hbm"
            ;; 
        *)
            echo ""
            echo "Unknown device name."
            echo ""
        ;;  
    esac
else
    config_hw=$config
fi

# create coyote validate config.device_name directory and checkout
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
    echo ""
    echo "${bold}Checking out Coyote:${normal}"
    echo ""
    cd ${DIR}
    git clone https://github.com/fpgasystems/Coyote.git
    mv Coyote/* .
    rm -rf Coyote

    # create configuration file
    touch config_shell.hpp
    case "$config_hw" in #config
        perf_host) 
            echo "const int EN_HLS = 0;" > config_shell.hpp
            echo "const int EN_MEM = 0;" >> config_shell.hpp
            echo "const int EN_STRM = 1;" >> config_shell.hpp
            echo "const int EN_MEM = 0;" >> config_shell.hpp
            echo "const int N_REGIONS = 3;" >> config_shell.hpp
            ;;
        perf_fpga)
            echo "const int EN_HLS = 0;" > config_shell.hpp
            echo "const int EN_BPSS = 1;" >> config_shell.hpp
            echo "const int EN_STRM = 1;" >> config_shell.hpp
            echo "const int EN_MEM = 0;" >> config_shell.hpp
            echo "const int EN_WB = 1;" >> config_shell.hpp
            ;;
        perf_hbm)
            echo "const int N_REGIONS = 4;" > config_shell.hpp
            echo "const int EN_HLS = 0;" >> config_shell.hpp
            echo "const int EN_STRM = 0;" >> config_shell.hpp
            echo "const int EN_MEM = 1;" >> config_shell.hpp
            ;;
        perf_dram)
            echo "const int N_REGIONS = 4;" > config_shell.hpp
            echo "const int EN_HLS = 0;" >> config_shell.hpp
            echo "const int EN_STRM = 0;" >> config_shell.hpp
            echo "const int EN_MEM = 1;" >> config_shell.hpp
            echo "const int N_DDR_CHAN = 2;" >> config_shell.hpp
            ;;
        gbm_dtrees) 
            echo "const int EN_HLS = 0;" > config_shell.hpp
            echo "const int EN_STRM = 1;" >> config_shell.hpp
            echo "const int EN_MEM = 0;" >> config_shell.hpp
            ;;
        hyperloglog) 
            echo "const int EN_HLS = 1;" > config_shell.hpp
            echo "const int EN_STRM = 1;" >> config_shell.hpp
            echo "const int EN_MEM = 0;" >> config_shell.hpp
            ;;
        #perf_dram) 
        #    echo "const int N_REGIONS = 4;" > config_shell.hpp
        #    echo "const int EN_HLS = 0;" >> config_shell.hpp
        #    echo "const int EN_STRM = 0;" >> config_shell.hpp
        #    echo "const int EN_MEM = 1;" >> config_shell.hpp
        #    echo "const int N_DDR_CHAN = 2;" >> config_shell.hpp
        #    ;;
        *)
            echo ""
            echo "Unknown configuration."
            echo ""
        ;;  
    esac
    mkdir $DIR/configs
    mv $DIR/config_shell.hpp $DIR/configs/config_shell.hpp
fi

#check on build_dir.FDEV_NAME
if ! [ -d "/home/$username/my_projects/$WORKFLOW/$project_name/build_dir.$FDEV_NAME" ]; then
    #bitstream compilation
    echo ""
    echo "${bold}Coyote shell compilation:${normal}"
    echo ""
    echo "cmake .. -DFDEV_NAME=$FDEV_NAME -DEXAMPLE=$config_hw"
    echo ""
    mkdir $SHELL_BUILD_DIR
    cd $SHELL_BUILD_DIR
    /usr/bin/cmake .. -DFDEV_NAME=$FDEV_NAME -DEXAMPLE=$config_hw #$config

    #generate bitstream
    echo ""
    echo "${bold}Coyote shell bitstream generation:${normal}"
    echo ""
    echo "make shell && make compile"
    echo ""
    make shell && make compile

    #driver compilation
    echo ""
    echo "${bold}Driver compilation:${normal}"
    echo ""
    echo "cd $DRIVER_DIR && make"
    echo ""
    cd $DRIVER_DIR && make

    #application compilation
    echo ""
    echo "${bold}Example application compilation:${normal}"
    echo ""
    echo "cmake ../ -DTARGET_DIR=../examples/$config && make"
    echo ""
    if ! [ -d "$APP_BUILD_DIR" ]; then
        mkdir $APP_BUILD_DIR
    fi
    cd $APP_BUILD_DIR
    /usr/bin/cmake ../../../ -DTARGET_DIR=examples/$config && make
    #copy bitstream
    cp $SHELL_BUILD_DIR/bitstreams/cyt_top.bit $APP_BUILD_DIR
    #copy driver
    cp $DRIVER_DIR/coyote_drv.ko $APP_BUILD_DIR
    #rename folder
    mv $APP_BUILD_DIR /home/$username/my_projects/$WORKFLOW/$project_name/build_dir.$FDEV_NAME/
    #remove all other build temporal folders
    rm -rf $SHELL_BUILD_DIR
    rm $DRIVER_DIR/coyote_drv*
    rm $DRIVER_DIR/fpga_dev.o
    rm $DRIVER_DIR/fpga_drv.o
    rm $DRIVER_DIR/fpga_fops.o
    rm $DRIVER_DIR/fpga_isr.o
    rm $DRIVER_DIR/fpga_mmu.o
    rm $DRIVER_DIR/fpga_sysfs.o
    rm $DRIVER_DIR/modules.order
else
    echo ""
    echo "$project_name/build_dir.$FDEV_NAME shell already exists!"
    #echo ""
fi

#define directories (2)
APP_BUILD_DIR=/home/$username/my_projects/$WORKFLOW/$project_name/build_dir.$FDEV_NAME/

#change directory
cd $APP_BUILD_DIR

#program coyote bitstream
$CLI_PATH/program/vivado --device $device_index -b $BIT_NAME

#show message for virtualized environment (after program/vivado shows go to baremetal/warm boot message)
virtualized=$($CLI_PATH/common/is_virtualized)
if [[ $(lspci | grep Xilinx | wc -l) = 2 ]] && [ "$virtualized" = "true" ]; then
    echo "Once you login again on the server, please type ${bold}sgutil validate $WORKFLOW${normal} again."
    echo ""
fi

#get BDF (i.e., Bus:Device.Function) 
upstream_port=$($CLI_PATH/get/get_fpga_device_param $device_index upstream_port)
bdf="${upstream_port%??}" #i.e., we transform 81:00.0 into 81:00

#this means that the user made a warm boot (virtualized) or the PCI hot plug script run (dedicated servers)
if [[ $(lspci | grep Xilinx | grep $bdf | wc -l) = 1 ]]; then 

    #program coyote driver
    $CLI_PATH/sgutil program vivado --device $device_index --driver $DRIVER_NAME

    #get permissions on N_REGIONS
    $CLI_PATH/program/get_N_REGIONS $DIR

    #run 
    cd $APP_BUILD_DIR
    ./main
fi