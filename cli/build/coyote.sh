#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#get username
username=$USER

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#inputs
read -a flags <<< "$@"

echo ""
echo "${bold}sgutil build coyote${normal}"

#check for vivado_developers
member=$(/opt/cli/common/is_member $username vivado_developers)
if [ "$member" = "false" ]; then
    echo ""
    echo "Sorry, ${bold}$username!${normal} You are not granted to use this command."
    echo ""
    exit
fi

#check if workflow exists
if ! [ -d "/home/$username/my_projects/coyote/" ]; then
    echo ""
    echo "You must create your project first! Please, use sgutil new coyote"
    echo ""
    exit
fi

#check on flags (before: flags cannot be empty)
name_found="0"
project_found="0"
if [ "$flags" = "" ]; then
    #no flags: start dialog
    cd /home/$username/my_projects/coyote/
    projects=( *"/" )
    #delete validate folders from projects
    j=0
    for i in "${projects[@]}"
    do
        if [[ $i =~ validate_* ]]; then
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
    select project_name in "${aux[@]}"; do #projects
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
    #forbidden combinations
    if [[ $project_found = "0" ]] || ([ "$project_found" = "1" ] && [ "$project_name" = "" ]) || ([ $project_found = "0" ] && [ $name_found = "1" ]) || ([ "$name_found" = "1" ] && [ "$device_name" = "" ]); then
        /opt/cli/sgutil build coyote -h
        exit
    fi
fi

#define directories (1)
DIR="/home/$username/my_projects/coyote/$project_name"

# check if project exists
if ! [ -d "$DIR" ]; then
    echo ""
    echo "You must create your project first! Please, use sgutil new coyote"
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

#sgutil get device if there is only one FPGA and not name_found
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $name_found = "0" ]]; then
    device_name=$(sgutil get device | cut -d "=" -f2)
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