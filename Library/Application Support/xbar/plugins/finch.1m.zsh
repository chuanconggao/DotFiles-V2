#!/usr/bin/env zsh

source /etc/zprofile
source ~/.zprofile

STATUS=$(finch vm status)

if [[ $STATUS == "Stopped" ]]; then
    COLOR="red"
elif [[ $STATUS == "Running" ]]; then
    COLOR="green"
else
    COLOR="yellow"
fi

echo "Finch | color=$COLOR"

echo "---"

echo "$STATUS"

echo "---"

echo "Start... | shell=zsh param1=~/.xbar/plugins/scripts/finch.start.zsh terminal=true"
echo "Stop... | shell=zsh param1=~/.xbar/plugins/scripts/finch.stop.zsh terminal=true"
