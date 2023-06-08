#!/bin/bash

#Example: source pci_hot_plug c4:00.0 c0:01.1 58

bold=$(tput bold)
normal=$(tput sgr0)

#constants
LINK_CONTROL_OFFSET=10

#inputs
upstream_port=$1 
root_port=$2 
LinkCtl=$3 

#check on arguments
if [ "$#" -ne 3 ]; then
    err_msg="$0: exactly 3 arguments expected. Example: source pci_hot_plug c4:00.0 c0:01.1 58"
fi

echo ""
echo "${bold}pci_hot_plug${normal}"

echo ""

echo "${bold}Getting upstream and root ports:${normal}"
sleep 1
echo "upstream_port = $upstream_port"
sleep 1
echo "root_port = $root_port"
sleep 1

echo ""

echo "${bold}Getting LnkCtl and link control address:${normal}"
sleep 1
echo "LinkCtl = $LinkCtl"
sleep 1
link_control_access=$(printf "%X" $((0x$LinkCtl+0x$LINK_CONTROL_OFFSET))) #printf "link_control_acccess = %X\n" $((0x$LinkCtl+0x$LINK_CONTROL_OFFSET))
echo "link_control_access = $link_control_access"

echo ""

echo "${bold}Removing and re-scanning root port:${normal}"
root_port_bus=${root_port:0:2}
root_port_device=${root_port:3:2}
root_port_function=${root_port:6:1}
sleep 1
echo "sudo echo 1 > /sys/bus/pci/devices/0000\:$root_port_bus\:$root_port_device.$root_port_function/remove"
eval "sudo echo 1 > /sys/bus/pci/devices/0000\:$root_port_bus\:$root_port_device.$root_port_function/remove"
sleep 1
echo "sudo echo 1 > /sys/bus/pci/rescan"
eval "sudo echo 1 > /sys/bus/pci/rescan"

echo ""

echo "${bold}Removing upstream device:${normal}"
upstream_port_bus=${upstream_port:0:2}
upstream_port_device=${upstream_port:3:2}
upstream_port_function=${upstream_port:6:1}
sleep 1
echo "sudo echo 1 > /sys/bus/pci/devices/0000\:$upstream_port_bus\:$upstream_port_device.$upstream_port_function/remove"
eval "sudo echo 1 > /sys/bus/pci/devices/0000\:$upstream_port_bus\:$upstream_port_device.$upstream_port_function/remove"

echo ""

echo "${bold}Disabling root:${normal}"
sleep 1
echo "sudo setpci -s $root_port $link_control_access.b=70"
eval "sudo setpci -s $root_port $link_control_access.b=70"

echo ""

echo "${bold}Enabling link:${normal}"
sleep 1
echo "sudo setpci -s $root_port $link_control_access.b=60"
eval "sudo setpci -s $root_port $link_control_access.b=60"

echo ""

echo "${bold}PCI rescanning:${normal}"
sleep 1
echo "sudo echo 1 > /sys/bus/pci/rescan"
eval "sudo echo 1 > /sys/bus/pci/rescan"

echo ""

echo "${bold}Removing and re-scanning root port:${normal}"
sleep 1
echo "sudo echo 1 > /sys/bus/pci/devices/0000\:$root_port_bus\:$root_port_device.$root_port_function/remove"
eval "sudo echo 1 > /sys/bus/pci/devices/0000\:$root_port_bus\:$root_port_device.$root_port_function/remove"
sleep 1
echo "sudo echo 1 > /sys/bus/pci/rescan"
eval "sudo echo 1 > /sys/bus/pci/rescan"

echo ""