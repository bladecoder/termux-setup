#!/usr/bin/env bash
set -euo pipefail

wget -q -O /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip

[ -s /tmp/JetBrainsMono.zip ] || { echo "JetBrainsMono download failed"; exit 1; }
unzip -oq /tmp/JetBrainsMono.zip -d /tmp/JetBrainsFont
cp /tmp/JetBrainsFont/JetBrainsMonoNerdFontMono-Regular.ttf "$HOME/.termux/font.ttf"
rm -rf /tmp/JetBrainsMono.zip /tmp/JetBrainsFont
