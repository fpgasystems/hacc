#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#get username
username=$USER

# create my_projects directory
#DIR="/home/$username/my_projects"
#if ! [ -d "$DIR" ]; then
#    mkdir ${DIR}
#fi

# create hip directory
#DIR="/home/$username/my_projects/hip"
#if ! [ -d "$DIR" ]; then
#    mkdir ${DIR}
#fi

# get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

# inputs
read -a flags <<< "$@"

#define directories
CLI_WORKDIR="/opt/cli"





echo ""