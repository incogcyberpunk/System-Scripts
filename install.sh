#!/usr/bin/env bash

# Packages from the official [core] repository
core_packages=(
    grub
    efibootmgr
    base-devel
    usbutils
    openssh
    man-pages
    python
)

# Packages from the official [extra] repository
extra_packages=(
    pipewire
    pipewire-pulse
    pipewire-alsa
    wireplumber
    pavucontrol
    git
    github-cli
    neovim
    tmux
    kernel-modules-hook
    os-prober
    fuse3
    networkmanager
    network-manager-applet
    impala
    dhcpcd
    jre-openjdk
    pacman-contrib
    zsh
    zsh-autosuggestions
    zsh-completions
    zsh-doc
    zsh-history-substring-search
    zsh-syntax-highlighting
    ghostty
    hyprland
    sddm
    keyd
    bun
    nodejs
    npm
    brightnessctl
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    hyprpolkitagent
    hypridle
    slurp
    grim
    satty
    hyprlock
    awww
    gparted
    hyprsunset
    wl-clipboard
    cliphist
    qrencode
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
    mpd
    mpc
    mpd-mpris
    playerctl
    yazi
    handlr-regex
    ristretto
    7zip
    nemo
    hyprcursor
    eza
    duf
    nwg-look
    nwg-displays
    qt5ct
    qt6ct
    android-file-transfer
    filezilla
    netcat
    swaync
    cups
    cups-pdf
    system-config-printer
    python-gobject
    gtk4
    gtk4-layer-shell
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
    opencode
)

# Install all given packages in one transaction. A pacman transaction is
# all-or-nothing, so a single conflict aborts the whole batch; if that happens,
# retry each package on its own so only the problematic ones are skipped.
# Usage: install_with_fallback <install-function> <packages...>
function install_with_fallback(){
    local install_cmd=$1
    shift

    "$install_cmd" "$@" && return 0

    echo "Batch install failed, retrying packages one at a time..."
    local failed=()
    local pkg
    for pkg in "$@"; do
        "$install_cmd" "$pkg" || failed+=("$pkg")
    done

    if (( ${#failed[@]} )); then
        echo "These packages could not be installed:"
        printf '  %s\n' "${failed[@]}"
        return 1
    fi
}

function pacman_install(){
    sudo pacman -S --noconfirm --needed "$@"
}

function yay_install(){
    yay -S --noconfirm --needed "$@"
}

function install_aur_packages(){
    aur_packages=(
        chaotic-aur/sdx
        bibata-cursor
        anydesk-bin
        materialgram
        pacseek
        xampp
        vlc-pause-click-plugin
        downgrade
        oh-my-posh
        auto-cpufreq
        zen-browser-bin
        zsh-autopair-git
        sioyek
        brave-bin
        vscode-js-debug-bin
        lazyjournal
        waypaper
        tty-clock
    )
    if install_with_fallback yay_install "${aur_packages[@]}" ; then
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

function setup_nepali_patro(){
    git clone https://github.com/incogcyberpunk/nepali-patro ~/nepaliPatro
    # Exec= expands neither ~ nor variables, so the entry ships a placeholder
    # and is copied, not symlinked, with the real path substituted in.
    mkdir -p ~/.local/share/applications
    sed "s|@PATRO@|$HOME/nepaliPatro/patro|g" ~/nepaliPatro/nepaliPatro.desktop \
        > ~/.local/share/applications/nepaliPatro.desktop
    update-desktop-database ~/.local/share/applications 2>/dev/null || true
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
    if install_with_fallback pacman_install \
            "${core_packages[@]/#/core/}" \
            "${extra_packages[@]/#/extra/}" ; then
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
        sudo systemctl enable --now udisks2
        if sudo pacman -Qi auto-cpufreq >/dev/null ; then sudo systemctl enable --now auto-cpufreq ; fi

        #Enable user services
        systemctl --user enable --now pipewire
        systemctl --user enable --now pipewire-pulse
        systemctl --user enable --now wireplumber
        systemctl --user enable --now hyprpolkitagent
        systemctl --user enable --now app-com.mitchellh.ghostty.service

        # Source zsh-autopair
        echo "source /usr/share/zsh/plugins/zsh-autopair/autopair.zsh" >> ~/.zshrc
}

function executeAll(){
        install_yay
        install_packages
        install_aur_packages
        clone_dotfiles_repo
        setup_dotfiles
        setup_nepali_patro
        enable_services
}

function usage(){
    cat <<EOF
Usage: $0 <command>

Commands:
    all         Run every step below in order, cloning ~/dotfiles before stowing
    yay         Build and install the yay AUR helper
    pkgs        Install packages from the official core and extra repos
    aurPkgs     Install AUR packages with yay
    dotfiles    Symlink the dotfiles in ~/dotfiles with stow
    patro       Install the Nepali Patro calendar
    services    Enable system and user services
EOF
}

# Decision for what is to be done
case "$1" in
    "all")
        executeAll
        ;;
    "yay")
        install_yay
        ;;
    "pkgs")
        install_packages
        ;;
    "aurPkgs")
        install_aur_packages
        ;;
    "dotfiles")
        setup_dotfiles
        ;;
    "patro")
        setup_nepali_patro
        ;;
    "services")
        enable_services
        ;;
    "-h" | "--help")
        usage
        ;;
    "")
        usage
        exit 1
        ;;
    *)
        echo "Unknown command: $1" >&2
        usage >&2
        exit 1
        ;;
esac
