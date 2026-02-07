#!/usr/bin/env bash
set -euo pipefail

if ! command -v pkg >/dev/null 2>&1; then
    echo "This installer requires Termux (pkg)." >&2
    exit 1
fi

if command -v fresh >/dev/null 2>&1 || command -v fresh-editor >/dev/null 2>&1; then
    echo "Fresh editor is already installed."
    exit 0
fi

pkg install -y rust git clang make pkg-config

temp_dir="$(mktemp -d "${TMPDIR:-/tmp}/fresh.XXXXXX")"
cleanup() {
    if [ -d "${temp_dir:-}" ]; then
        rm -rf "$temp_dir"
    fi
}
trap cleanup EXIT INT TERM

git clone --depth 1 https://github.com/sinelaw/fresh "$temp_dir/fresh"
cd "$temp_dir/fresh"

# Build from source with Cargo.
cargo build --release

install -d "$HOME/.local/bin"

if [ -f "./target/release/fresh" ]; then
    install -m 0755 "./target/release/fresh" "$HOME/.local/bin/fresh"
    ln -sf "$HOME/.local/bin/fresh" "$HOME/.local/bin/fresh-editor"
elif [ -f "./target/release/fresh-editor" ]; then
    install -m 0755 "./target/release/fresh-editor" "$HOME/.local/bin/fresh-editor"
else
    echo "Build succeeded but no fresh binary was found in target/release." >&2
    exit 1
fi

echo "Fresh editor installed. Run: fresh"
