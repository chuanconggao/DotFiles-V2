#!/usr/bin/env zsh

source /etc/zprofile
source ~/.zprofile

brew up > /dev/null

OUTDATED=$(brew outdated --verbose --greedy)
OUTDATED_NUM=$(echo -n "$OUTDATED" | grep -c "")

if [[ $OUTDATED_NUM -gt 0 ]]; then
    echo "brew: $OUTDATED_NUM | color=yellow"
else
    echo "brew: $OUTDATED_NUM"
fi

echo "---"

date

if [[ $OUTDATED_NUM -gt 0 ]]; then
    echo "---"

    echo "$OUTDATED"
fi
