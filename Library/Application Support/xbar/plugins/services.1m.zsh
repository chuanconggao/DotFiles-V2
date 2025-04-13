#!/usr/bin/env zsh

source /etc/zprofile
source ~/.zprofile

RUNNING_NUM=0

function finch_status() {
    FINCH_STATUS=$(finch vm status)
    if [[ -z $FINCH_STATUS ]]; then
        FINCH_STATUS="(Unknown)"
    fi

    if [[ $FINCH_STATUS == "Stopped" ]]; then
        FINCH_COLOR="red"
    elif [[ $FINCH_STATUS == "Running" ]]; then
        FINCH_COLOR="green"

        RUNNING_NUM=$((RUNNING + 1))
    else
        FINCH_COLOR="yellow"
    fi
}

finch_status

if [[ $RUNNING_NUM -gt 0 ]]; then
    echo ":apple.terminal.on.rectangle:: $RUNNING_NUM | color=green sfcolor=green sfsize=18"
else
    echo ":apple.terminal.on.rectangle: | sfsize=18"
fi

echo "---"

function finch_menu() {
    echo "Finch | color=$FINCH_COLOR"

    echo "-- $FINCH_STATUS"

    echo "-----"

    echo "-- Start... | shell=~/.xbar/plugins/scripts/finch.start.zsh terminal=true"
    echo "-- Stop... | shell=~/.xbar/plugins/scripts/finch.stop.zsh terminal=true"
}

finch_menu
