#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#get username
username=$USER

# inputs
read -a flags <<< "$@"

echo ""
echo "${bold}sgutil run hip${normal}"

#check if workflow exists
if ! [ -d "/home/$username/my_projects/hip/" ]; then
    echo ""
    echo "You must build your project first! Please, use sgutil build hip"
    echo ""
    exit
fi

#check on flags (before: flags cannot be empty)
project_found="0"
if [ "$flags" = "" ]; then
    #no flags: start dialog
    cd /home/$username/my_projects/hip/
    projects=( *"/" )
    echo ""
    echo "${bold}Please, choose your project:${normal}"
    echo ""
    PS3=""
    select project_name in "${projects[@]}"; do
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
        if [[ " ${flags[$i]} " =~ " -p " ]] || [[ " ${flags[$i]} " =~ " --project " ]]; then
            project_found="1"
            project_idx=$(($i+1))
            project_name=${flags[$project_idx]}
        fi
    done
    #project is not found or its name is empty
    if [[ $project_found = "0" ]] || ([ "$project_found" = "1" ] && [ "$project_name" = "" ]); then
        /opt/cli/sgutil run hip -h
        exit
    fi
fi

#define directories
DIR="/home/$username/my_projects/hip/$project_name"
APP_BUILD_DIR="$DIR/build_dir"

#check for project directory
if ! [ -d "$DIR" ]; then
    echo ""
    echo "You must create your project first! Please, use sgutil new hip"
    echo ""
    exit
fi

#check for build directory
if ! [ -d "$APP_BUILD_DIR" ]; then
    echo ""
    echo "You must generate your application first! Please, use sgutil build hip"
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

#display configuration
cd $DIR/configs/
config_id=$(ls *.active)
config_id="${config_id%%.*}"

echo "${bold}You are running $config_id:${normal}"
echo ""
cat $DIR/configs/config_000.hpp
echo ""

#run
echo "${bold}Running HIP:${normal}"
echo ""
echo "$APP_BUILD_DIR/main"
echo ""
$APP_BUILD_DIR/main

echo ""