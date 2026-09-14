#!/bin/bash
# Indicador de notificaciones (dunst) para waybar.
# Añadido 2026-09-14 como mejora pendiente de HYPRLAND-MEJORAS.md.

count=$(dunstctl count history 2>/dev/null)
count=${count:-0}
paused=$(dunstctl is-paused 2>/dev/null)

if [ "$paused" = "true" ]; then
    class="dnd"
    icon=""
    tooltip="No molestar activo (clic derecho para desactivar) · $count en el historial"
elif [ "$count" -gt 0 ] 2>/dev/null; then
    class="has-notifications"
    icon=""
    tooltip="$count notificaciones en el historial (clic para reabrir la ultima)"
else
    class=""
    icon=""
    tooltip="Sin notificaciones pendientes"
fi

jq -nc --arg text "$icon" --arg class "$class" --arg tooltip "$tooltip" \
    '{text: $text, class: $class, tooltip: $tooltip}'
