#!/bin/bash

chosen=$(printf "Power Off\nRestart\nLock" | rofi -dmenu -i -p "Choose:")

case "$chosen" in
    "Power Off") poweroff ;;
    "Restart") reboot ;;
	"Lock") betterlockscreen -l ;;
    *) exit 1 ;;
esac
