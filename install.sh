#!/usr/bin/env bash

pacakges="
    pipewire
    pipewire-pulse
    pipewire-alsa
    pipewire-audio
    wireplumber
    git
    neovim
    grub
    efibootmgr
    os-prober
    fuse3
    networkmanager
    network-manager-applet
    impala
    base-devel
    lazygit
    openssh
    pacman-contrib
    man-pages
    zsh
    wezterm
    hyprland
    sddm
    keyd
    bun
    nodejs
    brightnessctl
    xdg-desktop-portal-hyprland
    hyprpolkitagent
    hypridle
    wlogout
    wlogout
    slurp
    grim
    swappy
    hyprlock
    swww
    waypaper
    hyprsunset
    wl-clipboard
    cliphist
    waybar
    rofi
    rofimoji
    bluez
    bluez-utils
    bluetui
    fzf
    bat
    zoxide
    shellcheck
    pwvucontrol
    playerctl
    stow
    yazi
    nemo
    hyprcursor
    eza
    nwg-look
    qt5ct
    qt6ct
    filezilla
    netcat
    swaync
    cups
    cups-pdf
    system-config-printer
    python
    fd
    ripgrep
    vlc
    vlc-plugins-extra
    exiftool
    mkvtoolnix-cli
    obs-studio
    v4l2loopback-dkms
    ffmpeg
    imagemagick
    virt-manager
    qemu
    handlr
    localsend
    udisks2
    udiskie
    docker
    brave
    nginx
    spotify
    discord
    mpv
    libreoffice-fresh
    obsidian
    gimp
"

function clone_dotfiles_repo(){
    git clone https://github.com/IncogCyberpunk/dotfiles.git ~/dotfiles
}

function setup_dotfiles(){
    cd ~/dotfiles
    if sudo pacman -Qi stow >/dev/null ; then stow */ ;fi
    cd ~
}

function install_yay(){
    git clone https://aur.archlinux.org/yay.git ~/yay
    cd ~/yay
    makepkg -si --noconfirm
    cd ~

}

function install_aur_packages(){
    aur_packages="
        anydesk
        joplin
        gparted
        qimgv
        materialgram
        tmux-git
        pacseek
        xampp
        hollywood
        vlc-pause-click-plugin
        capt-src
        downgrade
        oh-my-posh
        opencode
        stremio
        qt5-webengine
        qt5-webchannel
        auto-cpufreq
        zen-browser-bin
        zsh-autopair-git
    sioyek
    "
    aur_packages=echo $aur_packages

    if yay -S --noconfirm --needed $aur_packages ; then
        echo "AUR packages installed successfully."
    else
        echo "Failed to install AUR packages"
    fi
}

function install_packages(){
    packages=echo $packages

    if  sudo pacman -S --noconfirm --needed $pacakges ; then
        echo "All packages installed successfully."
    else
        echo "Some packages failed to install."
    fi
}

function enable_services(){
        # Enable and start various system services
        sudo systemctl enable --now NetworkManager
        sudo systemctl enable --now sshd
        sudo systemctl enable --now sddm
        sudo systemctl enable --now keyd
        sudo systemctl enable --now xdg-desktop-portal-hyprland
        sudo systemctl enable --now bluetooth
        if sudo pacman -Qi cups >/dev/null ; then sudo systemctl enable --now cups ; fi
        sudo systemctl enable --now docker
        sudo systemctl enable --now usdiks2
        if sudo pacman -Qi auto-cpufreq >/dev/null ; then sudo systemctl enable --now auto-cpufreq ; fi

        #Enable user services
        systemctl --user enable --now pipewire
        systemctl --user enable --now pipewire-pulse
        systemctl --user enable --now wireplumber
        systemctl --user enable --now hypridle
        systemctl --user enable --now hyprpolkitagent
}

function main(){
    install_packages
    clone_dotfiles_repo
    setup_dotfiles
}

main

