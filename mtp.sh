#!/usr/bin/env bash

# Check if jmtpfs is installed
if ! command -v jmtpfs &> /dev/null; then
    echo "jmtpfs could not be found. Please install it first."
    exit 1
fi

MNT="$HOME/mtp"

# Function to mount the device
mount_mtp() {
    # Kill processes that might block MTP
    pkill gvfsd-mtp 2>/dev/null
    pkill kio-mtp 2>/dev/null

    # Create mount point if missing
    mkdir -p "$MNT"

    # Mount with proper options
    jmtpfs -o allow_other,uid=$(id -u),gid=$(id -g) "$MNT"
    if [[ $? -eq 0 ]]; then
        notify-send "MTP" "Mounted device at $MNT"
    else
        notify-send "MTP" "Failed to mount device"
    fi
}

# Function to unmount the device
unmount_mtp() {
    fusermount -u "$MNT"
    if [[ $? -eq 0 ]]; then
        notify-send "MTP" "Unmounted device from $MNT"
    else
        notify-send "MTP" "Failed to unmount device"
    fi
}

# Main logic
case "$1" in
    mnt)
        mount_mtp
        ;;
    umnt)
        unmount_mtp
        ;;
    *)
        echo "Usage: $0 {mnt|umnt}"
        exit 1
        ;;
esac
