#!/bin/bash

cat /etc/pam-mysql.conf | grep users.db_user | awk '{ print $3 }'