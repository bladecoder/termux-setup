#!/usr/bin/env bash
set -euo pipefail

# Ensure git settings live under ~/.config
mkdir -p "$HOME/.config/git"
touch "$HOME/.config/git/config"

# Set common git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.pushf "push --force-with-lease"
git config --global alias.l "log --oneline"
git config --global alias.last "log -1 HEAD --stat"

git config --global push.autoSetupRemote true
git config --global push.default current
git config --global init.defaultBranch main
git config --global pull.rebase true

# Set identification from install inputs
user_name="${OMAKASE_USER_NAME:-}"
user_email="${OMAKASE_USER_EMAIL:-}"

if [[ -n "${user_name//[[:space:]]/}" ]]; then
    git config --global user.name "$user_name"
fi

if [[ -n "${user_email//[[:space:]]/}" ]]; then
    git config --global user.email "$user_email"
fi
