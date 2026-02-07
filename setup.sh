#!/usr/bin/env bash
set -euo pipefail

# Core flow targets Termux only.
if ! command -v pkg >/dev/null 2>&1; then
    echo "This setup is Termux-only. 'pkg' was not found." >&2
    echo "Use scripts/optional for non-Termux environments." >&2
    exit 1
fi

shopt -s nullglob
for installer in ./scripts/*.sh; do
    [ -f "$installer" ] || continue
    bash "$installer"
done
