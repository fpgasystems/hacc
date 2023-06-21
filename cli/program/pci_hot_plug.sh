#!/bin/bash

#Example: source pci_hot_plug c4:00.0 c0:01.1 58

bold=$(tput bold)
normal=$(tput sgr0)

#constants
LINK_CONTROL_OFFSET=10

#check on arguments
if [ "$#" -ne 3 ]; then
    err_msg="$0: exactly 3 arguments expected. Example: source pci_hot_plug c4:00.0 c0:01.1 58"
fi

#inputs
read -a inputs <<< "$@"

#get revert_devices (number of devices to be reverted, i.e. with only one BDF)
revert_devices=${inputs[@]:0:1}

#get upstream_ports, root_ports, LinkCtls
aux=2
#upstream_ports
vector=0
a=$((aux + vector * revert_devices))
b=$((a + revert_devices - 1))
upstream_ports=$(echo "${inputs[@]}" | cut -d' ' -f$a-$b)
#root_ports
vector=1
a=$((aux + vector * revert_devices))
b=$((a + revert_devices - 1))
root_ports=$(echo "${inputs[@]}" | cut -d' ' -f$a-$b)
#LinkCtls
vector=2
a=$((aux + vector * revert_devices))
b=$((a + revert_devices - 1))
LinkCtls=$(echo "${inputs[@]}" | cut -d' ' -f$a-$b)

#populate separate arrays using the read command
read -ra upstream_ports <<< "$upstream_ports"
read -ra root_ports <<< "$root_ports"
read -ra LinkCtls <<< "$LinkCtls"

echo ""
echo "${bold}pci_hot_plug${normal}"
echo ""

echo "${bold}Getting upstream ports:${normal}"
sleep 1
for ((i=0; i<${#upstream_ports[@]}; i++)); do
    echo "upstream_port ($i) = ${upstream_ports[i]}" 
done
sleep 1
echo ""

echo "${bold}Getting root ports:${normal}"
sleep 1
for ((i=0; i<${#root_ports[@]}; i++)); do
    echo "root_port ($i) = ${root_ports[i]}"
done
sleep 1
echo ""

echo "${bold}Getting LnkCtl capabilities:${normal}"
sleep 1
for ((i=0; i<${#LinkCtls[@]}; i++)); do
    echo "LinkCtl ($i) = ${LinkCtls[i]}"
done
sleep 1
echo ""

echo "${bold}Getting control addresses:${normal}"
sleep 1
link_control_access=()
for ((i=0; i<${#LinkCtls[@]}; i++)); do
    LinkCtl="${LinkCtls[i]}"
    link_control_access+=($(printf "%X" $((0x$LinkCtl + 0x$LINK_CONTROL_OFFSET))))
    echo "link_control_access ($i) = ${link_control_access[i]}"
done
sleep 1
echo ""

echo "${bold}Removing and re-scanning root port:${normal}"
for ((i=0; i<${#root_ports[@]}; i++)); do
    root_port="${root_ports[i]}"
    root_port_bus=${root_port:0:2}
    root_port_device=${root_port:3:2}
    root_port_function=${root_port:6:1}
    echo "sudo echo 1 > /sys/bus/pci/devices/0000\:$root_port_bus\:$root_port_device.$root_port_function/remove"
    eval "sudo echo 1 > /sys/bus/pci/devices/0000\:$root_port_bus\:$root_port_device.$root_port_function/remove"
    sleep 1
done
echo "sudo echo 1 > /sys/bus/pci/rescan"
eval "sudo echo 1 > /sys/bus/pci/rescan"

echo ""

echo "${bold}Removing upstream device:${normal}"
for ((i=0; i<${#upstream_ports[@]}; i++)); do
    upstream_port="${upstream_ports[i]}"
    upstream_port_bus=${upstream_port:0:2}
    upstream_port_device=${upstream_port:3:2}
    upstream_port_function=${upstream_port:6:1}
    echo "sudo echo 1 > /sys/bus/pci/devices/0000\:$upstream_port_bus\:$upstream_port_device.$upstream_port_function/remove"
    eval "sudo echo 1 > /sys/bus/pci/devices/0000\:$upstream_port_bus\:$upstream_port_device.$upstream_port_function/remove"
    sleep 1
done

echo ""

echo "${bold}Disabling root:${normal}"
for ((i=0; i<${#root_ports[@]}; i++)); do
    root_port="${root_ports[i]}"
    link_control_access_i="${link_control_access[i]}"
    echo "sudo setpci -s $root_port $link_control_access_i.b=70"
    eval "sudo setpci -s $root_port $link_control_access.b=70"
    sleep 1
done
echo ""

echo "${bold}Enabling link:${normal}"
for ((i=0; i<${#root_ports[@]}; i++)); do
    root_port="${root_ports[i]}"
    link_control_access_i="${link_control_access[i]}"
    echo "sudo setpci -s $root_port $link_control_access.b=60"
    eval "sudo setpci -s $root_port $link_control_access.b=60"
    sleep 1
done
echo ""

echo "${bold}PCI rescanning:${normal}"
sleep 1
echo "sudo echo 1 > /sys/bus/pci/rescan"
eval "sudo echo 1 > /sys/bus/pci/rescan"

echo ""

echo "${bold}Removing and re-scanning root port:${normal}"
for ((i=0; i<${#root_ports[@]}; i++)); do
    root_port="${root_ports[i]}"
    root_port_bus=${root_port:0:2}
    root_port_device=${root_port:3:2}
    root_port_function=${root_port:6:1}
    sleep 1
    echo "sudo echo 1 > /sys/bus/pci/devices/0000\:$root_port_bus\:$root_port_device.$root_port_function/remove"
    eval "sudo echo 1 > /sys/bus/pci/devices/0000\:$root_port_bus\:$root_port_device.$root_port_function/remove"
    sleep 1
done
echo "sudo echo 1 > /sys/bus/pci/rescan"
eval "sudo echo 1 > /sys/bus/pci/rescan"

echo ""