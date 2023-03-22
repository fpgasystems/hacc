#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# constants
SERVERADDR="localhost"
EMAIL="jmoyapaya@ethz.ch"

#get username
username=$USER

# get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

# inputs
read -a flags <<< "$@"

#check for number of pci functions
if [[ $(lspci | grep Xilinx | wc -l) = 2 ]]; then
    #the server is already in Vitis workflow
    echo ""
    exit
fi

echo ""
echo "${bold}sgutil program reboot${normal}"

#check for vivado_developers
member=$(/opt/cli/common/is_member $username vivado_developers)
if [ "$member" = "false" ]; then
    echo ""
    echo "Sorry, ${bold}$username!${normal} You are not granted to use this command."
    echo ""
    exit
fi

echo ""
echo "The server will reboot (warm boot) in 3 seconds."
sleep 1
echo "The server will reboot (warm boot) in 2 seconds.."
sleep 1
echo "The server will reboot (warm boot) in 1 seconds..."
sleep 1
echo ""
echo "See you later, ${bold}$username!${normal}"
echo ""

sudo reboot