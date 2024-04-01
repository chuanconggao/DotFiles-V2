#!/usr/bin/env zsh

source /etc/zprofile
source ~/.zprofile

OPEN_PORTS=$(lsof +c 100 -P -iTCP -sTCP:LISTEN | tail -n +2 | awk '{print $9,$1}' | sed 's/^*://' | sort -n | uniq)
OPEN_PORTS_NUM=$(echo -n "$OPEN_PORTS" | grep -c "")

# - 631 for internet printing protocol
# - 5000 for universal plug-and-play
# - 7000 for AirPlay receiver
MACOS_PORTS_REGEX="^(?:[57]000 ControlCenter|[0-9]+ rapportd|[0-9]+ sharingd)$"
LOCAL_PORTS_REGEX="^localhost:"

MACOS_OPEN_PORTS=$(echo -n "$OPEN_PORTS" | grep -P "$MACOS_PORTS_REGEX")
MACOS_OPEN_PORTS_NUM=$(echo -n "$MACOS_OPEN_PORTS" | grep -c "")

OTHERS_NONLOCAL_OPEN_PORTS=$(echo -n "$OPEN_PORTS" | grep -v -P "$MACOS_PORTS_REGEX" | grep -v -P "$LOCAL_PORTS_REGEX")
OTHERS_NONLOCAL_OPEN_PORTS_NUM=$(echo -n "$OTHERS_NONLOCAL_OPEN_PORTS" | grep -c "")

OTHERS_LOCAL_OPEN_PORTS=$(echo -n "$OPEN_PORTS" | grep -v -P "$MACOS_PORTS_REGEX" | grep -P "$LOCAL_PORTS_REGEX")
OTHERS_LOCAL_OPEN_PORTS_NUM=$(echo -n "$OTHERS_LOCAL_OPEN_PORTS" | grep -c "")

if [[ $OTHERS_NONLOCAL_OPEN_PORTS_NUM -gt 0 ]]; then
    echo ":firewall:: $OTHERS_NONLOCAL_OPEN_PORTS_NUM | color=yellow sfcolor=yellow sfsize=18"
else
    echo ":firewall: | sfsize=18"
fi

if [[ $MACOS_OPEN_PORTS_NUM -gt 0 ]]; then
    echo "---"

    echo "By macOS"

    echo "---"

    echo "$MACOS_OPEN_PORTS"
fi

if [[ $OTHERS_LOCAL_OPEN_PORTS_NUM -gt 0 ]]; then
    echo "---"

    echo "By Others (Local)"

    echo "---"

    echo "$OTHERS_LOCAL_OPEN_PORTS" 
fi

if [[ $OTHERS_NONLOCAL_OPEN_PORTS_NUM -gt 0 ]]; then
    echo "---"

    echo "By Others | color=yellow"

    echo "---"

    echo "$OTHERS_NONLOCAL_OPEN_PORTS" 
fi
