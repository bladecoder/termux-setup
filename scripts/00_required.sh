#!/usr/bin/env bash
set -euo pipefail

if ! command -v pkg >/dev/null 2>&1; then
    echo "This installer requires Termux (pkg)." >&2
    exit 1
fi

# Needed for all installers
pkg update -y
pkg upgrade -y
pkg install -y curl git unzip wget

termux_storage_mode="${TERMUX_SETUP_STORAGE:-auto}"
case "$termux_storage_mode" in
    auto)
        if command -v termux-setup-storage >/dev/null 2>&1 && [ -t 0 ]; then
            termux-setup-storage
        else
            echo "Skipping termux-setup-storage (non-interactive or unavailable)."
        fi
        ;;
    always)
        if command -v termux-setup-storage >/dev/null 2>&1; then
            termux-setup-storage
        else
            echo "termux-setup-storage is unavailable." >&2
            exit 1
        fi
        ;;
    never)
        echo "Skipping termux-setup-storage (TERMUX_SETUP_STORAGE=never)."
        ;;
    *)
        echo "Invalid TERMUX_SETUP_STORAGE: $termux_storage_mode (use auto|always|never)." >&2
        exit 1
        ;;
esac

# Create local folders
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.config"
