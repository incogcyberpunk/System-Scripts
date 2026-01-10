#!/usr/bin/env bash

# Install required packages
sudo pacman -S --needed --noconfirm sddm qt6-svg qt6-virtualkeyboard qt6-multimedia

# Clone the repo `keyitdev/sddm-astronaut-theme`
sudo git clone -b master --depth 1 https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme

# Copy fonts to /usr/share/fonts/
sudo cp -r /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/

# Edit /etc/sddm.conf
echo "[Theme]
Current=sddm-astronaut-theme" | sudo tee /etc/sddm.conf

# Edit /etc/sddm.conf.d/virtualkbd.conf
echo "[General]
InputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf

# Check if user wants to test the theme
read -p "Do you want to test the SDDM Astronaut theme now? (Y/n): " test_theme

if [[ "$test_theme" == "" || "$test_theme" == "y" || "$test_theme" == "Y" ]]; then
    echo "Testing SDDM Astronaut theme..."
    sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/sddm-astronaut-theme/
fi
