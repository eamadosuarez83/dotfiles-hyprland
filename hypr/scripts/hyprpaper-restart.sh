#!/bin/bash
# hyprpaper aborta de forma esporádica dentro de libhyprtoolkit.so.5
# (bug interno de la librería, no de esta config — ver HYPRLAND-MEJORAS.md).
# Mientras no haya una versión que lo corrija, lo relanzamos solo.

while true; do
    hyprpaper
    sleep 1
done
