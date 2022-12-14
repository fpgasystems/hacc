#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# constants
WORKDIR="/home/$USER"
CLI_WORKDIR="/opt/cli"
MPICH_VERSION="4.0.2"
MPICH_WORKDIR="/opt/mpich/mpich-$MPICH_VERSION-install"

echo ""
#echo "${bold}mpich-$MPICH_VERSION${normal}"
#echo ""

# get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

# inputs
flags=$@

# replace p by n
flags=${flags/p/n}

# set default
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

# setup keys
eval "$CLI_WORKDIR/common/ssh_key_add"

# set environment
PATH=$MPICH_WORKDIR/bin:$PATH
LD_LIBRARY_PATH=$MPICH_WORKDIR/lib:$LD_LIBRARY_PATH

# copy and compile
echo "${bold}Compiling mpi_hello.c:${normal}"
echo ""
sleep 1
echo "mpicc $WORKDIR/mpi_hello.c -I $MPICH_WORKDIR/include -L $MPICH_WORKDIR/lib -o $WORKDIR/mpi_hello"
echo ""
cp $CLI_WORKDIR/validate/mpi_hello.c $WORKDIR
mpicc $WORKDIR/mpi_hello.c -I $MPICH_WORKDIR/include -L $MPICH_WORKDIR/lib -o $WORKDIR/mpi_hello

# create hosts file
echo "${bold}Creating hosts file:${normal}"
echo ""
sleep 1

servers=$(sudo /opt/cli/common/get_booking_system_servers_list | tail -n +2) #get booked machines
echo ""
servers=($servers) #convert string to an array

cd $WORKDIR
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

# run
n=$(($j*$PROCESSES_PER_HOST))
echo "${bold}Running openMPI:${normal}"
echo ""
echo "mpirun -n $n -f $WORKDIR/hosts -iface $mellanox_name $WORKDIR/mpi_hello"
echo ""
mpirun -n $n -f $WORKDIR/hosts -iface $mellanox_name $WORKDIR/mpi_hello

# remove files
rm $WORKDIR/hosts
rm $WORKDIR/mpi_hello*

echo ""
