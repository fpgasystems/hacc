#!/bin/bash

DIR=$1

#get N_REGIONS
line=$(grep -n "N_REGIONS" $DIR/configs/config_shell.hpp)
#find equal (=)
idx=$(sed 's/ /\n/g' <<< "$line" | sed -n "/=/=")
#get index
value_idx=$(($idx+1))
#get data
N_REGIONS=$(echo $line | awk -v i=$value_idx '{ print $i }' | sed 's/;//' )

#applu fpga_chmod to N_REGIONS
for (( i = 0; i < $N_REGIONS; i++ ))
do 
    sudo /opt/cli/program/fpga_chmod $i
done