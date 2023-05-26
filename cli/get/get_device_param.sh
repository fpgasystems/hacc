#!/bin/bash

HACC_PATH="/opt/hacc"
DEVICES_LIST="$HACC_PATH/devices_reconfigurable"

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
PLATFORM_COLUMN=10

#inputs (./examine 0 root_port)
device_index=$1
parameter=$2

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
    platform)
      column=$PLATFORM_COLUMN
      ;;
    *)
      echo "Unknown parameter $parameter."
      ;;
  esac
  echo $column
}

# Check if the DEVICES_LIST exists
if [[ ! -f "$DEVICES_LIST" ]]; then
  echo ""
  echo "Please, update $DEVICES_LIST according to your infrastructure."
  echo ""
  exit 1
fi

#the file exists - check its contents by evaluating first row (device_0)
device_0=$(head -n 1 "$DEVICES_LIST")

#extract the second, third, and fourth columns (upstream_port, root_port, LinkCtl) using awk
upstream_port_0=$(echo "$device_0" | awk '{print $2}')
root_port_0=$(echo "$device_0" | awk '{print $3}')
LinkCtl_0=$(echo "$device_0" | awk '{print $4}')

continue=1
if [[ $upstream_port_0 == "xx:xx.x" || $root_port_0 == "xx:xx.x" || $LinkCtl_0 == "xx" ]]; then
  continue=0
fi

if [[ $continue -eq 1 ]]; then
  #get column for the parameter
  parameter_column=$(get_column $parameter)
  #output device parameter
  awk -v device_index="$device_index" -v parameter_column="$parameter_column" '$1 == device_index {print $parameter_column}' $DEVICES_LIST
else
  echo ""
  echo "Please, update $DEVICES_LIST according to your infrastructure."
  echo ""
  exit
fi