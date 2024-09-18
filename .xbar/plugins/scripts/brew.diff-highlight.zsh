#!/usr/bin/env zsh

pushd "$HOMEBREW_PREFIX"/bin
ln -s -f ../Cellar/git/"$(brew info git --json | jq -r '.[0].installed[0].version')"/share/git-core/contrib/diff-highlight/diff-highlight .
popd
