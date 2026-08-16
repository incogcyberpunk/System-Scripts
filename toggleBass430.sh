#!/usr/bin/env bash
# Toggles connection state of the "Bass 430" Bluetooth headphone
# Emits a desktop notification (with icon) on connect/disconnect

DEVICE_NAME="Bass 430"
DEVICE_MAC="E2:B0:0C:E8:38:AC"

ICON_CONNECT="bluetooth-active"
ICON_DISCONNECT="bluetooth-disabled"

if bluetoothctl info "$DEVICE_MAC" | grep -q "Connected: yes"; then
    bluetoothctl disconnect "$DEVICE_MAC" >/dev/null 2>&1
    if bluetoothctl info "$DEVICE_MAC" | grep -q "Connected: no"; then
        notify-send -i "$ICON_DISCONNECT" "Bluetooth" "Disconnected from ${DEVICE_NAME}"
    else
        notify-send -i "dialog-error" "Bluetooth" "Failed to disconnect ${DEVICE_NAME}"
    fi
else
    bluetoothctl connect "$DEVICE_MAC" >/dev/null 2>&1
    if bluetoothctl info "$DEVICE_MAC" | grep -q "Connected: yes"; then
        notify-send -i "$ICON_CONNECT" "Bluetooth" "Connected to ${DEVICE_NAME}"
    else
        notify-send -i "dialog-error" "Bluetooth" "Failed to connect ${DEVICE_NAME}"
    fi
fi
