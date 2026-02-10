#!/usr/bin/env bash

# Determine the current kernel version
kernel=$(uname -s)

# Install the headers for the currently running kernel
sudo pacman -S --noconfirm --needed "${kernel,,}-headers"

sudo pacman -S --noconfirm --needed dkms v4l2loopback-dkms

# Configure module to be loaded at boot
echo "v4l2loopback" | sudo tee /etc/modules-load.d/v4l2loopback.conf

# Configure module options
echo "options v4l2loopback devices=1 exclusive_caps=1 video_nr=10 card_label=\"OBS Virtual Camera\" " | sudo tee /etc/modprobe.d/v4l2loopback.conf

# Regenerate initramfs to include the new module
sudo mkinitcpio -P
