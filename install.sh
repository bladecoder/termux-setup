#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Give people a chance to retry running the installation
trap 'echo -e "\n\033[31mOmakase Ubuntu installation failed! You can retry by running: source ./install.sh\033[0m"' ERR

# Check the distribution name and version and abort if incompatible
source ./install/check-version.sh
source ./install/required.sh >/dev/null
source ./install/identification.sh

# Desktop software and tweaks will only be installed if we're running Gnome
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* || "$XDG_CURRENT_DESKTOP" == *"Unity"* ]]; then
  # Ensure computer doesn't go to sleep or lock while installing
  gsettings set org.gnome.desktop.screensaver lock-enabled false
  gsettings set org.gnome.desktop.session idle-delay 0

  echo "Installing terminal and desktop tools..."

  # Install terminal tools
  source ./install/terminal.sh

  # Install desktop tools and tweaks
  source ./install/desktop.sh

  # Revert to normal idle and lock settings
  gsettings set org.gnome.desktop.screensaver lock-enabled true
  gsettings set org.gnome.desktop.session idle-delay 300
else
  echo "Only installing terminal tools..."
  source ./install/terminal.sh
fi#!/bin/bash

# Run terminal installers
for installer in ./install/*.sh; do source $installer; done
