#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#get username
username=$USER

# inputs
read -a flags <<< "$@"

echo ""
echo "${bold}sgutil run coyote${normal}"

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

#check if project exists
if ! [ -d "$DIR" ]; then
    echo ""
    echo "$DIR is not a valid --project name!"
    echo ""
    exit
fi

#create or select a configuration
cd $DIR/configs/
if [[ $(ls -l | wc -l) = 2 ]]; then
    #only config_000 exists and we create config_001
    #we compile create_config (in case there were changes)
    cd $DIR/src
    g++ -std=c++17 create_config.cpp -o ../create_config >&/dev/null
    cd $DIR
    ./create_config
    cp -fr $DIR/configs/config_001.hpp $DIR/configs/config_000.hpp
    config="config_001.hpp"
elif [[ $(ls -l | wc -l) = 4 ]]; then
    #config_000, config_shell and config_001 exist
    cp -fr $DIR/configs/config_001.hpp $DIR/configs/config_000.hpp
    config="config_001.hpp"
    echo ""
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

#sgutil get device if there is only one FPGA and not name_found ------------------> this will change with the fpga_idx concept
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $name_found = "0" ]]; then
    device_name=$(sgutil get device | cut -d "=" -f2)
fi

#define directories (2)
APP_BUILD_DIR="/home/$username/my_projects/coyote/$project_name/build_dir.$device_name/"

#check for build directory
if ! [ -d "$APP_BUILD_DIR" ]; then
    echo ""
    echo "You must generate your application first! Please, use sgutil build coyote"
    echo ""
    exit
fi

#change directory
echo ""
echo "${bold}Changing directory:${normal}"
echo ""
echo "cd $DIR"
echo ""
cd $DIR
    
cd $APP_BUILD_DIR
./main

echo ""