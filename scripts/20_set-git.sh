#!/bin/bash

# Ensure git settings live under ~/.config
mkdir -p ~/.config/git
touch ~/.config/git/config

# Set common git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.pushf "push --force-with-lease"
git config --global alias.l "log --oneline"
git config --global alias.last "log -1 HEAD --stat"
git config --global alias.change-commits "!f() { VAR=$1; OLD=$2; NEW=$3; shift 3; git filter-branch --env-filter \"if [[ \\\"$`echo $VAR`\\\" = '$OLD' ]]; then export $VAR='$NEW'; fi\" $@; }; f"


git config --global push.autoSetupRemote true 
git config --global push.default current 
git config --global init.defaultBranch main
git config --global pull.rebase true

# Set identification from install inputs
if [[ -n "${OMAKASE_USER_NAME//[[:space:]]/}" ]]; then
  git config --global user.name "$OMAKASE_USER_NAME"
fi

if [[ -n "${OMAKASE_USER_EMAIL//[[:space:]]/}" ]]; then
  git config --global user.email "$OMAKASE_USER_EMAIL"
fi
