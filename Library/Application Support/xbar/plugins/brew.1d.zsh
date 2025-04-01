#!/usr/bin/env zsh

source /etc/zprofile
source ~/.zprofile

brew up > /dev/null

if brew upgrade --dry-run --formula > /dev/null; then
    date >> ~/.brew_auto_upgrade.log
    HOMEBREW_COLOR=1 brew upgrade --formula >> ~/.brew_auto_upgrade.log
fi

OUTDATED=$(brew outdated --verbose --greedy)
OUTDATED_NUM=$(echo -n "$OUTDATED" | grep -c "")

if [[ $OUTDATED_NUM -gt 0 ]]; then
    echo ":mug:: $OUTDATED_NUM | color=yellow sfcolor=yellow sfsize=18"

    terminal-notifier -title "Homebrew" -message "$OUTDATED_NUM available update(s)." -group "xbar/brew" > /dev/null
else
    echo ":mug: | sfsize=18"
fi

echo "---"

date

if [[ $OUTDATED_NUM -gt 0 ]]; then
    echo "---"

    echo "$OUTDATED"

    echo "---"

    echo "Upgrade... | shell=~/.xbar/plugins/scripts/brew.upgrade.zsh terminal=true"
fi

echo "---"

echo "Link diff-highlight (of git)... | shell=~/.xbar/plugins/scripts/brew.diff-highlight.zsh terminal=true"
