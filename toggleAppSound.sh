#!/usr/bin/env bash

get_app_pid(){
    pid=$(hyprctl activewindow -j | jq '.pid')
    echo "$pid"
}

get_app_name(){
    app_name=$(hyprctl activewindow -j | jq '.initialClass')
    echo "$app_name"
}

toggle_app_audio(){
    pid=$(get_app_pid)
    app_name=$(get_app_name)
    if wpctl set-mute --pid "$pid" toggle ; then
        notify-send -h string:x-canonical-private-synchronous:audio-submap "Toggled audio for $app_name"
    else
        notify-send -h string:x-canonical-private-synchronous:audio-submap "Error" "Failed to toggle audio for $app_name"
    fi
}

toggle_app_audio
