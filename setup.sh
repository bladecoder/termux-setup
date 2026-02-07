#!/usr/bin/env bash
set -eu

# Run installers
shopt -s nullglob
for installer in ./scripts/*.sh; do
  bash "$installer"
done
