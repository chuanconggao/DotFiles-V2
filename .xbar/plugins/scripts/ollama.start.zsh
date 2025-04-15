#!/usr/bin/env zsh

nohup ollama serve > /dev/null &
open -g "swiftbar://refreshplugin?name=services"
