#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#echo ""
#echo "${bold}iperf${normal}"
#echo ""

# constants
CLI_WORKDIR="/opt/cli"

# get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

# inputs
flags=$@

# set default
udp_server=""
if [ "$flags" = "" ]; then
    flags="-n -l"
else
    read -a flags <<< "$flags"
    for (( i=0; i<${#flags[@]}; i++ ))
    do
        if [[ " ${flags[$i]} " =~ " -w " ]] || [[ " ${flags[$i]} " =~ " --word " ]]; then # flags[i] is -w or --word
            flags[$i]="--filter"
            j=$(($i+1))
            flags[$j]=$(echo ${flags[$j]} | sed "s/-/_/g") # regexp we enter like u55c-10 need to be u55c_10 for get_from_vars
	    fi
    done
    flags="${flags[*]}" # convert array of strings into a string
    flags="-n "$flags
fi

/opt/cli/get/get_from_vars $flags | sed "s/_/-/g" | sed "s/network-settings-//g" | sed "s/\"//g" | cut -d ' ' -f1

# output=$(/opt/cli/get/get_from_vars $flags)

# echo $output

# echo ""
# echo "Columnes"
# echo ""

# echo ${output[0]}
# echo ${output[1]}
# echo ${output[2]}

# echo ""
# echo "Loop:"
# echo ""

# IFS=''
# read -ra output <<< "$output"
# for (( i=0; i<${#output[@]}; i++ ))
# do
#     echo ${output[$i]}

# done

# #echo ${output[0]}
# #echo ${output[1]}
# #echo ${output[2]}
# #echo ${output[3]}

# #remove and replace
# #output=${output/network_settings_/""}
# #output=${output/_/-}

# #echo $output