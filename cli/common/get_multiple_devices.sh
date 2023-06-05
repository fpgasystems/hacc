#!/bin/bash

MAX_DEVICES=$1

if (( $MAX_DEVICES > 1 )); then
    multiple_devices=1
else
    multiple_devices=0
fi

echo $multiple_devices