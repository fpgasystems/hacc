#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
HACC_PATH="/opt/hacc"
DEVICES_LIST="$HACC_PATH/devices_reconfigurable"
DEVICE_NAME_COLUMN=6
WORKFLOW="coyote"

#get username
username=$USER

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#check on DEVICES_LIST
source "$CLI_PATH/common/device_list_check" "$DEVICES_LIST"

#get number of fpga and acap devices present
MAX_DEVICES=$(grep -E "fpga|acap" $DEVICES_LIST | wc -l)

#check on multiple devices
multiple_devices=$($CLI_PATH/common/get_multiple_devices $MAX_DEVICES)

#inputs
read -a flags <<< "$@"

#check for vivado_developers
member=$($CLI_PATH/common/is_member $username vivado_developers)
if [ "$member" = "false" ]; then
    echo ""
    echo "Sorry, ${bold}$username!${normal} You are not granted to use this command."
    echo ""
    exit
fi

#check if workflow exists
if ! [ -d "/home/$username/my_projects/$WORKFLOW/" ]; then
    echo ""
    echo "You must create your project first! Please, use sgutil new $WORKFLOW"
    echo ""
    exit
fi

#check on flags
project_found=""
project_name=""
device_found=""
device_name=""
if [ "$flags" = "" ]; then
    #header (1/2)
    echo ""
    echo "${bold}sgutil build $WORKFLOW${normal}"
    #project_dialog
    echo ""
    echo "${bold}Please, choose your $WORKFLOW project:${normal}"
    echo ""
    result=$($CLI_PATH/common/project_dialog $username $WORKFLOW)
    project_found=$(echo "$result" | sed -n '1p')
    project_name=$(echo "$result" | sed -n '2p')
    multiple_projects=$(echo "$result" | sed -n '3p')
    if [[ $multiple_projects = "0" ]]; then
        echo $project_name
    fi
    #device_name_dialog
    echo ""
    echo "${bold}Please, choose your device:${normal}"
    echo ""
    result=$($CLI_PATH/common/device_name_dialog $CLI_PATH $MAX_DEVICES $multiple_devices)
    device_found=$(echo "$result" | sed -n '1p')
    device_name=$(echo "$result" | sed -n '2p')
    if [[ $multiple_devices = "0" ]]; then
        echo $device_name
    fi
else
    #project_dialog_check
    result="$("$CLI_PATH/common/project_dialog_check" "${flags[@]}")"
    project_found=$(echo "$result" | sed -n '1p')
    project_name=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if [ "$project_found" = "1" ] && ([ "$project_name" = "" ] || [ ! -d "/home/$username/my_projects/$WORKFLOW/$project_name" ]); then 
        $CLI_PATH/sgutil build $WORKFLOW -h
        exit
    fi
    #device_name_dialog_check
    result="$("$CLI_PATH/common/device_name_dialog_check" "${flags[@]}")"
    device_found=$(echo "$result" | sed -n '1p')
    device_name=$(echo "$result" | sed -n '2p')
    #get device_match
    device_match=$(awk -v col="$DEVICE_NAME_COLUMN" -v device="$device_name" '$col == device { found=1; exit } END { if (found) print 1; else print 0 }' "$DEVICES_LIST")
    #forbidden combinations
    if [ "$device_found" = "1" ] && ([ "$device_name" = "" ] || [ "$device_match" = "0" ]); then 
        $CLI_PATH/sgutil build $WORKFLOW -h
        exit
    fi
    #header (2/2)
    echo ""
    echo "${bold}sgutil build $WORKFLOW${normal}"
    echo ""
    #project_dialog (forgotten mandatory 1)
    if [[ $project_found = "0" ]]; then
        #echo ""
        echo "${bold}Please, choose your $WORKFLOW project:${normal}"
        echo ""
        result=$($CLI_PATH/common/project_dialog $username $WORKFLOW)
        project_found=$(echo "$result" | sed -n '1p')
        project_name=$(echo "$result" | sed -n '2p')
        multiple_projects=$(echo "$result" | sed -n '3p')
        if [[ $multiple_projects = "0" ]]; then
            echo $project_name
        fi
        #echo ""
    fi
    #device_name_dialog (forgotten mandatory 2)
    if [[ $device_found = "0" ]]; then
        echo ""
        echo "${bold}Please, choose your device:${normal}"
        echo ""
        result=$($CLI_PATH/common/device_name_dialog $CLI_PATH $MAX_DEVICES $multiple_devices)
        device_found=$(echo "$result" | sed -n '1p')
        device_name=$(echo "$result" | sed -n '2p')
        if [[ $multiple_devices = "0" ]]; then
            echo $device_name
        fi
    fi
fi

#define directories (1)
DIR="/home/$username/my_projects/$WORKFLOW/$project_name"

# check if project exists
if ! [ -d "$DIR" ]; then
    echo ""
    echo "You must create your project first! Please, use sgutil new $WORKFLOW"
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

# device_name to coyote string 
if [ "$hostname" = "alveo-build-01" ]; then
    echo "${bold}Please, choose the device (or platform):${normal}" 
    echo ""
    PS3=""
    select FDEV_NAME in u250 u280 u50d u55c
    do
        case $FDEV_NAME in
            u250) break;;
            u280) break;;
            u50d) break;;
            u55c) break;;
        esac
    done
    echo ""
else
    FDEV_NAME=$(echo $HOSTNAME | grep -oP '(?<=-).*?(?=-)')
fi

#check on u50d
if [ "$FDEV_NAME" = "u50d" ]; then
    FDEV_NAME="u50"
fi

#create or select a configuration
cd $DIR/configs/
if [[ $(ls -l | wc -l) = 2 ]]; then
    #only config_000 exists and we create config_shell and config_001
    #we compile create_config (in case there were changes)
    cd $DIR/src
    g++ -std=c++17 create_config.cpp -o ../create_config >&/dev/null
    cd $DIR
    ./create_config
    cp -fr $DIR/configs/config_001.hpp $DIR/configs/config_000.hpp
    config="config_001.hpp"
elif [[ $(ls -l | wc -l) = 5 ]]; then
    #config_000, config_shell and config_001 exist
    cp -fr $DIR/configs/config_001.hpp $DIR/configs/config_000.hpp
    config="config_001.hpp"
    echo ""
elif [[ $(ls -l | wc -l) > 5 ]]; then
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

#save config id
cd $DIR/configs/
if [ -e config_*.active ]; then
    rm *.active
fi
config_id="${config%%.*}"
touch $config_id.active

#compile Coyote shell (get config_shell parameters)
coyote_params=""
shopt -s lastpipe
cat $DIR/configs/config_shell.hpp | while read line 
do
    #find equal (=)
    idx=$(sed 's/ /\n/g' <<< "$line" | sed -n "/=/=")
    #get indexes
    name_idx=$(($idx-1))
    value_idx=$(($idx+1))  
    #get data
    name=$(echo $line | awk -v i=$name_idx '{ print $i }')
    value=$(echo $line | awk -v i=$value_idx '{ print $i }' | sed 's/;//' )
    #add to string
    coyote_params=$coyote_params"-D"$name"="$value" "
done

#define directories (2)
SHELL_BUILD_DIR="$DIR/hw/build"
DRIVER_DIR="$DIR/driver"
APP_BUILD_DIR="$DIR/build_dir.$FDEV_NAME"

echo "${bold}Changing directory:${normal}"
echo ""
echo "cd $DIR"
echo ""
cd $DIR

#shell compilation    
if ! [ -d "$APP_BUILD_DIR" ]; then
    echo "${bold}Coyote shell compilation:${normal}"
    echo ""
    echo "cmake .. -DFDEV_NAME=$FDEV_NAME $coyote_params"
    echo ""
    mkdir $SHELL_BUILD_DIR
    cd $SHELL_BUILD_DIR
    /usr/bin/cmake .. -DFDEV_NAME=$FDEV_NAME -DEXAMPLE=perf_host #$coyote_params

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
    echo "${bold}Application compilation:${normal}"
    echo ""
    echo "cmake ../sw -DTARGET_DIR=../src/ && make"
    echo ""
    mkdir $APP_BUILD_DIR
    cd $APP_BUILD_DIR
    /usr/bin/cmake ../sw -DTARGET_DIR=../src/ && make # 1: path from APP_BUILD_DIR to /sw 2: path from APP_BUILD_DIR to main.cpp
    
    #save referring to config
    #config="${config%%.*}"
    #mv main main_$config

    #copy bitstream
    cp $SHELL_BUILD_DIR/bitstreams/cyt_top.bit $APP_BUILD_DIR
    #copy driver
    cp $DRIVER_DIR/coyote_drv.ko $APP_BUILD_DIR
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

    #send email at the end
    user_email=$username@ethz.ch
    echo "Subject: Good news! sgutil build coyote ($project_name / -DFDEV_NAME=$FDEV_NAME) is done!" | sendmail $user_email

else
    echo "${bold}Coyote shell bitstream generation:${normal}"
    echo ""
    echo "$project_name/build_dir.$FDEV_NAME shell already exists!"

    #driver compilation
    echo ""
    echo "${bold}Driver compilation:${normal}"
    echo ""
    echo "cd $DRIVER_DIR && make"
    echo ""
    cd $DRIVER_DIR && make
    
    #copy driver
    cp $DRIVER_DIR/coyote_drv.ko $APP_BUILD_DIR

    #remove driver build temporal folders
    rm $DRIVER_DIR/coyote_drv*
    rm $DRIVER_DIR/fpga_dev.o
    rm $DRIVER_DIR/fpga_drv.o
    rm $DRIVER_DIR/fpga_fops.o
    rm $DRIVER_DIR/fpga_isr.o
    rm $DRIVER_DIR/fpga_mmu.o
    rm $DRIVER_DIR/fpga_sysfs.o
    rm $DRIVER_DIR/modules.order

    #application compilation
    echo ""
    echo "${bold}Application compilation:${normal}"
    echo ""
    echo "cmake ../sw -DTARGET_DIR=../src/ && make"
    echo ""
    #mkdir $APP_BUILD_DIR
    cd $APP_BUILD_DIR
    #remove CMakeLists.txt to avoid recompiling errors
    rm CMakeCache.txt
    /usr/bin/cmake ../sw -DTARGET_DIR=../src/ && make # 1: path from APP_BUILD_DIR to /sw 2: path from APP_BUILD_DIR to main.cpp
    
    #save referring to config
    #config="${config%%.*}"
    #mv main main_$config
fi

echo ""