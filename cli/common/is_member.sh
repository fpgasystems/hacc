#!/bin/bash

username=$1
groupname=$2

if [ "$#" -ne 2 ] ; then
    echo ""
    echo "$0: exactly 2 arguments expected. Example: ./group_member_check jmoyapaya vivado_developers"
    exit
fi

#check if group exists
if [ $(getent group $groupname) ]; then
  echo "group exists."
else
  echo "group does not exist."
  exit
fi

if getent group $groupname | grep -q "\b${username}\b"; then
    echo true
else
    echo false
fi