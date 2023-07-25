#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="$(dirname "$(dirname "$0")")"
XILINX_PLATFORMS_PATH=$($CLI_PATH/common/get_constant $CLI_PATH XILINX_PLATFORMS_PATH)
MY_PROJECTS_PATH=$($CLI_PATH/common/get_constant $CLI_PATH MY_PROJECTS_PATH)
WORKFLOW="coyote"

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

#check if workflow exists
if ! [ -d "$MY_PROJECTS_PATH/$WORKFLOW/" ]; then
    echo ""
    echo "You must create your project first! Please, use sgutil new $WORKFLOW"
    echo ""
    exit
fi

#inputs
read -a flags <<< "$@"

#check on flags
project_found=""
project_name=""
platform_found=""
platform_name=""
if [ "$flags" = "" ]; then
    #header (1/2)
    echo ""
    echo "${bold}sgutil build $WORKFLOW${normal}"
    #project_dialog
    echo ""
    echo "${bold}Please, choose your $WORKFLOW project:${normal}"
    echo ""
    result=$($CLI_PATH/common/project_dialog $MY_PROJECTS_PATH/$WORKFLOW)
    project_found=$(echo "$result" | sed -n '1p')
    project_name=$(echo "$result" | sed -n '2p')
    multiple_projects=$(echo "$result" | sed -n '3p')
    if [[ $multiple_projects = "0" ]]; then
        echo $project_name
    fi
    #platform_dialog
    echo ""
    echo "${bold}Please, choose your platform:${normal}"
    echo ""
    result=$($CLI_PATH/common/platform_dialog $XILINX_PLATFORMS_PATH)
    platform_found=$(echo "$result" | sed -n '1p')
    platform_name=$(echo "$result" | sed -n '2p')
    multiple_platforms=$(echo "$result" | sed -n '3p')
    if [[ $multiple_platforms = "0" ]]; then
        echo $platform_name
    fi
else
    #project_dialog_check
    result="$("$CLI_PATH/common/project_dialog_check" "${flags[@]}")"
    project_found=$(echo "$result" | sed -n '1p')
    project_name=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if [ "$project_found" = "1" ] && ([ "$project_name" = "" ] || [ ! -d "$MY_PROJECTS_PATH/$WORKFLOW/$project_name" ]); then 
        $CLI_PATH/sgutil build $WORKFLOW -h
        exit
    fi
    #platform_dialog_check
    result="$("$CLI_PATH/common/platform_dialog_check" "${flags[@]}")"
    platform_found=$(echo "$result" | sed -n '1p')
    platform_name=$(echo "$result" | sed -n '2p')    
    #forbidden combinations
    if ([ "$platform_found" = "1" ] && [ "$platform_name" = "" ]) || ([ "$platform_found" = "1" ] && [ ! -d "$XILINX_PLATFORMS_PATH/$platform_name" ]); then
        $CLI_PATH/sgutil build $WORKFLOW -h
        exit
    fi
    #header (2/2)
    echo ""
    echo "${bold}sgutil build $WORKFLOW${normal}"
    #project_dialog (forgotten mandatory 1)
    if [[ $project_found = "0" ]]; then
        echo ""
        echo "${bold}Please, choose your $WORKFLOW project:${normal}"
        echo ""
        result=$($CLI_PATH/common/project_dialog $MY_PROJECTS_PATH/$WORKFLOW)
        project_found=$(echo "$result" | sed -n '1p')
        project_name=$(echo "$result" | sed -n '2p')
        multiple_projects=$(echo "$result" | sed -n '3p')
        if [[ $multiple_projects = "0" ]]; then
            echo $project_name
        fi
    fi
    #platform_dialog (forgotten mandatory 2)
    if [[ $platform_found = "0" ]]; then
        echo ""
        echo "${bold}Please, choose your platform:${normal}"
        echo ""
        result=$($CLI_PATH/common/platform_dialog $XILINX_PLATFORMS_PATH)
        platform_found=$(echo "$result" | sed -n '1p')
        platform_name=$(echo "$result" | sed -n '2p')
        multiple_platforms=$(echo "$result" | sed -n '3p')
        if [[ $multiple_platforms = "0" ]]; then
            echo $platform_name
        fi
    fi
fi

#define directories (1)
DIR="$MY_PROJECTS_PATH/$WORKFLOW/$project_name"

# check if project exists
if ! [ -d "$DIR" ]; then
    echo ""
    echo "You must create your project first! Please, use sgutil new $WORKFLOW"
    echo ""
    exit
fi

#platform_name to FDEV_NAME
FDEV_NAME=$(echo "$platform_name" | cut -d'_' -f2)

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
APP_BUILD_DIR="$DIR/build_dir.$FDEV_NAME" #FDEV_NAME

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
    user_email=$USER@ethz.ch
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
fi

echo ""