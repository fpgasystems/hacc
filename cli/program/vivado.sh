#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="$(dirname "$(dirname "$0")")"
LOCAL_PATH=$($CLI_PATH/common/get_constant $CLI_PATH LOCAL_PATH)
XILINX_TOOLS_PATH=$($CLI_PATH/common/get_constant $CLI_PATH XILINX_TOOLS_PATH)
VIVADO_PATH="$XILINX_TOOLS_PATH/Vivado"
VIVADO_DEVICES_MAX=$(cat $CLI_PATH/constants/VIVADO_DEVICES_MAX)
DEVICES_LIST="$CLI_PATH/devices_acap_fpga"
SERVERADDR="localhost"

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#get email
email=$($CLI_PATH/common/get_email)

#check on ACAP or FPGA servers (server must have at least one ACAP or one FPGA)
acap=$($CLI_PATH/common/is_acap $CLI_PATH $hostname)
fpga=$($CLI_PATH/common/is_fpga $CLI_PATH $hostname)
if [ "$acap" = "0" ] && [ "$fpga" = "0" ]; then
    echo ""
    echo "Sorry, this command is not available on ${bold}$hostname!${normal}"
    echo ""
    exit
fi

#get Vivado version
vivado_version=$(find "$VIVADO_PATH" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)

#check on valid Vivado version (using $XILINX_VIVADO is not possible)
if [ ! -d $VIVADO_PATH/$vivado_version ]; then
    echo ""
    echo "Please, source a valid Vivado version for ${bold}$hostname!${normal}"
    echo ""
    exit 1
fi

#check on DEVICES_LIST
source "$CLI_PATH/common/device_list_check" "$DEVICES_LIST"

#get number of fpga and acap devices present
MAX_DEVICES=$(grep -E "fpga|acap" $DEVICES_LIST | wc -l)

#check on multiple devices
multiple_devices=$($CLI_PATH/common/get_multiple_devices $MAX_DEVICES)

#check on vivado_developers
member=$($CLI_PATH/common/is_member $USER vivado_developers)
if [ "$member" = "false" ]; then
    echo ""
    echo "Sorry, ${bold}$USER!${normal} You are not granted to use this command."
    echo ""
    exit
fi

#inputs
read -a flags <<< "$@"

#check on flags
device_found=""
device_index=""
if [ "$flags" = "" ]; then
    $CLI_PATH/sgutil program vivado -h
    exit
else
    #device_dialog_check
    result="$("$CLI_PATH/common/device_dialog_check" "${flags[@]}")"
    device_found=$(echo "$result" | sed -n '1p')
    device_index=$(echo "$result" | sed -n '2p')
    #forbidden combinations (1)
    if ([ "$device_found" = "1" ] && [ "$device_index" = "" ]) || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 1 ))) || ([ "$device_found" = "1" ] && ([[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 1 ]])); then
        $CLI_PATH/sgutil program vivado -h
        exit
    fi
    #device_dialog (forgotten mandatory)
    #if [[ $multiple_devices = "0" ]]; then
    #    device_found="1"
    #    device_index="1"
    #fi
    #bitstream_dialog_check
    result="$("$CLI_PATH/common/bitstream_dialog_check" "${flags[@]}")"
    bitstream_found=$(echo "$result" | sed -n '1p')
    bitstream_name=$(echo "$result" | sed -n '2p')
    #forbidden combinations (2)
    if [ "$bitstream_found" = "1" ] && ([ "$bitstream_name" = "" ] || [ ! -f "$bitstream_name" ] || [ "${bitstream_name##*.}" != "bit" ]); then
        $CLI_PATH/sgutil program vivado -h
        exit
    fi
    #driver_dialog_check
    result="$("$CLI_PATH/common/driver_dialog_check" "${flags[@]}")"
    driver_found=$(echo "$result" | sed -n '1p')
    driver_name=$(echo "$result" | sed -n '2p')
    #forbidden combinations (3)
    if [ "$driver_found" = "1" ] && ([ "$driver_name" = "" ] || [ ! -f "$driver_name" ] || [ "${driver_name##*.}" != "ko" ]); then
        $CLI_PATH/sgutil program vivado -h
        exit
    fi
    #forbidden combinations (4)
    if [ "$multiple_devices" = "1" ] && [ "$bitstream_found" = "1" ] && [ "$device_found" = "0" ]; then # this means bitstream always needs --device when multiple_devices
        $CLI_PATH/sgutil program vivado -h
        exit
    fi
    #forbidden combinations (5)
    if ([ "$bitstream_found" = "0" ] && [ "$driver_found" = "0" ]); then
        $CLI_PATH/sgutil program vivado -h
        exit
    fi
    #forbidden combinations (6)
    if ([ "$driver_found" = "1" ] && [ "$bitstream_found" = "0" ] && [ "$device_found" = "1" ]); then #the driver alone (without bitstream) does not need --device
        $CLI_PATH/sgutil program vivado -h
        exit
    fi
    #device values when there is only a device
    if [[ $multiple_devices = "0" ]]; then
        device_found="1"
        device_index="1"
    fi
    #check on VIVADO_DEVICES_MAX
    if [ "$device_found" = "1" ]; then
        vivado_devices=$($CLI_PATH/common/get_vivado_devices $CLI_PATH $MAX_DEVICES $device_index)
        if [ $vivado_devices -ge $((VIVADO_DEVICES_MAX)) ]; then
            echo ""
            echo "Sorry, you have reached the maximum number of devices in ${bold}Vivado workflow!${normal}"
            echo ""
            exit
        fi
    fi
fi

echo ""
echo "${bold}sgutil program vivado${normal}"

#program bitstream
if [[ $bitstream_found = "1" ]]; then
    #revert to xrt first if FPGA is already in baremetal (it is proven to be needed on non-virtualized environments)
    virtualized=$($CLI_PATH/common/is_virtualized $CLI_PATH $hostname)
    if [ "$virtualized" = "0" ]; then
        $CLI_PATH/program/revert -d $device_index
    fi

    #get serial number
    serial_number=$($CLI_PATH/get/get_fpga_device_param $device_index serial_number)

    #get device name
    device_name=$($CLI_PATH/get/get_fpga_device_param $device_index device_name)

    echo ""
	echo "${bold}Programming bitstream:${normal}"
    $VIVADO_PATH/$vivado_version/bin/vivado -nolog -nojournal -mode batch -source $CLI_PATH/program/flash_bitstream.tcl -tclargs $SERVERADDR $serial_number $device_name $bitstream_name

    #check for virtualized and apply pci_hot_plug (is always needed as we reverted first)
    if [ "$virtualized" = "1" ] && [[ $(lspci | grep Xilinx | wc -l) = 2 ]]; then
        echo ""
        echo "${bold}The server needs to warm boot to operate in Vivado workflow. For this purpose:${normal}"
        echo ""
        echo "    Use the ${bold}go to baremetal${normal} button on the booking system, or"
        echo "    Contact ${bold}$email${normal} for support."
        echo ""
        #send email
        echo "Subject: $USER requires to go to baremetal/warm boot ($hostname)" | sendmail $email
        exit
    elif [ "$virtualized" = "0" ]; then 
        #get device params
        upstream_port=$($CLI_PATH/get/get_fpga_device_param $device_index upstream_port)
        root_port=$($CLI_PATH/get/get_fpga_device_param $device_index root_port)
        LinkCtl=$($CLI_PATH/get/get_fpga_device_param $device_index LinkCtl)
        #hot plug boot
        sudo $CLI_PATH/program/pci_hot_plug 1 $upstream_port $root_port $LinkCtl
        #print
        bdf="${upstream_port%??}" #i.e., we transform 81:00.0 into 81:00
        lspci | grep Xilinx | grep $bdf
        echo ""
    fi
fi

#program driver
if [[ $driver_found = "1" ]]; then
    #we need to copy the driver to /local to avoid permission problems
	echo ""
    echo "${bold}Copying driver to $LOCAL_PATH:${normal}"
	echo ""
    echo "cp -f $driver_name $LOCAL_PATH"
    cp -f $driver_name $LOCAL_PATH

    #insert coyote driver
	echo ""
    echo "${bold}Inserting driver:${normal}"
	echo ""

    #get actual filename
    driver_name=$(basename "$driver_name")

    #we always remove and insert the driver
    echo "sudo rmmod $driver_name"
    sudo rmmod $driver_name
    sleep 1
    echo "sudo insmod $LOCAL_PATH/$driver_name"
    sudo insmod $LOCAL_PATH/$driver_name
    sleep 1
    echo ""
fi