#!/usr/bin/env bash

if [[ -d ~/dotfiles/grubTheme/ ]]; then
    echo "Setting up GRUB theme..."

    # Copy over the themes
    if pacman -Q stow 1> /dev/null ; then
        cd ~/dotfiles
        sudo stow -t / grubTheme
    else
        echo "Install package `stow` first to setup GRUB theme."
    fi
    
    # Setup the catppuccin-mocha theme
    echo "GRUB_THEME='/usr/share/grub/themes/catppuccin-mocha-grub-theme/theme.txt'" | sudo tee -a /etc/default/grub

    # Update GRUB configuration file
   if sudo grub-mkconfig -o /boot/grub/grub.cfg ; then
        echo "GRUB theme setup successfully."
    else
        echo "Failed to update GRUB configuration."
    fi
    
fi

