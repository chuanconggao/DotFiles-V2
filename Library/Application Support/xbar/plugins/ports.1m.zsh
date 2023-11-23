#!/usr/bin/env zsh

source /etc/zprofile
source ~/.zprofile

OPEN_PORTS=$(lsof +c 100 -n -P -iTCP -sTCP:LISTEN | tail -n +2 | awk '{print $9,$1}' | grep -v -P '\b127.0.0.1:' | sed 's/^*://' | sort -n -u)
OPEN_PORTS_NUM=$(echo -n "$OPEN_PORTS" | grep -c "")

# - 631 for internet printing protocol
# - 5000 for universal plug-and-play
# - 7000 for AirPlay receiver
MACOS_PORTS_REGEX="^(?:[57]000 ControlCenter|[0-9]+ rapportd)$"
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
