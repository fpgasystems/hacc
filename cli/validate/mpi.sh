#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
MPICH_VERSION="4.0.2"
MPICH_WORKDIR="/opt/mpich/mpich-$MPICH_VERSION-install"
WORKFLOW="mpi"

#get username
username=$USER

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#set environment
PATH=$MPICH_WORKDIR/bin:$PATH
LD_LIBRARY_PATH=$MPICH_WORKDIR/lib:$LD_LIBRARY_PATH

#inputs
flags=$@

#replace p by n
flags=${flags/p/n}

echo ""
echo "${bold}sgutil validate $WORKFLOW${normal}"
echo ""

#create mpi directory (we do not know if sgutil new mpi has been run)
DIR="/home/$username/my_projects/$WORKFLOW"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

#set default
if [ "$flags" = "" ]; then
    flags="-n 2"
    PROCESSES_PER_HOST=2
else

    read -a aux_flags <<< "$flags"
    read -a search_flags <<< "-n --processes"
    
    START=0
    for (( i=$START; i<${#aux_flags[@]}; i++ ))
    do
	    if [[ " ${search_flags[*]} " =~ " ${aux_flags[$i]} " ]]; then
	        i=$(($i+1))
	        PROCESSES_PER_HOST="${aux_flags[$i]} "
            break
	    fi
    done
fi

#define directories (1)
VALIDATION_DIR="/home/$USER/my_projects/$WORKFLOW/validate_mpi"

#create temporal validation dir
if ! [ -d "$VALIDATION_DIR" ]; then
    mkdir ${VALIDATION_DIR}
    mkdir $VALIDATION_DIR/build_dir
fi

#setup keys
eval "$CLI_PATH/common/ssh_key_add"

#copy and compile
cp -rf /opt/cli/templates/$WORKFLOW/hello_world/* $VALIDATION_DIR

#create config
cp $VALIDATION_DIR/configs/config_000.hpp $VALIDATION_DIR/configs/config_001.hpp

#build (compile)
/opt/cli/build/$WORKFLOW -p validate_mpi

# create hosts file
echo "${bold}Creating hosts file:${normal}"
echo ""
sleep 1

servers=$(sudo /opt/cli/common/get_booking_system_servers_list | tail -n +2) #get booked machines
echo ""
servers=($servers) #convert string to an array

rm $VALIDATION_DIR/hosts

cd $VALIDATION_DIR
touch hosts
j=0
for i in "${servers[@]}"
do
    if [ "$i" != "$hostname" ]; then
        echo "$i-mellanox-0:$PROCESSES_PER_HOST" >> hosts
        ((j=j+1))
    fi
done
cat hosts
echo ""

#get interface name
mellanox_name=$(nmcli dev | grep mellanox-0 | awk '{print $1}')

#run
n=$(($j*$PROCESSES_PER_HOST))
echo "${bold}Running MPI:${normal}"
echo ""
echo "mpirun -n $n -f $VALIDATION_DIR/hosts -iface $mellanox_name $VALIDATION_DIR/build_dir/main"
echo ""
mpirun -n $n -f $VALIDATION_DIR/hosts -iface $mellanox_name $VALIDATION_DIR/build_dir/main

#remove temporal validation files
rm -rf $VALIDATION_DIR

echo ""