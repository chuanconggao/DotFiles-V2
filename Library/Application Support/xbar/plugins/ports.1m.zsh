#!/usr/bin/env zsh

source /etc/zprofile
source ~/.zprofile

OPEN_PORTS=$(nmap --open localhost | grep "open" | awk '{print $1,$3}')
OPEN_PORTS_NUM=$(echo -n "$OPEN_PORTS" | grep -c "")

echo "Ports: $OPEN_PORTS_NUM"

echo "---"

echo "$OPEN_PORTS"
