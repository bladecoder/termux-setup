#!/usr/bin/env bash
set -euo pipefail

if command -v pkg >/dev/null 2>&1; then
    echo "This optional installer targets Ubuntu/Debian, not Termux." >&2
    exit 1
fi

if ! command -v apt >/dev/null 2>&1 || ! command -v sudo >/dev/null 2>&1; then
    echo "This installer requires apt and sudo." >&2
    exit 1
fi

# Detect system architecture
arch="$(uname -m)"
case "$arch" in
    x86_64)
        nvim_arch="linux-x86_64"
        ;;
    aarch64|arm64)
        nvim_arch="linux-arm64"
        ;;
    *)
        echo "Unsupported architecture: $arch" >&2
        exit 1
        ;;
esac

nvim_version="${NVIM_VERSION:-stable}"
nvim_url="https://github.com/neovim/neovim/releases/download/${nvim_version}/nvim-${nvim_arch}.tar.gz"
nvim_tar="/tmp/nvim-${nvim_arch}.tar.gz"

wget -O "$nvim_tar" "$nvim_url"
if [ "${VERIFY_DOWNLOADS:-0}" = "1" ]; then
    expected_sha="${NVIM_TAR_SHA256:-}"
    if [ -z "$expected_sha" ]; then
        echo "Set NVIM_TAR_SHA256 when VERIFY_DOWNLOADS=1." >&2
        exit 1
    fi
    echo "${expected_sha}  ${nvim_tar}" | sha256sum -c -
fi

tar -xf "$nvim_tar" -C /tmp
sudo install "/tmp/nvim-${nvim_arch}/bin/nvim" /usr/local/bin/nvim
sudo cp -R "/tmp/nvim-${nvim_arch}/lib" /usr/local/
sudo cp -R "/tmp/nvim-${nvim_arch}/share" /usr/local/
rm -rf "/tmp/nvim-${nvim_arch}" "$nvim_tar"

# Install luarocks and tree-sitter-cli to resolve lazyvim :checkhealth warnings.
sudo apt install -y luarocks tree-sitter-cli

# Only attempt to set configuration if Neovim has never been run.
if [ ! -d "$HOME/.config/nvim" ]; then
    git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
    rm -rf "$HOME/.config/nvim/.git"

    mkdir -p "$HOME/.config/nvim/plugin/after"
    cp ./configs/neovim/transparency.lua "$HOME/.config/nvim/plugin/after/"
    cp ./configs/theme/neovim.lua "$HOME/.config/nvim/lua/plugins/theme.lua"
    cp ./configs/neovim/snacks-animated-scrolling-off.lua "$HOME/.config/nvim/lua/plugins/"
    echo "vim.opt.relativenumber = false" >>"$HOME/.config/nvim/lua/config/options.lua"
    cp ./configs/neovim/lazyvim.json "$HOME/.config/nvim/"
fi

# Replace desktop launcher with one running inside Alacritty
# if [[ -d ~/.local/share/applications ]]; then
#   sudo rm -rf /usr/share/applications/nvim.desktop
#   source ./applications/Neovim.sh
# fi
