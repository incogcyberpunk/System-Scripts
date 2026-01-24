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
    if sudo sed -i "/^#GRUB_THEME/c\GRUB_THEME='/usr/share/grub/themes/catppuccin-mocha-grub-theme/theme.txt'" /etc/default/grub ; then
        echo -e "\n\n Successfully added theme to /etc/default/grub \n\n"
    else
        echo -e "\n\n Error adding theme to /etc/default/grub \n\n"
    fi

    # Update GRUB configuration file
   if sudo grub-mkconfig -o /boot/grub/grub.cfg ; then
        echo "GRUB theme setup successfully."
    else
        echo "Failed to update GRUB configuration."
    fi
    
fi

