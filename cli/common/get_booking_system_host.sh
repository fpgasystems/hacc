#!/bin/bash

cat /etc/pam-mysql.conf | grep users.host | awk '{ print $3 }'