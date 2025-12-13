#!/bin/bash

# Configure the bash shell using defaults
[ -f ~/.bashrc ] && mv ~/.bashrc ~/.bashrc.bak
cp ./configs/bashrc ~/.bashrc

# Configure the inputrc using defaults
[ -f ~/.inputrc ] && mv ~/.inputrc ~/.inputrc.bak
cp ./configs/inputrc ~/.inputrc

# Copy bash configs to local share
mkdir -p ~/.local/share/bash
cp ./configs/bash/* ~/.local/share/bash/

## make the user shell bash if not already
if [ "$SHELL" != "$(which bash)" ]; then
    chsh -s "$(which bash)"
fi
