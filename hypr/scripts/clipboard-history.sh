#!/bin/bash
# Historial de portapapeles (SUPER+CTRL+V).
# Migrado de wofi+cliphist a Walker (2026-09-14): el proveedor "clipboard"
# de Walker (elephant-clipboard-bin) ya lista, filtra y copia al seleccionar
# -- no hace falta encadenar cliphist/wl-copy a mano.

walker -m clipboard -p "Portapapeles"
