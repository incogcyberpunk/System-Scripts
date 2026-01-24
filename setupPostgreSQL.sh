#!/usr/bin/env bash

# Install PostgreSQL
sudo pacman -S postgresql

# Check if 'sudo' command exists
if ! command -v sudo &> /dev/null; then
    echo "Error: 'sudo' is not installed."
    exit 1
fi

# Initialize PostgreSQL database
sudo -u postgres -i initdb -D /var/lib/postgres/data

# Start and enable PostgreSQL service
if sudo systemctl start postgresql ; then
    echo "PostgreSQL service started successfully."
else
    echo "Error: Failed to start PostgreSQL service."
    exit 1
fi


# Install pgadmin4
yay -S --needed --noconfirm pgadmin4-bin
