#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
ROCM_PATH="/opt/rocm"
WORKFLOW="hip"

#get username
username=$USER

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#verify hip workflow (based on installed software)
test1=$(dkms status | grep amdgpu)
if [ -z "$test1" ] || [ ! -d "$ROCM_PATH/bin/" ]; then
    echo ""
    echo "Sorry, this command is not available on ${bold}$hostname!${normal}"
    echo ""
    exit
fi

#check if workflow exists
if ! [ -d "/home/$username/my_projects/$WORKFLOW/" ]; then
    echo ""
    echo "You must build your project first! Please, use sgutil build $WORKFLOW"
    echo ""
    exit
fi

#inputs
read -a flags <<< "$@"

#check on flags
project_found=""
project_name=""
if [ "$flags" = "" ]; then
    #header (1/2)
    echo ""
    echo "${bold}sgutil run $WORKFLOW${normal}"
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
else
    #project_dialog_check
    result="$("$CLI_PATH/common/project_dialog_check" "${flags[@]}")"
    project_found=$(echo "$result" | sed -n '1p')
    project_name=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if [ "$project_found" = "1" ] && ([ "$project_name" = "" ] || [ ! -d "/home/$username/my_projects/$WORKFLOW/$project_name" ]); then 
        $CLI_PATH/sgutil run $WORKFLOW -h
        exit
    fi
    #header (2/2)
    echo "${bold}sgutil run $WORKFLOW${normal}"
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
fi

#define directories (1)
DIR="/home/$username/my_projects/$WORKFLOW/$project_name"

#check if project exists
if ! [ -d "$DIR" ]; then
    echo ""
    echo "$DIR is not a valid --project name!"
    echo ""
    exit
fi

#define directories (2)
APP_BUILD_DIR="$DIR/build_dir"

#check for build directory
if ! [ -d "$APP_BUILD_DIR" ]; then
    echo ""
    echo "You must build your project first! Please, use sgutil build $WORKFLOW"
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