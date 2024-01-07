#!/usr/bin/env zsh

brew upgrade --greedy && open -g "swiftbar://refreshplugin?name=brew" && terminal-notifier -remove "xbar/brew" > /dev/null
