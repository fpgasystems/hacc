#!/bin/bash

XILINX_PLATFORMS_PATH=$1

# Declare global variables
declare -g platform_found="0"
declare -g platform_name=""
declare -g multiple_platforms="0"

#get platforms
cd "$XILINX_PLATFORMS_PATH"
platforms=( "xilinx_"* )

# Check if there is only one directory
if [ ${#platforms[@]} -eq 1 ]; then
    platform_found="1"
    platform_name=${platforms[0]}
    #platform_name=${platform_name::-1} # remove the last character, i.e. "/"
else
    multiple_platforms="1"
    PS3=""
    select platform_name in "${platforms[@]}"; do 
        if [[ -z $platform_name ]]; then
            echo "" >&/dev/null
        else
            platform_found="1"
            #platform_name=${platform_name::-1} # remove the last character, i.e. "/"
            break
        fi
    done
fi

# Return values
echo "$platform_found"
echo "$platform_name"
echo "$multiple_platforms"