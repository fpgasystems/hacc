#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="$(dirname "$(dirname "$0")")"

#inputs
DIR=$1

#get N_REGIONS
line=$(grep -n "N_REGIONS" $DIR/configs/config_shell.hpp)
#find equal (=)
idx=$(sed 's/ /\n/g' <<< "$line" | sed -n "/=/=")
#get index
value_idx=$(($idx+1))
#get data
N_REGIONS=$(echo $line | awk -v i=$value_idx '{ print $i }' | sed 's/;//' )

#apply fpga_chmod to N_REGIONS
echo "${bold}Enabling vFPGA regions:${normal}"
echo ""
$CLI_PATH/program/enable_regions $N_REGIONS