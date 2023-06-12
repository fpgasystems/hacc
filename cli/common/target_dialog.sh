#!/bin/bash

# Declare global variables
declare -g target_name=""

PS3=""
select target_name in sw_emu hw_emu hw
do
    case $target_name in
        sw_emu) break;;
        hw_emu) break;;
        hw) break;;
    esac
done

echo "$target_name"