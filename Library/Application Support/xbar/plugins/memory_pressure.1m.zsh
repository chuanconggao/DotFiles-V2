#!/usr/bin/env zsh

source /etc/zprofile
source ~/.zprofile

FREE_MEMORY=$(memory_pressure | tail -n 1 | grep -P -o '\d+')
MEMORY_PRESSURE=$((100 - FREE_MEMORY))

if [[ $MEMORY_PRESSURE -le 60 ]]; then
    COLOR="green"
elif [[ $MEMORY_PRESSURE -le 80 ]]; then
    COLOR="yellow"

    terminal-notifier -title "Memory Pressure" -message "Warning: $MEMORY_PRESSURE% memory pressure." -group "xbar/memory_pressure" > /dev/null
else
    COLOR="red"

    terminal-notifier -title "Memory Pressure" -message "Critical: $MEMORY_PRESSURE% memory pressure." -group "xbar/memory_pressure" > /dev/null
fi

echo "Mem: $MEMORY_PRESSURE% | color=$COLOR"
