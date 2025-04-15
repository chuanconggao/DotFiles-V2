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

function localstack_status() {
    LOCALSTACK_STATUS=$(localstack status | grep "Runtime status" | grep -o "running\|stopped")
    if [[ -z $LOCALSTACK_STATUS ]]; then
        LOCALSTACK_STATUS="(Unknown)"
    fi

    if [[ $LOCALSTACK_STATUS == "stopped" ]]; then
        LOCALSTACK_STATUS="Stopped"
        LOCALSTACK_COLOR="red"
    elif [[ $LOCALSTACK_STATUS == "running" ]]; then
        LOCALSTACK_STATUS="Running"
        LOCALSTACK_COLOR="green"

        RUNNING_NUM=$((RUNNING + 1))
    else
        LOCALSTACK_COLOR="yellow"
    fi
}

localstack_status

function ollama_status() {
    OLLAMA_STATUS=$(ps -A | awk '{print $4}' | grep ollama)
    if [[ -z $OLLAMA_STATUS ]]; then
        OLLAMA_STATUS="Stopped"
        OLLAMA_COLOR="red"
    else
        OLLAMA_STATUS="Running"
        OLLAMA_COLOR="green"

        RUNNING_NUM=$((RUNNING + 1))
    fi
}

ollama_status

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

function localstack_menu() {
    echo "LocalStack | color=$LOCALSTACK_COLOR"

    echo "-- $LOCALSTACK_STATUS"

    echo "-----"

    echo "-- Start... | shell=~/.xbar/plugins/scripts/localstack.start.zsh terminal=true"
    echo "-- Stop... | shell=~/.xbar/plugins/scripts/localstack.stop.zsh terminal=true"
}

localstack_menu

function ollama_menu() {
    echo "Ollama | color=$OLLAMA_COLOR"

    echo "-- $OLLAMA_STATUS"

    echo "-----"

    echo "-- Start... | shell=~/.xbar/plugins/scripts/ollama.start.zsh terminal=true"
    echo "-- Stop... | shell=~/.xbar/plugins/scripts/ollama.stop.zsh terminal=true"
}

ollama_menu
