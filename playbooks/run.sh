#!/bin/bash

[ -z "$1" ] && exit 1

echo -n "ETH Username: "
read username

echo -n "Password: "
read -s password

echo -e "\n"

/usr/bin/ansible-playbook \
    --ask-vault-pass \
    --inventory hosts \
    --extra-vars "ansible_ssh_user=$username ansible_ssh_pass=$password" \
    ${@:2} \
    ${@:1:1}
