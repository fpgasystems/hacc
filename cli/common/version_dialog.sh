#!/bin/bash

VIVADO_PATH=$1

# Declare global variables
declare -g version_found="0"
declare -g version_name=""

#get projects
cd /home/$username/my_projects/$workflow/
projects=( *"/" )

#get installed versions
cd $VIVADO_PATH
versions=( *"/" )

#get installed versions
cd $VIVADO_PATH
versions=( *"/" )

#check on number of versions
if [ ${#versions[@]} -eq 1 ]; then
    version=${versions[0]}
    #version=${version::-1} # remove the last character, i.e. "/"
else
    echo "${bold}Please, choose your Xilinx release branch:${normal}"
    echo ""
    PS3=""
    #versions+=("none")
    select version in "${versions[@]}"; do
        if [[ -z $version ]]; then
            echo "" >&/dev/null
        else
            break
        fi
    done
fi

# Return the values of version_found and version_name
echo "$version_found"
echo "$version_name"