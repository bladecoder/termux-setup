#!/bin/bash

# Needed for all installers
pkg update -y
pkg upgrade -y
pkg install -y curl git unzip wget

termux-setup-storage


# Create local folders
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/share/
mkdir -p $HOME/.config/

