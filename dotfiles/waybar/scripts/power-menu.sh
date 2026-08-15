#!/bin/bash

# Power menu script for waybar
# Uses wofi to display options

options="Shutdown\nReboot\nSuspend\nLogout"

chosen=$(echo -e "$options" | wofi --dmenu --prompt "Power Menu" --width 150 --height 120)

case "$chosen" in
    Shutdown)
        systemctl poweroff
        ;;
    Reboot)
        systemctl reboot
        ;;
    Suspend)
        systemctl suspend
        ;;
    Logout)
        loginctl terminate-user $USER
        ;;
    *)
        exit 1
        ;;
esac
