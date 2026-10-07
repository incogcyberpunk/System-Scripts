#!/usr/bin/env bash
# Show a QR code in a floating ghostty popup (class: qr.popup).
#
#   showQR.sh <text...>   encode the given text/url
#   showQR.sh -           read text from stdin
#   showQR.sh -c          clipboard text (wl-paste)
#   showQR.sh -p          prompt for text (rofi)
#   showQR.sh -w          currently connected Wi-Fi (iwd); asks for root via
#                         polkit to read the saved password
#   showQR.sh             piped stdin if any, else clipboard
#   showQR.sh -- <text>   encode text that starts with "-"
set -euo pipefail

NOCOLOR='s/\x1b\[[0-9;]*m//g'
caption=""

usage() {
    sed -n '2,12s/^# \{0,1\}//p' "$0" >&2
    exit 1
}

die() {
    echo "Error: $*" >&2
    notify-send -a showQR "QR code" "$*" 2>/dev/null || true
    exit 1
}

need() { command -v "$1" &>/dev/null || die "$1 not installed"; }

clipboard() {
    need wl-paste
    wl-paste -n -t text 2>/dev/null || die "Clipboard has no text"
}

prompt() {
    need rofi
    rofi -dmenu -p "QR text" -l 0 </dev/null # Esc -> non-zero -> silent exit
}

# Escape \ ; , : " as required by the WIFI: QR format
wifi_escape() { sed 's/[\\;,:"]/\\&/g' <<<"$1"; }

wifi() {
    need iwctl
    local dev info ssid sec base file pass hidden

    dev=$(iwctl station list | sed -E "$NOCOLOR" | awk '$2 == "connected" { print $1; exit }')
    [[ -n $dev ]] || die "Not connected to Wi-Fi"

    info=$(iwctl station "$dev" show | sed -E "$NOCOLOR")
    ssid=$(sed -nE 's/^[ *]+Connected network +(.*[^ ]) *$/\1/p' <<<"$info")
    sec=$(sed -nE 's/^[ *]+Security +(.*[^ ]) *$/\1/p' <<<"$info")
    [[ -n $ssid ]] || die "Could not read the connected network name"

    case $sec in
        [Oo]pen)
            content="WIFI:T:nopass;S:$(wifi_escape "$ssid");;"
            ;;
        *Personal*)
            need pkexec
            # iwd profile name: plain SSID if it is [A-Za-z0-9_-] only, else "=<hex>"
            if [[ $ssid =~ ^[A-Za-z0-9_-]+$ ]]; then
                base=$ssid
            else
                base="=$(printf '%s' "$ssid" | od -An -tx1 | tr -d ' \n')"
            fi
            file=$(pkexec cat -- "/var/lib/iwd/$base.psk") || die "Could not read the saved Wi-Fi password"
            # ponytail: iwd escapes some chars in values (\\, \s); such passphrases are taken verbatim
            pass=$(sed -n 's/^Passphrase=//p' <<<"$file")
            [[ -n $pass ]] || die "iwd has no stored passphrase for $ssid"
            if grep -qx 'Hidden=true' <<<"$file"; then hidden=true; else hidden=false; fi
            # T:WPA covers WPA2 and WPA2/3 transition networks on all common scanners
            content="WIFI:T:WPA;S:$(wifi_escape "$ssid");P:$(wifi_escape "$pass");H:$hidden;;"
            ;;
        *)
            die "Unsupported Wi-Fi security: ${sec:-unknown}"
            ;;
    esac
    caption="Wi-Fi: $ssid"
}

need qrencode
need ghostty

case ${1-} in
    -h | --help) usage ;;
    -c | --clip) content=$(clipboard) ;;
    -p | --prompt) content=$(prompt) ;;
    -w | --wifi) wifi ;;
    -) content=$(cat) ;;
    --) shift; content="$*" ;;
    -?*) usage ;;
    "") if [[ ! -t 0 ]]; then content=$(cat); else content=$(clipboard); fi ;;
    *) content="$*" ;;
esac

[[ -n ${content//[[:space:]]/} ]] || die "No content to encode"

art=$(printf '%s' "$content" | qrencode -m 1 -t UTF8i) || die "Content too long for a QR code"

# Pass data via the environment (not argv or the command string): no shell
# injection, and the Wi-Fi password is not visible in /proc/*/cmdline.
# shellcheck disable=SC2016 # expanded by the popup's bash, not here
QR_ART=$art QR_CAPTION=$caption ghostty --class=qr.popup -e bash -c '
    printf "%s\n\n" "$QR_ART"
    [[ -n $QR_CAPTION ]] && printf "%s\n\n" "$QR_CAPTION"
    printf "Press any key to close..."
    read -rsn 1'
