#!/usr/bin/env bash


get_app_pid(){
    pid=$(hyprctl activewindow -j | jq '.pid')
    echo "$pid"
}

get_app_name(){
    pid=$(get_app_pid)
    app_name=$(wpctl status | rg "$pid" | awk '{print $2}')
    echo "$app_name"
}

get_app_ID(){
    app_name=$(get_app_name)
    id=$(wpctl status | rg "$app_name" | tail -n 1 | awk '{print $1}')
    echo "$id"
}

toggle_app_audio(){
    id=$(get_app_ID)
    app_name=$(get_app_name)
    if wpctl set-mute "$id" toggle ; then
        notify-send -u low -h string:x-canonical-private-synchronous:audio-submap "Toggled audio for $app_name"
    else
        notify-send -h string:x-canonical-private-synchronous:audio-submap "Error" "Failed to toggle audio for $app_name"
    fi
}

toggle_app_audio
