#!/usr/bin/env bash
set -euo pipefail

pkg install -y vim

cp ./configs/vimrc "$HOME/.vimrc"

# Install vim-plug if not already installed.
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Install plugins.
vim +PlugInstall +qall
