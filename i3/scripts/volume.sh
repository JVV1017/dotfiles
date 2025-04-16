#!/bin/bash

# Get the current volume level
current_volume=$(pactl get-sink-volume 0 | awk '{print $5}' | tr -d '%')

# Define the maximum volume (155%)
max_volume=155

# Function to determine the volume icon
get_volume_icon() {
    local volume=$1
    if [[ $volume -eq 0 ]]; then
        echo ""  # Muted icon
    elif [[ $volume -le 30 ]]; then
        echo ""  # Low volume icon
    elif [[ $volume -le 65 ]]; then
        echo ""  # Medium volume icon
    else
        echo ""  # High volume icon
    fi
}

# Check if the sink is muted
is_muted() {
    mute_status=$(pactl get-sink-mute 0 | awk '{print $2}')
    [[ $mute_status == "yes" ]]
}

# Handle volume up/down/mute
case $1 in
    up)
        if ! is_muted; then
            if (( current_volume + 5 <= max_volume )); then
                pactl set-sink-volume 0 +5%
            else
                pactl set-sink-volume 0 $max_volume%
            fi
            current_volume=$(pactl get-sink-volume 0 | awk '{print $5}' | tr -d '%')
            icon=$(get_volume_icon $current_volume)
            notify-send -h string:x-dunst-stack-tag:volume -h int:value:$current_volume "Volume" "$icon Volume: $current_volume%"
        fi
        ;;
    down)
        if ! is_muted; then
            pactl set-sink-volume 0 -5%
            current_volume=$(pactl get-sink-volume 0 | awk '{print $5}' | tr -d '%')
            icon=$(get_volume_icon $current_volume)
            notify-send -h string:x-dunst-stack-tag:volume -h int:value:$current_volume "Volume" "$icon Volume: $current_volume%"
        fi
        ;;
    mute)
        pactl set-sink-mute 0 toggle
        if is_muted; then
            notify-send -h string:x-dunst-stack-tag:volume "Volume" " Muted"
        else
            current_volume=$(pactl get-sink-volume 0 | awk '{print $5}' | tr -d '%')
            icon=$(get_volume_icon $current_volume)
            notify-send -h string:x-dunst-stack-tag:volume -h int:value:$current_volume "Volume" "$icon Volume: $current_volume%"
        fi
        ;;
esac
