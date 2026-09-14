#!/bin/bash
# Menu de control estilo Omarchy (SUPER+ALT+Espacio): bloquear, suspender, reiniciar, apagar, cerrar sesion.
# Migrado de wofi a Walker (2026-09-14): mismo patron dmenu, un solo launcher
# para todo en vez de depender de wofi solo para esto.

choice=$(printf "Bloquear\nSuspender\nReiniciar\nApagar\nCerrar sesion" | walker --dmenu --placeholder "Control")

case "$choice" in
    "Bloquear") hyprlock ;;
    "Suspender") systemctl suspend ;;
    "Reiniciar") systemctl reboot ;;
    "Apagar") systemctl poweroff ;;
    "Cerrar sesion") hyprctl dispatch exit ;;
esac
