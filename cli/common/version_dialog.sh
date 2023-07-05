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
    #version=${version::-1} # remove the last character, i.e. "/"
else
    echo "${bold}Please, choose your Xilinx release branch:${normal}"
    echo ""
    PS3=""
    #versions+=("none")
    select version_name in "${versions[@]}"; do
        if [[ -z $version_name ]]; then
            echo "" >&/dev/null
        else
            version_found="1"
            break
        fi
    done
fi

# Return the values of version_found and version_name
echo "$version_found"
echo "$version_name"