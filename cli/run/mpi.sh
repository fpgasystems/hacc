#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="$(dirname "$(dirname "$0")")"
MPICH_PATH=$($CLI_PATH/common/get_constant $CLI_PATH MPICH_PATH)
MY_PROJECTS_PATH=$($CLI_PATH/common/get_constant $CLI_PATH MY_PROJECTS_PATH)
WORKFLOW="mpi"

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#get MPICH version
mpich_version=($(find "$MPICH_PATH" -mindepth 1 -maxdepth 1 -type d -name "*-install" -exec basename {} \;))

#check on valid MPICH version (only one should be installed)
if [ ! -d "$MPICH_PATH/$mpich_version" ]; then
    echo ""
    echo "Please, install a valid MPICH version for ${bold}$hostname!${normal}"
    echo ""
    exit 1
fi

#check if workflow exists
if ! [ -d "$MY_PROJECTS_PATH/$WORKFLOW/" ]; then
    echo ""
    echo "You must build your project first! Please, use sgutil build mpi"
    echo ""
    exit
fi

#set environment
PATH=$MPICH_PATH/$mpich_version/bin:$PATH
LD_LIBRARY_PATH=$MPICH_PATH/$mpich_version/lib:$LD_LIBRARY_PATH

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
    result=$($CLI_PATH/common/project_dialog $MY_PROJECTS_PATH/$WORKFLOW)
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
    if [ "$project_found" = "1" ] && ([ "$project_name" = "" ] || [ ! -d "$MY_PROJECTS_PATH/$WORKFLOW/$project_name" ]); then 
        $CLI_PATH/sgutil run $WORKFLOW -h
        exit
    fi
    #header (2/2)
    echo ""
    echo "${bold}sgutil run $WORKFLOW${normal}"
    #project_dialog (forgotten mandatory 1)
    if [[ $project_found = "0" ]]; then
        #echo ""
        echo "${bold}Please, choose your $WORKFLOW project:${normal}"
        echo ""
        result=$($CLI_PATH/common/project_dialog $MY_PROJECTS_PATH/$WORKFLOW)
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
DIR="$MY_PROJECTS_PATH/$WORKFLOW/$project_name"

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

# setup keys
echo ""
eval "$CLI_PATH/common/ssh_key_add"

#change directory
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
done <$DIR/hosts

#get interface name
mellanox_name=$(nmcli dev | grep mellanox-0 | awk '{print $1}')
    
#run
echo "${bold}Running MPI:${normal}"
echo ""
echo "mpirun -n $num_proc -f $DIR/hosts -iface $mellanox_name $APP_BUILD_DIR/main"
echo ""
mpirun -n $num_proc -f $DIR/hosts -iface $mellanox_name $APP_BUILD_DIR/main

echo ""