#!/bin/sh

if sudo true; then
    chmod 666 /dev/fpga$1
else
    echo ""
    echo "$0: sorry, you are not allowed to run this script."
    echo ""
    exit 1
fi