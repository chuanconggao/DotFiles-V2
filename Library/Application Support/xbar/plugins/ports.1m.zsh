#!/usr/bin/env zsh

source /etc/zprofile
source ~/.zprofile

OPEN_PORTS=$(nmap --open localhost | grep "open" | awk '{print $1,$3}')
OPEN_PORTS_NUM=$(echo -n "$OPEN_PORTS" | grep -c "")

# - 631 for internet printing protocol
# - 5000 for universal plug-and-play
# - 7000 for AirPlay receiver
MACOS_PORTS_REGEX="^(?:631|5000|7000)/tcp "
OTHERS_OPEN_PORTS_NUM=$(echo -n "$OPEN_PORTS" | grep -c -v -P "$MACOS_PORTS_REGEX")

if [[ $OTHERS_OPEN_PORTS_NUM -gt 0 ]]; then
    echo "Ports: $OPEN_PORTS_NUM | color=yellow"
else
    echo "Ports: $OPEN_PORTS_NUM"
fi

echo "---"

echo "By macOS"

echo "---"

echo -n "$OPEN_PORTS" | grep -P "$MACOS_PORTS_REGEX"

echo "---"

if [[ $OTHERS_OPEN_PORTS_NUM -gt 0 ]]; then
    echo "By Others | color=yellow"

    echo "---"

    echo -n "$OPEN_PORTS" | grep -v -P "$MACOS_PORTS_REGEX"

    echo "---"
fi
