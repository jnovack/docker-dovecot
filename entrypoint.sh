#!/bin/sh

PASSWD=$(pwgen -scnyr "'\"\\\&\!\%\/" 48 1)
SHAPWD=$(printf "${PASSWD}\n${PASSWD}\n" | doveadm pw -s SHA512-CRYPT)
egrep "${USERNAME:-catchall}" /etc/passwd | sed "s#x#$SHAPWD#" >> /etc/dovecot/users
echo "Password: ${PASSWD}"

dovecot

while true; do
    PID=$(cat /var/run/dovecot/master.pid)
	if [[ ! -d "/proc/$PID" ]]; then
	    echo "Dovecot process $PID does not exist... exiting"
	    exit 1
	fi
	sleep 10
done