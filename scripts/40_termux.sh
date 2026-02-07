#!/usr/bin/env bash
set -euo pipefail

# Latest (tracks upstream)
npm install -g @mmmbuto/codex-cli-termux

# OR LTS (stable, /chat compatible)
# npm install -g @mmmbuto/codex-cli-lts

# Verify
# codex --version
# codex login
