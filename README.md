# dotfiles-hyprland

Config de Hyprland + waybar + walker + kitty + dunst usada en el equipo
principal (napoleon-aspiree5476g), para reutilizar en el Toshiba con Arch
Linux. El historial completo de por qué está cada cosa así está en
[`HYPRLAND-MEJORAS.md`](./HYPRLAND-MEJORAS.md).

## Paquetes necesarios (Arch/Manjaro)

```bash
# Base: Hyprland y utilidades de sesión
sudo pacman -S hyprland waybar dunst kitty \
    dolphin nautilus wofi hyprpaper brightnessctl hyprlock hypridle \
    grim slurp polkit-gnome cliphist tesseract tesseract-data-eng \
    tesseract-data-spa jq

# Launcher Walker + su backend de busqueda (elephant)
yay -S walker
yay -S elephant-bin
yay -S elephant-desktopapplications-bin elephant-calc-bin elephant-websearch-bin \
       elephant-clipboard-bin elephant-files-bin elephant-runner-bin \
       elephant-symbols-bin elephant-unicode-bin
```

Fuente usada en waybar/hyprlock (ya suele venir en Manjaro, si no):

```bash
sudo pacman -S ttf-hack-nerd
```

## Instalar

```bash
git clone git@github.com:<usuario>/dotfiles-hyprland.git
cd dotfiles-hyprland
./install.sh
```

`install.sh` copia cada carpeta a su sitio en `~/.config/` (con backup de lo
que ya exista) y deja los scripts como ejecutables. No usa symlinks a
propósito: en el equipo original tampoco los usa, así que si algo se ajusta
distinto en el Toshiba (ruta de wallpaper, nombre de la interfaz de red...)
se edita ahí directo sin arrastrar el cambio de vuelta a este repo por
accidente.

## Cosas para revisar tras instalar en el Toshiba

- `~/.config/hypr/hyprpaper.conf` — la ruta del wallpaper
  (`/usr/share/backgrounds/manjaro/...`) puede no existir si el Toshiba no
  es Manjaro; cambiar a una imagen que sí exista ahí.
- `~/.config/hypr/hyprland.conf` — revisar `monitor=` y cualquier ruta que
  asuma el hardware del equipo original (nombres de dispositivo de teclado
  en hyprlock, etc.).
- Este Toshiba es "viejo" según el usuario — si la GPU es más limitada,
  vigilar si aparece el mismo bug de `libhyprtoolkit`/`EGL_BAD_ALLOC`
  documentado en la sección 11 de `HYPRLAND-MEJORAS.md`; los wrappers de
  auto-reinicio (`waybar-restart.sh`, `hyprpaper-restart.sh`) ya están
  puestos por si acaso.
