#!/bin/bash

# Font Awesome icons
icon_charging=""      # Charging icon
icon_discharging=""    # Discharging icon
icon_full=""           # Full battery icon
icon_low=""            # Low battery icon
icon_unknown="❓"        # Unknown status icon

# Get battery status
battery_info=$(acpi -b)

# Extract battery percentage
battery_percentage=$(echo "$battery_info" | grep -o '[0-9]*%')
battery_status=$(echo "$battery_info" | grep -o 'Charging\|Discharging\|Full')

# Remove the '%' from the percentage for numerical comparison
battery_percentage_value=${battery_percentage%\%}

# Determine the output format based on battery status
if [[ "$battery_status" == "Charging" ]]; then
    echo "$icon_charging $battery_percentage"
elif [[ "$battery_status" == "Discharging" ]]; then
    if [ "$battery_percentage_value" -le 5 ]; then
        echo "$icon_low LOW"
    else
        echo "$icon_discharging $battery_percentage"
    fi
elif [[ "$battery_status" == "Full" ]]; then
    echo "$icon_full Full"
else
    echo "$icon_unknown Unknown battery status"
fi
