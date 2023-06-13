#!/bin/bash

XILINX_PATH=$1

# Declare global variables
declare -g platform_found="0"
declare -g platform_name=""

#get platforms
cd $XILINX_PATH/platforms
platforms=( "xilinx_"* )

PS3=""
select platform_name in "${platforms[@]}"; do 
    if [[ -z $platform_name ]]; then
        echo "" >&/dev/null
    else
        platform_found="1"
        platform_name=${platform_name::-1} # remove the last character, i.e. "/"
        break
    fi
done

# Return values
echo "$platform_found"
echo "$platform_name"