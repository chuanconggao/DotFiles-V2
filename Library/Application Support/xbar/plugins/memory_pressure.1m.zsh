#!/usr/bin/env zsh

source /etc/zprofile
source ~/.zprofile

FREE_MEMORY=$(memory_pressure | tail -n 1 | grep -P -o '\d+')
MEMORY_PRESSURE=$((100 - FREE_MEMORY))

if [[ $MEMORY_PRESSURE -le 60 ]]; then
    COLOR="green"
elif [[ $MEMORY_PRESSURE -le 80 ]]; then
    COLOR="yellow"
else
    COLOR="red"
fi

echo "Mem: $MEMORY_PRESSURE% | color=$COLOR"

echo "---"

echo "Activity Monitor... | shell=open param1=-a param2=\"Activity Monitor.app\" terminal=false"
