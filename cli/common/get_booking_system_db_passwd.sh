#!/bin/bash

cat /etc/pam-mysql.conf | grep users.db_passwd | awk '{ print $3 }'