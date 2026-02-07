#!/usr/bin/env bash
set -euo pipefail

pkg install -y python
python -m pip install llm llm-openrouter llm-github-copilot

# Authenticate GitHub Copilot CLI for use in the terminal.
# llm github_copilot auth login
