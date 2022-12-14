#!/bin/sh

bold=$(tput bold)
normal=$(tput sgr0)

if sudo true; then
    #execution will continue
	echo ""
	echo "${bold}fpga_chmod${normal}"
	echo ""
else
    echo ""
    echo "$0: sorry, you are not allowed to run this script."
    echo ""
    exit 1
fi

chmod 666 /dev/fpga$1