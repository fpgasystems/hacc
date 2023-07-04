#!/bin/bash

username=$(getent passwd ${SUDO_UID})
username=${username%%:*}

#constants
CLI_PATH="$(dirname "$(dirname "$0")")"

DB_IP=$($CLI_PATH/common/get_booking_system_host) 
DB_USER=$($CLI_PATH/common/get_booking_system_db_user) 
DB_PASS=$($CLI_PATH/common/get_booking_system_db_passwd) 
mysql -h $DB_IP -u $DB_USER -D alveo -p$DB_PASS -e "SELECT server.name FROM booking INNER JOIN booking_map ON booking.id = booking_map.booking_id INNER JOIN server ON booking_map.server_id = server.id WHERE now() BETWEEN booking.begin AND booking.end AND booking.status=1 AND user='$username';"