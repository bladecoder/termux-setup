#!/usr/bin/env bash
set -euo pipefail

pkg install -y termux-api termux-tools
pkg install -y gh duf bat \
    cmatrix fd ripgrep eza zoxide fzf imagemagick jq \
    tmux fastfetch lazygit bash-completion openssh net-tools procps figlet toilet cowsay
