#!/bin/bash

ANSIBLE_CONFIG="ansible_root.cfg" /usr/bin/ansible-playbook \
    --ask-vault-pass \
    --inventory hosts \
    --extra-vars "ansible_ssh_user=root" \
    "$@"
