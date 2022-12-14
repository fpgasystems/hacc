#!/bin/bash

#Example: source hot_plug_boot alveo-u250-01

bold=$(tput bold)
normal=$(tput sgr0)

echo ""
echo "${bold}pci_hot_plug${normal}"
echo ""

#constants
LINK_CONTROL_OFFSET=10

#inputs
hostname=$1

#hot_plug_boot
cont="1"
err_msg=""
upstream_port=""
root_port=""
LinkCtl=""
if [ "$#" -ne 1 ]; then
    cont="0"
    err_msg="$0: exactly 1 argument expected. Example: source hot_plug_boot alveo-u250-01"
elif [ "$hostname" = "alveo-u250-01" ]; then
	upstream_port="3b:00.0"
	root_port="3a:00.0"
	LinkCtl="90"
elif [ "$hostname" = "alveo-u250-02" ]; then
    upstream_port="af:00.0"
	root_port="ae:00.0"
	LinkCtl="90"
elif [ "$hostname" = "alveo-u250-03" ]; then
    #upstream_port="3b:00.0"
	#root_port="3a:00.0"
	#LinkCtl="90"
	upstream_port="06:00.0"
	root_port="00:02.4"
	LinkCtl="54"
elif [ "$hostname" = "alveo-u250-04" ]; then
    upstream_port="af:00.0"
	root_port="ae:00.0"
	LinkCtl="90"
elif [ "$hostname" = "alveo-u250-05" ]; then
    echo "alveo-u250-05"
elif [ "$hostname" = "alveo-u250-06" ]; then
    echo "alveo-u250-06"
elif [ "$hostname" = "alveo-u280-01" ]; then
    echo "alveo-u280-01"
elif [ "$hostname" = "alveo-u280-02" ]; then
    echo "alveo-u280-02"
elif [ "$hostname" = "alveo-u280-03" ]; then
    echo "alveo-u280-03"
elif [ "$hostname" = "alveo-u280-04" ]; then
    echo "alveo-u280-04"
elif [ "$hostname" = "alveo-u50d-01" ] || [ "$hostname" = "alveo-u50d-02" ] || [ "$hostname" = "alveo-u50d-03" ] || [ "$hostname" = "alveo-u50d-04" ]; then
    upstream_port="02:00.0"
	root_port="00:01.1"
	LinkCtl="58"
elif [ "$hostname" = "alveo-u55c-01" ] || [ "$hostname" = "alveo-u55c-02" ] || [ "$hostname" = "alveo-u55c-03" ] || [ "$hostname" = "alveo-u55c-04" ] || [ "$hostname" = "alveo-u55c-05" ] || [ "$hostname" = "alveo-u55c-06" ] || [ "$hostname" = "alveo-u55c-07" ] || [ "$hostname" = "alveo-u55c-08" ] || [ "$hostname" = "alveo-u55c-09" ] || [ "$hostname" = "alveo-u55c-10" ]; then
    upstream_port="c4:00.0"
	root_port="c0:01.1"
	LinkCtl="58"
else
    cont="0"
    err_msg="$1: unvalid host_name."
fi

if [ "$cont" = "0" ]; then
    echo $err_msg
else
    echo $hostname
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

fi

echo ""