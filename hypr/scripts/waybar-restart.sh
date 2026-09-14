#!/bin/bash
# Mantiene waybar viva: si se cae (crash, SIGABRT, etc.), la relanza sola
# en vez de dejar la barra muerta hasta que alguien lo note.

while true; do
    waybar
    sleep 1
done
