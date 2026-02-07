#!/usr/bin/env bash
set -euo pipefail

# Install btop and apply theme configuration.
pkg install -y btop
mkdir -p "$HOME/.config/btop/themes"
cp ./configs/btop.conf "$HOME/.config/btop/btop.conf"
cp ./configs/theme/btop.theme "$HOME/.config/btop/themes/tokyo-night.theme"
