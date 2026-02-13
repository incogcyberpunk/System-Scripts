#!/usr/bin/env bash

packages="
    pipewire
    pipewire-pulse
    pipewire-alsa
    wireplumber
    pavucontrol
    git
    github-cli
    neovim
    grub
    uwsm
    efibootmgr
    os-prober
    fuse3
    networkmanager
    network-manager-applet
    impala
    base-devel
    usbutils
    jre-openjdk
    lazygit
    openssh
    pacman-contrib
    man-pages
    zsh
    ghostty
    hyprland
    sddm
    keyd
    bun
    nodejs
    npm
    brightnessctl
    xdg-desktop-portal-hyprland
    hyprpolkitagent
    hypridle
    slurp
    grim
    satty
    hyprlock
    waypaper
    gparted
    hyprsunset
    wl-clipboard
    cliphist
    waybar
    rofi
    rofimoji
    wtype
    bluez
    bluez-utils
    bluetui
    fzf
    bat
    zoxide
    shellcheck
    pavucontrol
    mpd
    mpc
    mpd-mpris
    playerctl
    yazi
    ristretto
    7zip
    nemo
    hyprcursor
    eza
    duf
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
    vlc-plugin-ffmpeg
    exiftool
    mkvtoolnix-cli
    obs-studio
    v4l2loopback-dkms
    ffmpeg
    imagemagick
    qbittorrent
    qemu
    virt-manager
    libvirtd
    dnsmasq
    iptables
    spice-vdaagent
    handlr
    udisks2
    udiskie
    nginx
    discord
    mpv
    libreoffice-fresh
    obsidian
    gimp
    nerd-fonts
    noto-fonts
    noto-fonts-emoji
    noto-fonts-extra
    reflector
    yt-dlp
    python-curl_cffi
    stow
    tree
    pacseek
    tty-clock
"

function install_aur_packages(){
    aur_packages="
        dragon-drop
        awww-bin
        bibata-cursor
        anydesk-bin
        materialgram
        tmux-git
        pacseek
        xampp
        vlc-pause-click-plugin
        downgrade
        oh-my-posh
        opencode
        auto-cpufreq
        zen-browser-bin
        zsh-autopair-git
        sioyek
        brave-bin
        vscode-js-debug-bin
    "
    if yay -S --noconfirm --needed $aur_packages ; then
        echo "AUR packages installed successfully."
    else
        echo "Failed to install AUR packages"
    fi
}

function clone_dotfiles_repo(){
    git clone https://github.com/IncogCyberpunk/dotfiles.git ~/dotfiles
}

function setup_dotfiles(){
    cd ~/dotfiles || exit
    if sudo pacman -Qi stow >/dev/null ; then stow ./* ;fi
    cd ~ || exit
}

function setup_cursor(){
    sudo cp -r /usr/share/icons/{Bibata-Modern-Amber,Bibata-Modern-Ice} ~/.local/share/icons/ 2> /dev/null
}
function install_yay(){
    git clone https://aur.archlinux.org/yay.git ~/yay
    cd ~/yay || exit
    makepkg -si --noconfirm
    cd ~ || exit

}


function install_packages(){
    if  sudo pacman -S --noconfirm --needed $packages ; then
        echo "All packages installed successfully."
    else
        echo "Some packages failed to install."
    fi
}

function enable_services(){
        # Enable and start various system services
        # sudo systemctl enable --now NetworkManager
        sudo systemctl enable --now sshd
        sudo systemctl enable --now sddm
        sudo systemctl enable --now keyd
        sudo systemctl enable --now xdg-desktop-portal-hyprland
        sudo systemctl enable --now bluetooth
        if sudo pacman -Qi cups >/dev/null ; then sudo systemctl enable --now cups ; fi
        sudo systemctl enable --now usdiks2
        if sudo pacman -Qi auto-cpufreq >/dev/null ; then sudo systemctl enable --now auto-cpufreq ; fi

        #Enable user services
        systemctl --user enable --now pipewire
        systemctl --user enable --now pipewire-pulse
        systemctl --user enable --now wireplumber
        systemctl --user enable --now hypridle
        systemctl --user enable --now hyprpolkitagent
        systemctl --user enable --now hyprsunset
        systemctl --user enable --now app-com.mitchellh.ghostty.service
}

function main(){
    install_yay
    install_packages
    # install_aur_packages
    # clone_dotfiles_repo
    # setup_dotfiles
    # enable_services
}

main

