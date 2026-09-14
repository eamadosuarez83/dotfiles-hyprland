#!/bin/bash
# Captura una region y extrae el texto con OCR al portapapeles (SUPER+CTRL+Print).
# Requiere el paquete tesseract y datos de idioma tesseract-data-eng/tesseract-data-spa.

tmp=$(mktemp /tmp/ocr-XXXXXX.png)
grim -g "$(slurp)" "$tmp" || { rm -f "$tmp"; exit 1; }

text=$(tesseract "$tmp" - -l spa+eng 2>/dev/null)
rm -f "$tmp"

if [ -n "$text" ]; then
    printf '%s' "$text" | wl-copy
    notify-send "OCR" "Texto copiado al portapapeles"
else
    notify-send "OCR" "No se detecto texto"
fi
