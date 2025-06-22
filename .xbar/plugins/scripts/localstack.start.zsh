#!/usr/bin/env zsh

if (! docker ps > /dev/null 2> /dev/null); then
    echo "Starting Docker first..."

    open -a "Docker.app"
    # Wait until Docker is running
    sleep 5
fi

localstack start --detached && open -g "swiftbar://refreshplugin?name=services"
