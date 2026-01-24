#!/usr/bin/env bash
# Script to configure S3 sleep (deep sleep) mode on a Linux system by modifying GRUB configuration.

configFile="/etc/default/grub"

echo "Setting up S3 sleep (deep sleep) mode..."

if [[ sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT/ s/"$/mem_sleep_default=deep"/' $configFile ]]; then
    echo "S3 sleep mode configured successfully."
else
    echo "Failed to configure S3 sleep mode."
    exit 1
fi

echo "Updating GRUB configuration..."
if sudo update-grub; then
    echo "GRUB updated successfully. Please reboot your system to apply the changes."
else
    echo "Failed to update GRUB."
    exit 1
fi
