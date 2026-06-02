#!/usr/bin/env bash
# Script to configure user provided sleep state on a Linux system by modifying GRUB configuration.

configFile="/etc/default/grub"
successState=0
sleepType="$1"
scriptName=$(basename "$0")

if [[ -z "$sleepType" ]]; then
    echo "USAGE: $scriptName <sleep_state>"
    exit 1
fi

echo "Setting up $sleepType sleep state..."

if grep -q '^GRUB_CMDLINE_LINUX_DEFAULT=.*mem_sleep_default=' "$configFile"; then
    if sudo sed -i \
        "/^GRUB_CMDLINE_LINUX_DEFAULT=/ s/\bmem_sleep_default=[^\" ]*/mem_sleep_default=$sleepType/" \
        "$configFile"; then
        successState=1
    fi
else
    if sudo sed -i \
        "/^GRUB_CMDLINE_LINUX_DEFAULT=/ s/\"$/ mem_sleep_default=$sleepType\"/" \
        "$configFile"; then
        successState=1
    fi
fi

if [[ $successState -eq 1 ]]; then
    echo "$sleepType sleep state configured successfully."
else
    echo "Failed to configure $sleepType sleep state."
    exit 1
fi

echo "Updating GRUB configuration..."

if sudo grub-mkconfig -o /boot/grub/grub.cfg; then
    echo "GRUB updated successfully. Please reboot your system to apply the changes."
else
    echo "Failed to update GRUB."
    exit 1
fi
