#!/bin/bash

#constants
CLI_PATH="$(dirname "$(dirname "$0")")"
DEVICES_LIST="$CLI_PATH/devices_acap_fpga"

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

if [[ -f "$DEVICES_LIST" ]]; then
  #print if the first fpga/acap is valid
  device_1=$(head -n 1 "$DEVICES_LIST")
  upstream_port_1=$(echo "$device_1" | awk '{print $2}')
  if [[ -n "$(lspci | grep $upstream_port_1)" ]]; then
    #get column for the parameter
    parameter_column=$(get_column $parameter)
    #output device parameter
    awk -v device_index="$device_index" -v parameter_column="$parameter_column" '$1 == device_index {print $parameter_column}' $DEVICES_LIST
  fi
fi