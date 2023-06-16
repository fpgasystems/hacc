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

#inputs
read -a flags <<< "$@"

echo ""
echo "${bold}sgutil validate $WORKFLOW${normal}"

#create hip directory (we do not know if sgutil new hip has been run)
DIR="/home/$username/my_projects/$WORKFLOW"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

#we will need to read the device index just like for vitis!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#check on flags [...]

#define directories (1)
VALIDATION_DIR="/home/$USER/my_projects/$WORKFLOW/validate_hip"

#create temporal validation dir
if ! [ -d "$VALIDATION_DIR" ]; then
    mkdir ${VALIDATION_DIR}
    mkdir $VALIDATION_DIR/build_dir
fi

#copy and compile
cp -rf $CLI_PATH/templates/$WORKFLOW/hello_world/* $VALIDATION_DIR

#create config
cp $VALIDATION_DIR/configs/config_000.hpp $VALIDATION_DIR/configs/config_001.hpp
touch $VALIDATION_DIR/configs/config_001.active

#build (compile)
$CLI_PATH/build/hip -p validate_hip

#run
echo "${bold}Running HIP:${normal}"
echo ""
$VALIDATION_DIR/build_dir/main

#remove temporal validation files
rm -rf $VALIDATION_DIR

echo ""