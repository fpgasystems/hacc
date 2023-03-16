#!/bin/bash

playbook=$1

ANSIBLE_CONFIG="ansible.cfg" ansible-playbook --ask-vault-pass --inventory hosts --extra-vars "ansible_ssh_user=root" $playbook