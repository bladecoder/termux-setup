#!/usr/bin/env bash
set -euo pipefail

if ! command -v pkg >/dev/null 2>&1; then
    echo "This installer requires Termux (pkg)." >&2
    exit 1
fi

install_first_available() {
    package_label="$1"
    shift

    for package_name in "$@"; do
        if pkg install -y "$package_name"; then
            echo "Installed ${package_label} with package: ${package_name}"
            return 0
        fi
    done

    echo "Could not install ${package_label}. Tried: $*" >&2
    return 1
}

# Install programming languages previously managed by mise.
pkg install -y python rust
install_first_available "Java" openjdk-21 openjdk-17 openjdk-11 openjdk
install_first_available "Node.js" nodejs-lts nodejs
