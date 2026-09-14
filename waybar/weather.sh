#!/bin/bash
# Modulo de clima para waybar usando wttr.in (sin API key).

weather=$(curl -s --max-time 5 'https://wttr.in/?format=%c+%t')
location=$(curl -s --max-time 5 'https://wttr.in/?format=%l')

if [ -z "$weather" ]; then
    echo '{"text":"", "tooltip":"Sin conexion"}'
    exit 0
fi

if ! jq -nc --arg text "$weather" --arg tooltip "$location" '{text: $text, tooltip: $tooltip}'; then
    echo '{"text":"", "tooltip":"Error"}'
fi
