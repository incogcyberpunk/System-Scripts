#!/usr/bin/env bash

cd ~/linux

sudo make modules_install

sudo install -m 0600 $(make -s image_name) /boot/vmlinuz-$(make -s kernelrelease)

sudo mkinitcpio -k /boot/vmlinuz-$(make -s kernelrelease) -g /boot/initramfs-$(make -s kernelrelease).img

sudo grub-mkconfig -o /boot/grub/grub.cfg

