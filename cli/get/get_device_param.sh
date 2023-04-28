#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants (id upstream_port root_port LinkCtl device_type device_name serial_number IP MAC)
ID_COLUMN=1
UPSTREAM_PORT_COLUMN=2
ROOT_PORT_COLUMN=3
LINKCTL_COLUMN=4
DEVICE_TYPE_COLUMN=5
DEVICE_NAME_COLUMN=6
SERIAL_NUMBER_COLUMN=7
IP_COLUMN=8
MAC_COLUMN=9

#inputs (./examine 0 root_port)
device_index=$1
parameter=$2

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#helper functions
get_column() {
  parameter=$1
  case "$parameter" in
    # id upstream_port root_port LinkCtl device_type device_name serial_number IP MAC  
    id)
      column=$ID_COLUMN
      ;;
    upstream_port)
      column=$UPSTREAM_PORT_COLUMN
      ;;
    root_port)
      column=$ROOT_PORT_COLUMN
      ;;
    LinkCtl)
      column=$LINKCTL_COLUMN
      ;;
    device_type)
      column=$DEVICE_TYPE_COLUMN
      ;;
    device_name)
      column=$DEVICE_NAME_COLUMN
      ;;
    serial_number)
      column=$SERIAL_NUMBER_COLUMN
      ;;
    IP)
      column=$IP_COLUMN
      ;;
    MAC)
      column=$MAC_COLUMN
      ;;
    *)
      echo "Unknown parameter $parameter."
      ;;
  esac
  echo $column
}

device_0=""
device_1=""
device_2=""
device_3=""
case "$hostname" in
    alveo-u55c-01)
        #device_0
        id="0"
        upstream_port="c4:00.0"
        root_port="c0:01.1"
        LinkCtl="58"
        device_type="fpga" 
        device_name="xcu280_u55c_0" 
        serial_number="XFL1QOQ1ATTYA"
        IP="10.253.74.66/10.253.74.66" 
        MAC="08:C0:EB:C6:3E:BA/08:C0:EB:C6:3E:BB"
        device_0="$id $upstream_port $root_port $LinkCtl $device_type $device_name $serial_number $IP $MAC"
        ;;
    hacc-box-01)
        #device_0
        id="0"
        upstream_port="a1:00.0"
        root_port="xx:xx.x"
        LinkCtl="xx"
        device_type="fpga" 
        device_name="xcu280_u55c_0" 
        serial_number="XFL1BE3ESRZ4A"
        IP="10.253.74.112/10.253.74.113" 
        MAC="00:0A:35:0F:5D:60/00:0A:35:0F:5D:64"
        device_0="$id $upstream_port $root_port $LinkCtl $device_type $device_name $serial_number $IP $MAC"
        #device_1
        id="1"
        upstream_port="81:00.0"
        root_port="xx:xx.x"
        LinkCtl="xx"
        device_type="fpga" 
        device_name="xcu280_u55c_0" 
        serial_number="XFL13BA4HVZYA"
        IP="10.253.74.114/10.253.74.115" 
        MAC="00:0A:35:0F:52:18/00:0A:35:0F:52:1C"
        device_1="$id $upstream_port $root_port $LinkCtl $device_type $device_name $serial_number $IP $MAC"
        #device_2
        id="2"
        upstream_port=""
        root_port="xx:xx.x"
        LinkCtl="xx"
        device_type="" 
        device_name="" 
        serial_number=""
        IP="" 
        MAC=""
        device_2="$id $upstream_port $root_port $LinkCtl $device_type $device_name $serial_number $IP $MAC"
        #device_3
        id="3"
        upstream_port=""
        root_port="xx:xx.x"
        LinkCtl="xx"
        device_type="" 
        device_name="" 
        serial_number=""
        IP="" 
        MAC=""
        device_3="$id $upstream_port $root_port $LinkCtl $device_type $device_name $serial_number $IP $MAC"
        ;;
    hacc-box-02)
        #device_0
        id="0"
        upstream_port=""
        root_port="xx:xx.x"
        LinkCtl="xx"
        device_type="" 
        device_name="" 
        serial_number=""
        IP="" 
        MAC=""
        device_0="$id $upstream_port $root_port $LinkCtl $device_type $device_name $serial_number $IP $MAC"
        #device_1
        id="1"
        upstream_port=""
        root_port="xx:xx.x"
        LinkCtl="xx"
        device_type="" 
        device_name="" 
        serial_number=""
        IP="" 
        MAC=""
        device_1="$id $upstream_port $root_port $LinkCtl $device_type $device_name $serial_number $IP $MAC"
        #device_2
        id="2"
        upstream_port=""
        root_port="xx:xx.x"
        LinkCtl="xx"
        device_type="" 
        device_name="" 
        serial_number=""
        IP="" 
        MAC=""
        device_2="$id $upstream_port $root_port $LinkCtl $device_type $device_name $serial_number $IP $MAC"
        #device_3
        id="3"
        upstream_port=""
        root_port="xx:xx.x"
        LinkCtl="xx"
        device_type="" 
        device_name="" 
        serial_number=""
        IP="" 
        MAC=""
        device_3="$id $upstream_port $root_port $LinkCtl $device_type $device_name $serial_number $IP $MAC"
        ;;
    hacc-box-03)
        #device_0
        id="0"
        upstream_port=""
        root_port="xx:xx.x"
        LinkCtl="xx"
        device_type="" 
        device_name="" 
        serial_number=""
        IP="" 
        MAC=""
        device_0="$id $upstream_port $root_port $LinkCtl $device_type $device_name $serial_number $IP $MAC"
        #device_1
        id="1"
        upstream_port=""
        root_port="xx:xx.x"
        LinkCtl="xx"
        device_type="" 
        device_name="" 
        serial_number=""
        IP="" 
        MAC=""
        device_1="$id $upstream_port $root_port $LinkCtl $device_type $device_name $serial_number $IP $MAC"
        #device_2
        id="2"
        upstream_port=""
        root_port="xx:xx.x"
        LinkCtl="xx"
        device_type="" 
        device_name="" 
        serial_number=""
        IP="" 
        MAC=""
        device_2="$id $upstream_port $root_port $LinkCtl $device_type $device_name $serial_number $IP $MAC"
        #device_3
        id="3"
        upstream_port=""
        root_port="xx:xx.x"
        LinkCtl="xx"
        device_type="" 
        device_name="" 
        serial_number=""
        IP="" 
        MAC=""
        device_3="$id $upstream_port $root_port $LinkCtl $device_type $device_name $serial_number $IP $MAC"
        ;;
    *)
        echo "Unknown server."
        ;;
esac
devices="$device_0\n$device_1\n$device_2\n$device_3"

#get column for the parameter
parameter_column=$(get_column $parameter)

#output device parameter
echo -e "$devices" | awk -v device_index="$device_index" -v parameter_column="$parameter_column" '$1 == device_index {print $parameter_column}'