#!/usr/bin/env zsh

set -e

git config --global core.editor nano
git config --global credential.helper store
git config --global fetch.prune true
git config --global merge.conflictstyle diff3
git config --global pull.rebase true
git config --global push.autoSetupRemote true
git config --global push.default current

