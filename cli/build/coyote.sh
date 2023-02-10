#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
#CONFIG="perf_fpga"

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

# when used, device_name or project_name cannot be empty
if [ "$name_found" = "1" ] && [ "$device_name" = "" ]; then
    /opt/cli/sgutil build coyote -h
    exit
fi

if [ "$project_found" = "1" ] && [ "$project_name" = "" ]; then
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

#create or select a configuration
cd $DIR/configs/
if [[ $(ls -l | wc -l) = 2 ]]; then
    #only config_000 exists and we create config_001
    #we compile create_config (in case there were changes)
    cd $DIR/src
    g++ -std=c++17 create_config.cpp -o ../create_config >&/dev/null
    cd $DIR
    ./create_config
elif [[ $(ls -l | wc -l) = 4 ]]; then
    #config_000, config_shell and config_001 exist
    cp -fr $DIR/configs/config_001.hpp $DIR/configs/config_000.hpp
elif [[ $(ls -l | wc -l) > 4 ]]; then
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

#echo $coyote_params

#exit

#sgutil get device if there is only one FPGA and not name_found
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $name_found = "0" ]]; then
    device_name=$(sgutil get device | cut -d "=" -f2)
fi

# device_name to coyote string <===========================================================================
FDEV_NAME=$(echo $HOSTNAME | grep -oP '(?<=-).*?(?=-)')
if [ "$FDEV_NAME" = "u50d" ]; then
    FDEV_NAME="u50"
fi

#define directories
DIR="/home/$username/my_projects/coyote/$project_name"
SHELL_BUILD_DIR="/home/$username/my_projects/coyote/$project_name/hw/build"
DRIVER_DIR="/home/$username/my_projects/coyote/$project_name/driver"
APP_BUILD_DIR="/home/$username/my_projects/coyote/$project_name/build"

#change directory
#DIR="/home/$username/my_projects/coyote/$project_name"
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
    #SHELL_BUILD_DIR="/home/$username/my_projects/coyote/$project_name/hw/build" #build_dir.hw_$config.$device_name
    if ! [ -d "$SHELL_BUILD_DIR" ]; then
        echo "${bold}Coyote shell compilation:${normal}"
        echo ""
        echo "cmake .. -DFDEV_NAME=$FDEV_NAME $coyote_params" #-DEXAMPLE=$config
        echo ""
        mkdir $SHELL_BUILD_DIR
        cd $SHELL_BUILD_DIR
        #/usr/bin/cmake .. -DFDEV_NAME=$FDEV_NAME -DEXAMPLE=perf_host
        /usr/bin/cmake .. -DFDEV_NAME=$FDEV_NAME $coyote_params

        #generate bitstream
        echo ""
        echo "${bold}Coyote shell bitstream generation:${normal}"
        echo ""
        echo "make shell && make compile"
        echo ""
        make shell && make compile

        #driver compilation
        #DRIVER_DIR="/home/$username/my_projects/coyote/$project_name/driver"
        echo ""
        echo "${bold}Driver compilation:${normal}"
        echo ""
        echo "cd $DRIVER_DIR && make"
        echo ""
        cd $DRIVER_DIR && make

        #copy perf_host main.cpp
        #if ! [ -d "$MAIN_CPP_DIR_1" ]; then
        #    mkdir $MAIN_CPP_DIR_1
        #    cp $MAIN_CPP_DIR_0/main.cpp $MAIN_CPP_DIR_1
        #fi
    else
        #echo "${bold}Coyote shell and driver compilation:${normal}"
        #echo ""
        #echo "cmake .. -DFDEV_NAME=$FDEV_NAME -DEXAMPLE=$config"
        #echo "make shell && make compile"
        echo ""
        echo "Coyote shell already exists!"
        #exit
    fi

    #mkdir /home/jmoyapaya/my_projects/coyote/compile_0/build
    #cp /home/jmoyapaya/my_projects/coyote/compile_0/sw/examples/perf_host/main.cpp /home/jmoyapaya/my_projects/coyote/compile_0/src
    #cd /home/jmoyapaya/my_projects/coyote/compile_0/build

    #application compilation
    #APP_BUILD_DIR="/home/$username/my_projects/coyote/$project_name/sw/examples/$config/build" #build_dir.sw_$config
    #APP_BUILD_DIR="/home/$username/my_projects/coyote/$project_name/build"
    echo ""
    echo "${bold}Example application compilation:${normal}"
    echo ""
    echo "cmake ../sw -DTARGET_DIR=../src/ && make"
    echo ""
    if ! [ -d "$APP_BUILD_DIR" ]; then
        mkdir $APP_BUILD_DIR
        cd $APP_BUILD_DIR
        #/usr/bin/cmake ../../../ -DTARGET_DIR=examples/$config && make
        /usr/bin/cmake ../sw -DTARGET_DIR=../src/ && make # 1: path from APP_BUILD_DIR to /sw 2: path from APP_BUILD_DIR to main.cpp
        #copy bitstream
        cp $SHELL_BUILD_DIR/bitstreams/cyt_top.bit $APP_BUILD_DIR
        #copy driver
        cp $DRIVER_DIR/coyote_drv.ko $APP_BUILD_DIR
        #rename folder
        mv $APP_BUILD_DIR $APP_BUILD_DIR"_dir.$device_name"
    else
        cd $APP_BUILD_DIR"_dir.$device_name"
        /usr/bin/cmake ../sw -DTARGET_DIR=../src/ && make
    fi
    

    #echo ""
    #cd $APP_BUILD_DIR
    #make

fi

echo ""