#!/usr/bin/env bash
set -euo pipefail

if ! command -v pkg >/dev/null 2>&1; then
    echo "This optional installer requires Termux (pkg)." >&2
    exit 1
fi

# Install Neovim
pkg install -y neovim

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

