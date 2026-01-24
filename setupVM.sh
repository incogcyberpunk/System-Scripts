#!/usr/bin/env bash

sudo pacman -S qemu-full libvirt virt-manager dnsmasq iptables virtiofsd

sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt $USER

echo "Please log out and log back in to apply group changes."
echo "You can then start virt-manager to manage your virtual machines."


# To autostart default virtual NAT
sudo virsh net-autostart default

# To start the default virtual NAT now
sudo virsh net-start default

# Add NAT for libvirt
sudo iptables -t nat -A POSTROUTING -s 192.168.122.0/24 -o enp0s25 -j MASQUERADE

echo "Please install `spice-vdagent` inside your guest VMs and then start `spice-vdagent` as a user system service"
