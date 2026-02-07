#!/usr/bin/env bash
set -euo pipefail

if [ "${VERIFY_DOWNLOADS:-0}" = "1" ]; then
    echo "VERIFY_DOWNLOADS=1 is not supported for opencode installer yet (no pinned checksum configured)." >&2
    exit 1
fi

curl -fsSL https://opencode.ai/install | bash

echo "Run 'opencode auth login' to configure a provider."
