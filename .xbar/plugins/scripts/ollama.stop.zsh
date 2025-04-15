#!/usr/bin/env zsh

PID=$(ps -A | awk '{print $1,$4}' | grep ollama | awk '{print $1}')
kill -INT "$PID" && open -g "swiftbar://refreshplugin?name=services"
