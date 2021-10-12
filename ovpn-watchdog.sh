#!/bin/sh

# copy this to /etc/config/ovpn-watchdog.sh
# and chmod +x /etc/config/ovpn-watchdog.sh

URL=google.com
logger -t ovpn-watchdog "Running watchdog script against $URL"
COUNT=1
RETRIES=3
while true; do
    if ping -W 1 -c 1 $URL > /dev/null 2>&1 ; then
        COUNT=1
        sleep 1
    else
        logger -t ovpn-watchdog "ping failed $COUNT time(s)"
        if [ $RETRIES -eq $COUNT ]; then
            logger -t ovpn-watchdog "Restarting openvpn"
            /etc/init.d/openvpn restart || true
            COUNT=1
        else
            COUNT=$((COUNT+1))
        fi
    fi
done
