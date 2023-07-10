#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="$(dirname "$(dirname "$0")")"

# create key
echo "${bold}Creating id_rsa private and public keys:${normal}"
FILE="/home/$USER/.ssh/id_rsa.pub"
if ! [ -f "$FILE" ]; then
    #create key
	echo ""
    eval "ssh-keygen"

    #remove from known hosts
    #ssh-keygen -R $hostname

    #add id_rsa.pub to authorized_keys 
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

    echo ""
    echo "Done!"
    echo ""
else
    echo "The key already exists."
    echo ""
fi

# get booked machines
servers=$(sudo $CLI_PATH/common/get_booking_system_servers_list | tail -n +2)
echo ""

# convert string to an array
servers=($servers)

## add SSH (mellanox-0) fingerprints to local known_hosts
echo "${bold}Adding fingerprints to known_hosts:${normal}"
echo ""

#alveo-build-01
ssh-keygen -R alveo-build-01-mellanox-0
ssh-keyscan -H alveo-build-01-mellanox-0 >> ~/.ssh/known_hosts #> /dev/null

#booked servers
for i in "${servers[@]}"
do
    echo ""
    ssh-keygen -R $i-mellanox-0
    ssh-keyscan -H $i-mellanox-0 >> ~/.ssh/known_hosts #> /dev/null
    sleep 2  
done
echo ""
