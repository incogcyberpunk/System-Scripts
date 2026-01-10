#!/usr/bin/env bash

content="
# Menu Entry For Reboot
menuentry 'Reboot' {
    echo 'Rebooting...'
    reboot
}

# Menu Entry For Shutdown
menuentry 'Shutdown' {
    echo 'Shutting down...'
    halt
}
"

echo "$content" | sudo tee -a /etc/grub.d/40_custom > /dev/null
echo "Created custom GRUB menu entries for Reboot and Shutdown. "

echo "Updating GRUB configuration..."
if sudo grub-mkconfig -o /boot/grub/grub.cfg ; then
    echo -e "\n\nGRUB configuration updated successfully."
else
    echo -e "\n\nFailed to update GRUB configuration."
fi

