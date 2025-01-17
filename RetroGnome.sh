#!/bin/bash

# Script to configure a boot selection menu for GNOME and RetroPie
# Author: QKing
# License: MIT

set -e

echo "--------------------------------------------"
echo "Setting up GNOME and RetroPie boot selector"
echo "--------------------------------------------"

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root. Try using sudo."
  exit 1
fi

# Step 1: Disable RetroPie auto-start
echo "Disabling RetroPie auto-start..."
sudo systemctl disable autostart@emulationstation.service || echo "RetroPie auto-start not found. Skipping."

# Step 2: Install lightdm (Display Manager)
echo "Installing lightdm..."
sudo apt update
sudo apt install -y lightdm

# Step 3: Configure lightdm to add RetroPie session
echo "Configuring RetroPie session in lightdm..."
cat <<EOF | sudo tee /usr/share/xsessions/retropie.desktop > /dev/null
[Desktop Entry]
Name=RetroPie
Comment=Start RetroPie (EmulationStation)
Exec=/opt/retropie/supplementary/emulationstation/emulationstation.sh
Type=Application
EOF

# Step 4: Install GNOME (if not already installed)
echo "Installing GNOME..."
sudo apt install -y gnome-session gdm3

# Set gdm3 as the default display manager (if prompted)
sudo systemctl enable gdm3

# Step 5: Restart lightdm to apply changes
echo "Restarting display manager..."
sudo systemctl restart lightdm

echo "--------------------------------------------"
echo "Setup complete! Reboot your Raspberry Pi to"
echo "choose between GNOME and RetroPie on boot."
echo "--------------------------------------------"
