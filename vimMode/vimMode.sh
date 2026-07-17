#!/usr/bin/env bash

if [[ ! -f "/tmp/vimMode.txt" ]]; then
    isActive="0"
else
    isActive="$(awk '{print $1}' /tmp/vimMode.txt)"
fi

if [[ "$isActive" == "0" ]]; then
    if keyd bind 'h=left' 'j=down' 'k=up' 'l=right' 'esc=esc'; then
        notify-send "Vim Mode" "Enabled" -u critical -h string:x-canonical-private-synchronous:vimMode
        echo "1" > /tmp/vimMode.txt
    fi
    
else
    if keyd bind reset; then
        notify-send "Vim Mode" "Disabled" -u low -t 1000 -h string:x-canonical-private-synchronous:vimMode
        echo "0" > /tmp/vimMode.txt
    fi
fi

