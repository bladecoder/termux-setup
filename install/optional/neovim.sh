#!/bin/bash

# Detect system architecture
ARCH=$(uname -m)
case $ARCH in
  x86_64)
    NVIM_ARCH="linux-x86_64"
    ;;
  aarch64|arm64)
    NVIM_ARCH="linux-arm64"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

wget -O /tmp/nvim.tar.gz "https://github.com/neovim/neovim/releases/download/stable/nvim-${NVIM_ARCH}.tar.gz"
tar -xf /tmp/nvim.tar.gz -C /tmp
sudo install /tmp/nvim-${NVIM_ARCH}/bin/nvim /usr/local/bin/nvim
sudo cp -R /tmp/nvim-${NVIM_ARCH}/lib /usr/local/
sudo cp -R /tmp/nvim-${NVIM_ARCH}/share /usr/local/
rm -rf /tmp/nvim-${NVIM_ARCH} /tmp/nvim.tar.gz

# Install luarocks and tree-sitter-cli to resolve lazyvim :checkhealth warnings
sudo apt install -y luarocks tree-sitter-cli

# Only attempt to set configuration if Neovim has never been run
if [ ! -d "$HOME/.config/nvim" ]; then
  # Use LazyVim
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  # Remove the .git folder, so you can add it to your own repo later
  rm -rf ~/.config/nvim/.git

  # Make everything match the terminal transparency
  mkdir -p ~/.config/nvim/plugin/after
  cp ./configs/neovim/transparency.lua ~/.config/nvim/plugin/after/

  # Default to Tokyo Night theme
  cp ./configs/theme/neovim.lua ~/.config/nvim/lua/plugins/theme.lua

  # Turn off animated scrolling
  cp ./configs/neovim/snacks-animated-scrolling-off.lua ~/.config/nvim/lua/plugins/

  # Turn off relative line numbers
  echo "vim.opt.relativenumber = false" >>~/.config/nvim/lua/config/options.lua

  # Ensure editor.neo-tree is used by default
  cp ./configs/neovim/lazyvim.json ~/.config/nvim/
fi

# Replace desktop launcher with one running inside Alacritty
# if [[ -d ~/.local/share/applications ]]; then
#   sudo rm -rf /usr/share/applications/nvim.desktop
#   source ./applications/Neovim.sh
# fi
