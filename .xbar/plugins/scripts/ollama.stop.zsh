#!/usr/bin/env zsh

ollama ps | tail -n +2 | awk '{print $1}' | xargs ollama stop
# Wait until all models are stopped
sleep 5

PID=$(ps -A | awk '{print $1,$4}' | grep ollama | awk '{print $1}')
kill -INT "$PID" && open -g "swiftbar://refreshplugin?name=services"
