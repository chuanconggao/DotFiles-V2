#!/usr/bin/env zsh

source /etc/zprofile
source ~/.zprofile

brew up > /dev/null

OUTDATED=$(brew outdated --verbose --greedy)
OUTDATED_NUM=$(echo -n "$OUTDATED" | grep -c "")

if [[ $OUTDATED_NUM -gt 0 ]]; then
    echo "brew: $OUTDATED_NUM | color=yellow"

    terminal-notifier -title "Homebrew" -message "$OUTDATED_NUM available update(s)." -group "xbar/brew" > /dev/null
else
    echo "brew"
fi

echo "---"

date

if [[ $OUTDATED_NUM -gt 0 ]]; then
    echo "---"

    echo "$OUTDATED"

    echo "---"

    echo "Upgrade... | shell=~/.xbar/plugins/scripts/brew.upgrade.zsh terminal=true"
fi
