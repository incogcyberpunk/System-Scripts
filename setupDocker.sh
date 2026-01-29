#!/usr/bin/env bash

# Install Docker and related tools on Arch Linux
sudo pacman -S --needed --noconfimr docker docker-compose docker-buildx

# Start Docker socket (officially recommended over starting the docker service )
sudo systemctl enable --now docker.socket
