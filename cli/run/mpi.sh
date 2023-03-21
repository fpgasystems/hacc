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
echo "${bold}sgutil run mpi${normal}"

#check if workflow exists
if ! [ -d "/home/$username/my_projects/mpi/" ]; then
    echo ""
    echo "You must build your project first! Please, use sgutil build mpi"
    echo ""
    exit
fi

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
        /opt/cli/sgutil run mpi -h
        exit
    fi
fi

# set environment
PATH=$MPICH_WORKDIR/bin:$PATH
LD_LIBRARY_PATH=$MPICH_WORKDIR/lib:$LD_LIBRARY_PATH

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

#check for build directory
if ! [ -d "$APP_BUILD_DIR" ]; then
    echo ""
    echo "You must generate your application first! Please, use sgutil build mpi"
    echo ""
    exit
fi

# setup keys
echo ""
eval "$CLI_WORKDIR/common/ssh_key_add"

#create or select a configuration
cd $DIR/configs/
if [[ $(ls -l | wc -l) = 2 ]]; then
    #only config_000 exists and we create config_001
    #we compile create_config (in case there were changes)
    #cd $DIR/src
    #g++ -std=c++17 create_config.cpp -o ../create_config >&/dev/null
    #cd $DIR
    #./create_config
    #cp -fr $DIR/configs/config_001.hpp $DIR/configs/config_000.hpp
    config=""
    echo ""
elif [[ $(ls -l | wc -l) = 3 ]]; then
    #config_000 and config_001 exist
    cp -fr $DIR/configs/config_001.hpp $DIR/configs/config_000.hpp
    config="config_001.hpp"
    echo ""
elif [[ $(ls -l | wc -l) > 3 ]]; then
    cd $DIR/configs/
    configs=( "config_"*.hpp )
    echo ""
    echo "${bold}Please, choose your configuration:${normal}"
    echo ""
    PS3=""
    select config in "${configs[@]:1}"; do # with :1 we avoid config_000.hpp and then config_shell.hpp
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
echo "${bold}Changing directory:${normal}"
echo ""
echo "cd $DIR"
echo ""
cd $DIR

#get N_MAX (MAX PROCESSES_PER_HOST)
line=$(grep -n "N_MAX" $DIR/configs/config_000.hpp)
#find equal (=)
idx=$(sed 's/ /\n/g' <<< "$line" | sed -n "/=/=")
#get index
value_idx=$(($idx+1))
#get data
N_MAX=$(echo $line | awk -v i=$value_idx '{ print $i }' | sed 's/;//' )

#get number of servers and processes
num_servers=0
num_proc=0
shopt -s lastpipe
while read p; do 
    aux=$(echo $p | sed 's/.*://')
    if [[ $aux -gt $N_MAX ]]; then
        echo ""
        echo "The number of processes for (at least) one of the hosts exceeds N_MAX=$N_MAX!"
        echo ""
        exit
    fi
    ((num_servers=num_servers+1))
    ((num_proc=num_proc+aux))
done <hosts

#get interface name
mellanox_name=$(nmcli dev | grep mellanox-0 | awk '{print $1}')
    
#run
echo "${bold}Running openMPI:${normal}"
echo ""
echo "mpirun -n $num_proc -f $DIR/hosts -iface $mellanox_name $APP_BUILD_DIR/main"
echo ""
mpirun -n $num_proc -f $DIR/hosts -iface $mellanox_name $APP_BUILD_DIR/main

echo ""