#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="$(dirname "$(dirname "$0")")"
VIVADO_DEVICES_MAX=$(cat $CLI_PATH/constants/VIVADO_DEVICES_MAX)
DEVICES_LIST="$CLI_PATH/devices_acap_fpga"
MY_PROJECTS_PATH=$($CLI_PATH/common/get_constant $CLI_PATH MY_PROJECTS_PATH)
WORKFLOW="coyote"
BIT_NAME="cyt_top.bit"
DRIVER_NAME="coyote_drv.ko"

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#check on virtualized servers
virtualized=$($CLI_PATH/common/is_virtualized $CLI_PATH $hostname)
if [ "$virtualized" = "1" ]; then
    echo ""
    echo "Sorry, this command is not available on ${bold}$hostname!${normal}"
    echo ""
    exit
fi

#check on ACAP or FPGA servers (server must have at least one ACAP or one FPGA)
acap=$($CLI_PATH/common/is_acap $CLI_PATH $hostname)
fpga=$($CLI_PATH/common/is_fpga $CLI_PATH $hostname)
if [ "$acap" = "0" ] && [ "$fpga" = "0" ]; then
    echo ""
    echo "Sorry, this command is not available on ${bold}$hostname!${normal}"
    echo ""
    exit
fi

#check on valid Vivado version
if [ -z "$(echo $XILINX_VIVADO)" ]; then
    echo ""
    echo "Please, source a valid Vivado version for ${bold}$hostname!${normal}"
    echo ""
    exit 1
fi

#check for vivado_developers
member=$($CLI_PATH/common/is_member $USER vivado_developers)
if [ "$member" = "false" ]; then
    echo ""
    echo "Sorry, ${bold}$USER!${normal} You are not granted to use this command."
    echo ""
    exit
fi

#check on DEVICES_LIST
source "$CLI_PATH/common/device_list_check" "$DEVICES_LIST"

#get number of fpga and acap devices present
MAX_DEVICES=$(grep -E "fpga|acap" $DEVICES_LIST | wc -l)

#check on multiple devices
multiple_devices=$($CLI_PATH/common/get_multiple_devices $MAX_DEVICES)

#inputs
read -a flags <<< "$@"

#create coyote directory (we do not know if sgutil new coyote has been run)
DIR="$MY_PROJECTS_PATH/$WORKFLOW"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

#check on flags
device_found=""
device_index=""
if [ "$flags" = "" ]; then
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
        #check on VIVADO_DEVICES_MAX
        vivado_devices=$($CLI_PATH/common/get_vivado_devices $CLI_PATH $MAX_DEVICES $device_index)
        if [ $vivado_devices -ge $((VIVADO_DEVICES_MAX)) ]; then
            echo ""
            echo "Sorry, you have reached the maximum number of devices in ${bold}Vivado workflow!${normal}"
            echo ""
            exit
        fi
        #check on acap (temporal until Coyote works on Versal)
        device_type=$($CLI_PATH/get/get_fpga_device_param $device_index device_type)
        if [[ $device_type = "acap" ]]; then
            echo ""
            echo "Sorry, this command is not available on ${bold}$device_type!${normal}"
            echo ""
            exit
        fi
    fi
else
    #device_dialog_check
    result="$("$CLI_PATH/common/device_dialog_check" "${flags[@]}")"
    device_found=$(echo "$result" | sed -n '1p')
    device_index=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if ([ "$device_found" = "1" ] && [ "$device_index" = "" ]) || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 1 ))) || ([ "$device_found" = "1" ] && ([[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 1 ]])); then
        $CLI_PATH/sgutil validate coyote -h
        exit
    fi
    #check on VIVADO_DEVICES_MAX
    if [ "$device_found" = "1" ]; then
        vivado_devices=$($CLI_PATH/common/get_vivado_devices $CLI_PATH $MAX_DEVICES $device_index)
        if [ $vivado_devices -ge $((VIVADO_DEVICES_MAX)) ]; then
            echo ""
            echo "Sorry, you have reached the maximum number of devices in ${bold}Vivado workflow!${normal}"
            echo ""
            exit
        fi
    fi
    #check on acap (temporal until Coyote works on Versal)
    device_type=$($CLI_PATH/get/get_fpga_device_param $device_index device_type)
    if ([ "$device_found" = "1" ] && [[ $device_type = "acap" ]]); then
        echo ""
        echo "Sorry, this command is not available on ${bold}$device_type!${normal}"
        echo ""
        exit
    fi
    #device_dialog (forgotten mandatory 1)
    if [[ $multiple_devices = "0" ]]; then
        device_found="1"
        device_index="1"
    elif [[ $device_found = "0" ]]; then
        echo "${bold}Please, choose your device:${normal}"
        echo ""
        result=$($CLI_PATH/common/device_dialog $CLI_PATH $MAX_DEVICES $multiple_devices)
        device_found=$(echo "$result" | sed -n '1p')
        device_index=$(echo "$result" | sed -n '2p')
        #check on VIVADO_DEVICES_MAX
        vivado_devices=$($CLI_PATH/common/get_vivado_devices $CLI_PATH $MAX_DEVICES $device_index)
        if [ $vivado_devices -ge $((VIVADO_DEVICES_MAX)) ]; then
            echo ""
            echo "Sorry, you have reached the maximum number of devices in ${bold}Vivado workflow!${normal}"
            echo ""
            exit
        fi
        #check on acap (temporal until Coyote works on Versal)
        device_type=$($CLI_PATH/get/get_fpga_device_param $device_index device_type)
        if [[ $device_type = "acap" ]]; then
            echo ""
            echo "Sorry, this command is not available on ${bold}$device_type!${normal}"
            echo ""
            exit
        fi
        echo ""
    fi
fi

#header (1/1)
echo ""
echo "${bold}sgutil validate $WORKFLOW${normal}"

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

#platform to FDEV_NAME
platform=$($CLI_PATH/get/get_fpga_device_param $device_index platform)
FDEV_NAME=$(echo "$platform" | cut -d'_' -f2)

#set project name
project_name="validate_$config.$FDEV_NAME"

#define directories (1)
DIR="$MY_PROJECTS_PATH/$WORKFLOW/$project_name"
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
if ! [ -d "$MY_PROJECTS_PATH/$WORKFLOW/$project_name/build_dir.$FDEV_NAME" ]; then
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
    mv $APP_BUILD_DIR $MY_PROJECTS_PATH/$WORKFLOW/$project_name/build_dir.$FDEV_NAME/
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
APP_BUILD_DIR=$MY_PROJECTS_PATH/$WORKFLOW/$project_name/build_dir.$FDEV_NAME/

#change directory
cd $APP_BUILD_DIR

#program coyote bitstream and driver
$CLI_PATH/program/vivado --device $device_index -b $BIT_NAME --driver $DRIVER_NAME

#get permissions on N_REGIONS
$CLI_PATH/program/enable_N_REGIONS $DIR

#run 
cd $APP_BUILD_DIR
./main