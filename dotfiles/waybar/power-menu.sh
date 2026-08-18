#!/usr/bin/env bash

choice=$(printf "Shutdown\nReboot\nSuspend\nLogout" | fuzzel --dmenu --hide-prompt --mesg="ESC to close" --width=20 --lines=4)

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
    loginctl terminate-user "$USER"
    ;;
esac
