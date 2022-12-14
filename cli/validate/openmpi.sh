#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

echo ""
echo "${bold}openmpi${normal}"
echo ""

# constants
CLI_WORKDIR="/opt/cli"
WORKDIR="/home/$USER"
PROCESSES_PER_HOST=2

# setup keys
eval "$CLI_WORKDIR/common/ssh_key_add"

# copy and compile
echo "${bold}Compiling mpi_hello.c:${normal}"
echo ""
sleep 1
echo "mpicc mpi_hello.c -o mpi_hello"
echo ""
cp $CLI_WORKDIR/validate/mpi_hello.c $WORKDIR
mpicc mpi_hello.c -o mpi_hello

# create hosts file
echo "${bold}Creating hosts file:${normal}"
echo ""
sleep 1
declare -a arr=("alveo-u50d-01" "alveo-build-01") # works
#declare -a arr=("alveo-u50d-01" "alveo-u50d-02") # fails
#declare -a arr=("alveo-u50d-01" "alveo-build-01" "alveo-u50d-02") # fails
cd $WORKDIR
touch hosts
j=0
for i in "${arr[@]}"
do
    echo "$i-mellanox-0 slots=$PROCESSES_PER_HOST" >> hosts
    ((j=j+1))
done
cat hosts
echo ""

# run
np=$(($j*$PROCESSES_PER_HOST))
echo "${bold}Running openMPI:${normal}"
echo ""
echo "mpirun --mca btl_tcp_if_include 10.253.74.0/24 --hostfile hosts --np $np ./mpi_hello"
mpirun --mca btl_tcp_if_include 10.253.74.0/24 --hostfile hosts --np $np ./mpi_hello

# remove files
rm hosts
rm mpi_hello*

echo ""