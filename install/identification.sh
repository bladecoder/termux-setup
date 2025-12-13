#!/bin/bash

echo -e "\n\033[35mEnter identification for git and autocomplete...\033[0m\n"
SYSTEM_NAME=$(getent passwd "$USER" | cut -d ':' -f 5 | cut -d ',' -f 1)
read -p "Full Name [${SYSTEM_NAME}]: " OMAKASE_USER_NAME
OMAKASE_USER_NAME=${OMAKASE_USER_NAME:-$SYSTEM_NAME}
export OMAKASE_USER_NAME

read -p "Email: " OMAKASE_USER_EMAIL
export OMAKASE_USER_EMAIL
