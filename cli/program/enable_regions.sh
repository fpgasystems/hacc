#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="$(dirname "$(dirname "$0")")"

#inputs
regions_number=$1

for (( i = 0; i < $regions_number; i++ ))
do 
    echo $i
    sudo $CLI_PATH/program/fpga_chmod $i
done