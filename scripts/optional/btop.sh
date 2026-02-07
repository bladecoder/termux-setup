#!/usr/bin/env bash
set -euo pipefail

if command -v pkg >/dev/null 2>&1; then
    echo "This optional installer targets Ubuntu/Debian, not Termux." >&2
    exit 1
fi

if ! command -v apt >/dev/null 2>&1 || ! command -v sudo >/dev/null 2>&1; then
    echo "This installer requires apt and sudo." >&2
    exit 1
fi

# Install btop and apply theme configuration.
sudo apt install -y btop
mkdir -p "$HOME/.config/btop/themes"
cp ./configs/btop.conf "$HOME/.config/btop/btop.conf"
cp ./configs/theme/btop.theme "$HOME/.config/btop/themes/tokyo-night.theme"
