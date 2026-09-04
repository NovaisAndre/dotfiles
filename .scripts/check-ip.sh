#!/bin/bash

IP_FILE="$HOME/.cache/.last_ip"
CURRENT_IP=$(curl -s ipinfo.io/ip)
EMAIL="novaisandre.dev@gmail.com"
SUBJECT="IP Address Change Notification"
BODY="Your IP address has changed to $CURRENT_IP"

if [ -f "$IP_FILE" ]; then
    LAST_IP=$(cat "$IP_FILE")
    if [ "$CURRENT_IP" != "$LAST_IP" ]; then
        notify-send "IP Address Changed" "Your new IP address is $CURRENT_IP"
        echo "$CURRENT_IP" > "$IP_FILE"
        echo "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    fi
else
    echo "$CURRENT_IP" > "$IP_FILE"
    notify-send "IP Address Recorded" "Your current IP address is $CURRENT_IP"
fi

