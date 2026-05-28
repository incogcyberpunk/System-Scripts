#!/usr/bin/env bash

# Install PostgreSQL
sudo pacman -S postgresql --noconfirm

# Install pgcli (Popular drop-in replacement for default psql that provides auto-completion, multi-line editing  and syntax highlighting)
sudo pacman -S pgcli --noconfirm

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


# Install dbeaver (A free multi-platform database tool for developers, database administrators, analysts and all people who need to work with databases)
sudo pacman -S dbeaver --noconfirm

# Create a new PostgreSQL user 
sudo -u postgres createuser --createdb --createrole --superuser "$USER"
