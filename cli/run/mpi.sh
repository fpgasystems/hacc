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

#check on flags (before: flags cannot be empty)
project_found="0"
if [ "$flags" = "" ]; then
    #/opt/cli/sgutil build mpi -h
    #exit
    #no flags: start dialog


    project_found="1"
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
    # check if project exists
    DIR="/home/$username/my_projects/mpi/$project_name"
    if ! [ -d "$DIR" ]; then
        echo ""
        echo "$DIR is not a valid --project name!"
        echo ""
        exit
    fi
fi

# setup keys
eval "$CLI_WORKDIR/common/ssh_key_add"

# set environment
PATH=$MPICH_WORKDIR/bin:$PATH
LD_LIBRARY_PATH=$MPICH_WORKDIR/lib:$LD_LIBRARY_PATH

echo ""
echo "${bold}sgutil build mpi${normal}"

#create or select a configuration
cd $DIR/configs/
if [[ $(ls -l | wc -l) = 2 ]]; then
    #only config_000 exists and we create config_001
    #we compile create_config (in case there were changes)
    cd $DIR/src
    g++ -std=c++17 create_config.cpp -o ../create_config >&/dev/null
    cd $DIR
    ./create_config
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

#define directories
DIR="/home/$username/my_projects/mpi/$project_name"
APP_BUILD_DIR="/home/$username/my_projects/mpi/$project_name/build_dir"

#change directory
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

    #get number of servers and processes
    #num_servers=$(cat hosts | wc -l)
    num_servers=0
    num_proc=0
    while read p; do
        #echo "$p"
        #eval "echo $p | sed 's/.*://'" 
        aux=$(echo $p | sed 's/.*://')
        #echo $aux
        ((num_servers=num_servers+1))
        ((num_proc=num_proc+aux))
    done <hosts

    echo $num_servers
    echo $num_proc

    exit

    #get N_MAX (MAX PROCESSES_PER_HOST)
    line=$(grep -n "N_MAX" $DIR/configs/config_000.hpp)
    #find equal (=)
    idx=$(sed 's/ /\n/g' <<< "$line" | sed -n "/=/=")
    #get index
    value_idx=$(($idx+1))
    #get data
    N_MAX=$(echo $line | awk -v i=$value_idx '{ print $i }' | sed 's/;//' )


    



    n=$(($j*$PROCESSES_PER_HOST))
    
    #run
    echo "${bold}Running openMPI:${normal}"
    echo ""
    echo "mpirun -n $n -f $VALIDATION_DIR/hosts -iface $mellanox_name $VALIDATION_DIR/build_dir/main"
    echo ""
    mpirun -n $n -f $VALIDATION_DIR/hosts -iface $mellanox_name $VALIDATION_DIR/build_dir/main

fi

echo ""