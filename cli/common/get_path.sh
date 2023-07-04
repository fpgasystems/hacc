#!/bin/bash

#inputs
CLI_PATH=$1
input_path=$2

output_path=$(eval echo "$(cat $CLI_PATH/constants/$input_path)")

#output
echo $output_path