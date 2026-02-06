#!/usr/bin/env sh
set -eu

# Run installers
for installer in ./scripts/terminal/*.sh; do source $installer; done
