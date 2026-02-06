#!/bin/bash

set -eu

# Configure the bash shell using defaults (only if not already installed)
if [ ! -d $HOME/.local/share/bash/ ]; then
    [ -f $HOME/.bashrc ] && mv $HOME/.bashrc $HOME/.bashrc.bak
    cp ./configs/bashrc $HOME/.bashrc
else
    echo "Bash configuration already exists, skipping .bashrc (user customizations preserved)..."
fi

# Configure the inputrc using defaults (always update)
[ -f $HOME/.inputrc ] && mv $HOME/.inputrc $HOME/.inputrc.bak
cp ./configs/inputrc $HOME/.inputrc

# Copy bash configs to local share (always update)
mkdir -p $HOME/.local/share/bash
cp ./configs/bash/* $HOME/.local/share/bash/

## make the user shell bash if not already
if [ "$SHELL" != "$(which bash)" ]; then
    chsh -s "$(which bash)"
fi
