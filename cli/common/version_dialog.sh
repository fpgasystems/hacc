#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

VIVADO_PATH=$1

# Declare global variables
declare -g version_found="0"
declare -g version_name=""

#get installed versions
cd $VIVADO_PATH
versions=($(ls -d */))

#check on number of versions
if [ ${#versions[@]} -eq 1 ]; then
    version_found="1"
    version_name=${versions[0]}
else
    PS3=""
    select version_name in "${versions[@]}"; do
        if [[ -z $version_name ]]; then
            echo "" >&/dev/null
        else
            version_found="1"
            break
        fi
    done
fi

#remove the last character, i.e. "/"
version_name=${version_name::-1}

# Return the values of version_found and version_name
echo "$version_found"
echo "$version_name"