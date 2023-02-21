#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
WORKDIR="/home/$USER"
CLI_WORKDIR="/opt/cli"
MPICH_VERSION="4.0.2"
MPICH_WORKDIR="/opt/mpich/mpich-$MPICH_VERSION-install"

#get username
username=$USER

# inputs
read -a flags <<< "$@"

echo ""
echo "${bold}sgutil build mpi${normal}"

#check on flags (before: flags cannot be empty)
project_found="0"
if [ "$flags" = "" ]; then
    #no flags: start dialog
    cd /home/$username/my_projects/mpi/
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
        /opt/cli/sgutil build mpi -h
        exit
    fi
fi

#define directories
DIR="/home/$username/my_projects/mpi/$project_name"
APP_BUILD_DIR="$DIR/build_dir"

#check for project directory
if ! [ -d "$DIR" ]; then
    echo ""
    echo "You must create your project first! Please, use sgutil new mpi"
    echo ""
    exit
fi

# setup keys
#eval "$CLI_WORKDIR/common/ssh_key_add"

# set environment
PATH=$MPICH_WORKDIR/bin:$PATH
LD_LIBRARY_PATH=$MPICH_WORKDIR/lib:$LD_LIBRARY_PATH

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
elif [[ $(ls -l | wc -l) = 3 ]]; then
    #config_000 and config_001 exist
    cp -fr $DIR/configs/config_001.hpp $DIR/configs/config_000.hpp
    config="config_001.hpp"
elif [[ $(ls -l | wc -l) > 3 ]]; then
    cd $DIR/configs/
    configs=( "config_"*.hpp )
    echo ""
    echo "${bold}Please, choose your configuration:${normal}"
    echo ""
    PS3=""
    select config in "${configs[@]:1}"; do
        if [[ -z $config ]]; then
            echo "" >&/dev/null
        else
            break
        fi
    done
    # copy selected config as config_000.hpp
    cp -fr $DIR/configs/$config $DIR/configs/config_000.hpp
fi

#change directory
#if ! [ -d "$DIR" ]; then
#    echo ""
#    echo "$DIR is not a valid --project name!"
#    echo ""
#    exit
#else
    echo ""
    echo "${bold}Changing directory:${normal}"
    echo ""
    echo "cd $DIR"
    echo ""
    cd $DIR

    #create build_dir
    if ! [ -d "$APP_BUILD_DIR" ]; then
        mkdir $APP_BUILD_DIR
    fi

    # copy and compile
    echo "${bold}Compiling main.c:${normal}"
    echo ""
    sleep 1
    echo "mpicc $DIR/src/main.cpp -I $MPICH_WORKDIR/include -L $MPICH_WORKDIR/lib -o $APP_BUILD_DIR/main"
    echo ""
    #cp $CLI_WORKDIR/templates/mpi/hello_world/src/mpi_hello.c $WORKDIR
    #mpicc $DIR/src/main.c -I $MPICH_WORKDIR/include -L $MPICH_WORKDIR/lib -o $APP_BUILD_DIR/main
    mpicc $DIR/src/main.cpp -I $MPICH_WORKDIR/include -L $MPICH_WORKDIR/lib -o $APP_BUILD_DIR/main
  
#fi