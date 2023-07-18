#!/bin/bash

#inputs
CLI_PATH=$1
constant_name=$2

constant_value=$(eval echo "$(cat $CLI_PATH/constants/$constant_name)")

#output
echo $constant_value