#!/bin/bash

# Get the current brightness level
current_brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
brightness_percent=$((current_brightness * 100 / max_brightness))

# Function to determine the brightness icon
get_brightness_icon() {
    local brightness=$1
    if [[ $brightness -le 50 ]]; then
        echo ""  # Low brightness icon
    else
        echo ""  # High brightness icon
    fi
}

# Handle brightness up/down
case $1 in
    up)
        brightnessctl set +10%
        brightness_percent=$(( $(brightnessctl get) * 100 / max_brightness ))
        icon=$(get_brightness_icon $brightness_percent)
        notify-send -h string:x-dunst-stack-tag:brightness -h int:value:$brightness_percent "Brightness" "$icon Brightness: $brightness_percent%"
        ;;
    down)
        brightnessctl set 10%-
        brightness_percent=$(( $(brightnessctl get) * 100 / max_brightness ))
        icon=$(get_brightness_icon $brightness_percent)
        notify-send -h string:x-dunst-stack-tag:brightness -h int:value:$brightness_percent "Brightness" "$icon Brightness: $brightness_percent%"
        ;;
esac
