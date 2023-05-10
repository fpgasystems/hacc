#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#get username
username=$USER

# create my_projects directory
DIR="/home/$username/my_projects"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

# create hip directory
DIR="/home/$username/my_projects/hip"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

# get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

# inputs
read -a flags <<< "$@"

#define directories
CLI_WORKDIR="/opt/cli"
VALIDATION_DIR="/home/$USER/my_projects/hip/validate_hip"

#create temporal validation dir
if ! [ -d "$VALIDATION_DIR" ]; then
    mkdir ${VALIDATION_DIR}
    mkdir $VALIDATION_DIR/build_dir
fi

# copy and compile
cp -rf $CLI_WORKDIR/templates/hip/hello_world/* $VALIDATION_DIR

#create config
cp $VALIDATION_DIR/configs/config_000.hpp $VALIDATION_DIR/configs/config_001.hpp
touch $VALIDATION_DIR/configs/config_001.active

#build (compile)
$CLI_WORKDIR/build/hip -p validate_hip

#run
#$CLI_WORKDIR/run/hip -p validate_hip
echo "${bold}Running HIP:${normal}"
echo ""
$VALIDATION_DIR/build_dir/main

# remove temporal validation files
rm -rf $VALIDATION_DIR

echo ""