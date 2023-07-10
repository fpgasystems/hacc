#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="$(dirname "$(dirname "$0")")"

echo ""

#setup keys
eval "$CLI_PATH/common/ssh_key_add"

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#inputs
flags=$@

#replace p by P
flags=${flags/p/P}

#set default
udp_server=""
if [ "$flags" = "" ]; then
    flags="-P 4"
elif [ "$flags" = "-u" ]; then
    flags="-P 4 -u"
    udp_server=" -u"
fi

#start iperf server on local machine
echo "${bold}Starting iperf server:${normal}"
echo ""
echo "iperf -s -B $hostname-mellanox-0 -D $udp_server"
echo ""
iperf -s -B $hostname-mellanox-0 -D $udp_server
echo ""

#get booked machines
servers=$(sudo $CLI_PATH/common/get_booking_system_servers_list | tail -n +2)
echo ""

#convert string to an array
servers=($servers)

#running iperf on remote machines
echo "${bold}Running iperf on remote server/s:${normal}"
echo ""
for i in "${servers[@]}"
do
    if [ "$i" != "$hostname" ]; then
        echo "iperf -c $hostname-mellanox-0 -B $i-mellanox-0 $flags"
        echo ""
        ssh $i iperf -c $hostname-mellanox-0 -B $i-mellanox-0 $flags
        echo ""
    fi
done