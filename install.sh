#!/bin/bash
# Copia estos configs a ~/.config, con backup de lo que ya exista.
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"

for name in hypr waybar walker kitty dunst; do
    target="$HOME/.config/$name"
    if [ -e "$target" ]; then
        echo "Respaldando $target -> $BACKUP/$name"
        mv "$target" "$BACKUP/$name"
    fi
    cp -r "$DIR/$name" "$target"
    echo "Instalado $target"
done

chmod +x "$HOME/.config/hypr/scripts/"*.sh 2>/dev/null || true
chmod +x "$HOME/.config/waybar/indicators/"*.sh 2>/dev/null || true
chmod +x "$HOME/.config/waybar/weather.sh" 2>/dev/null || true

echo
echo "Listo. Backup de lo anterior (si existia) en: $BACKUP"
echo "Revisa el README.md, seccion 'Cosas para revisar tras instalar en el Toshiba'."
