#!/bin/bash

username=$(getent passwd ${SUDO_UID})
username=${username%%:*}

DB_IP=$(/opt/cli/common/get_booking_system_host) #129.132.186.30
DB_USER=$(/opt/cli/common/get_booking_system_db_user) #alveo-vm # "{{ pam.mysql.user }}"
DB_PASS=$(/opt/cli/common/get_booking_system_db_passwd) #koleno #"{{ pam.mysql.password }}"
mysql -h $DB_IP -u $DB_USER -D alveo -p$DB_PASS -e "SELECT server.name FROM booking INNER JOIN booking_map ON booking.id = booking_map.booking_id INNER JOIN server ON booking_map.server_id = server.id WHERE now() BETWEEN booking.begin AND booking.end AND booking.status=1 AND user='$username';"