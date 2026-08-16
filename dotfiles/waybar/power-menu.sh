#! /usr/bin/env bash

choice=$(printf "Shutdown\nReboot\nSuspend\nLogout" | wofi --dmenu -p "ESC to close" -W 200 -H 300)

case "$choice" in
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
esac
