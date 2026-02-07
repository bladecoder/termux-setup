#!/usr/bin/env bash
set -euo pipefail

if ! command -v pkg >/dev/null 2>&1; then
    echo "This installer requires Termux (pkg)." >&2
    exit 1
fi

source_dir="./configs/termux"
target_dir="$HOME/.termux"

if [ ! -d "$source_dir" ]; then
    echo "Termux config directory not found: $source_dir" >&2
    exit 1
fi

mkdir -p "$target_dir"

for source_file in "$source_dir"/*; do
    [ -f "$source_file" ] || continue

    target_file="$target_dir/$(basename "$source_file")"
    if [ -f "$target_file" ] && cmp -s "$source_file" "$target_file"; then
        continue
    fi

    if [ -f "$target_file" ]; then
        backup_file="${target_file}.bak.$(date +%Y%m%d%H%M%S)"
        mv "$target_file" "$backup_file"
    fi

    cp "$source_file" "$target_file"
done

if command -v termux-reload-settings >/dev/null 2>&1; then
    termux-reload-settings || true
fi
