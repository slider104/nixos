#!/bin/bash

choice=$(printf "Shutdown\nReboot\nSuspend\nLogout" | wofi --dmenu -p "Power:" -W 150 -H 120)

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
