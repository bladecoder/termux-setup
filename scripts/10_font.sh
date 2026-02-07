#!/usr/bin/env bash
set -euo pipefail

tmp_root="${TMPDIR:-$HOME/.tmp}"
mkdir -p "$tmp_root"
work_dir="$(mktemp -d "$tmp_root/jetbrains-font.XXXXXX")"

cleanup() {
    rm -rf "$work_dir"
}
trap cleanup EXIT INT TERM

zip_path="$work_dir/JetBrainsMono.zip"
font_dir="$work_dir/JetBrainsFont"

wget -q -O "$zip_path" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
[ -s "$zip_path" ] || { echo "JetBrainsMono download failed"; exit 1; }

unzip -oq "$zip_path" -d "$font_dir"
mkdir -p "$HOME/.termux"
cp "$font_dir/JetBrainsMonoNerdFontMono-Regular.ttf" "$HOME/.termux/font.ttf"
