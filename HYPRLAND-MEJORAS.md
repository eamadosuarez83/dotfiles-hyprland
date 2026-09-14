# Mejoras estilo Omarchy aplicadas a Hyprland

Cherry-pick manual de ideas del proyecto [Omarchy](https://omarchy.org) aplicadas
a tu configuración existente, sin instalar el paquete completo. Cubre: tema
unificado, keybindings, captura+OCR y enriquecimiento de waybar.

## 1. Tema unificado (paleta Catppuccin Mocha)

Un solo archivo de colores compartido entre Hyprland, waybar y dunst:

- `~/.config/hypr/colors.conf` — variables de color para Hyprland (bordes de ventana)
- `~/.config/waybar/style.css` — recoloreado con la misma paleta
- `~/.config/dunst/dunstrc` — notificaciones con la misma paleta

Para cambiar de tema en el futuro: edita los colores en esos 3 archivos
(los nombres de variable en `colors.conf` están documentados ahí mismo).

## 2. Paquetes necesarios (instalados)

```
sudo pacman -S cliphist tesseract tesseract-data-eng tesseract-data-spa
```

Con esto el historial de portapapeles y la captura+OCR ya funcionan. El
watcher de `cliphist` (`wl-paste --watch cliphist store`) arranca solo la
próxima vez que inicies Hyprland gracias al `exec-once` en `hyprland.conf`.

## 3. Keybindings nuevos

| Atajo | Acción |
|---|---|
| `SUPER + Espacio` | Abrir el buscador de aplicaciones (alias de `SUPER+R`/`SUPER+D`) |
| `SUPER + ALT + Espacio` | Menú de control: Bloquear / Suspender / Reiniciar / Apagar / Cerrar sesión |
| `SUPER + Enter` | Abrir terminal (alias de `SUPER+Q`) |
| `SUPER + SHIFT + Enter` | Abrir Firefox |
| `SUPER + CTRL + V` | Historial de portapapeles (requiere `cliphist`) |
| `SUPER + CTRL + L` | Bloquear pantalla (alias de `SUPER+L`) |
| `SUPER + CTRL + Print` | Captura de región + OCR → texto al portapapeles (requiere `tesseract`) |

### Ya existentes (sin cambios)

| Atajo | Acción |
|---|---|
| `SUPER + Q` | Terminal (kitty) |
| `SUPER + C` | Cerrar ventana activa |
| `SUPER + M` | Salir de Hyprland |
| `SUPER + E` | Gestor de archivos (Dolphin) |
| `SUPER + V` | Alternar ventana flotante |
| `SUPER + R` / `SUPER + D` | Buscador de aplicaciones (wofi) |
| `SUPER + L` | Bloquear pantalla |
| `SUPER + [1-0]` | Ir al workspace 1-10 |
| `SUPER + SHIFT + [1-0]` | Mover ventana al workspace 1-10 |
| `SUPER + S` | Workspace especial (scratchpad) |
| `Print` | Captura de región al portapapeles |
| `SUPER + Print` | Captura de pantalla completa al portapapeles |
| `SUPER + SHIFT + Print` | Captura de región guardada en `~/Pictures` |

### No adoptado (conflicto con tu config actual)

Omarchy usa `SUPER+C/X/V` para copiar/cortar/pegar de forma unificada entre
terminal y apps gráficas. **No se aplicó** porque `SUPER+C` ya está asignado
en tu config a `killactive` (cerrar ventana) — cambiarlo rompería un atajo
que ya usas activamente.

## 4. Waybar enriquecido

- Nuevo módulo de clima (`custom/weather`, script en `~/.config/waybar/weather.sh`,
  usa wttr.in sin necesidad de API key, se actualiza cada 30 min).
- Recoloreado completo con la paleta Catppuccin Mocha.
- La bandeja del sistema (`tray`) ya estaba presente en tu config original.

### Bugs de la config por defecto arreglados de paso (no relacionados con Omarchy)

El `config.jsonc` que veníamos usando (copiado del ejemplo de sistema) estaba
escrito para **Sway**, no para Hyprland, así que varios módulos nunca
funcionaron desde el principio:

- `sway/workspaces` → `hyprland/workspaces` (ahora sí se ve el selector de workspaces)
- `sway/window` → `hyprland/window` (título de la ventana activa)
- `sway/mode` → `hyprland/submap`
- `sway/language` → `hyprland/language` (indicador de layout de teclado)
- `sway/scratchpad` se quitó (no tiene equivalente directo en Hyprland)
- Se quitó `battery#bat2` (tu equipo no tiene una segunda batería, solo generaba
  una advertencia)
- El menú de apagado (`power_menu.xml`) estaba en el formato XML equivocado
  (GMenu en vez de GtkBuilder/GtkMenu) — corregido.

## 5. Kitty: saltar a pestaña por número

No es de Omarchy, pero complementa el flujo de teclado. Agregado en
`~/.config/kitty/kitty.conf` (no existía antes, así que kitty conservaba
todos sus atajos por defecto — este archivo solo añade lo siguiente):

| Atajo | Acción |
|---|---|
| `Ctrl + 1` … `Ctrl + 9` | Saltar directo a la pestaña 1-9 |

Atajos de pestañas ya existentes por defecto en kitty (sin cambios):

| Atajo | Acción |
|---|---|
| `Ctrl + Shift + T` | Nueva pestaña |
| `Ctrl + Shift + →` | Siguiente pestaña |
| `Ctrl + Shift + ←` | Pestaña anterior |
| `Ctrl + Shift + Q` | Cerrar pestaña actual |
| `Ctrl + Shift + .` | Mover pestaña actual hacia adelante |
| `Ctrl + Shift + ,` | Mover pestaña actual hacia atrás |
| `Ctrl + Shift + Alt + T` | Renombrar pestaña |

Para aplicar cambios de `kitty.conf` sin reiniciar la terminal: `Ctrl+Shift+F5`.

## 6. Walker (reemplazo de wofi como launcher)

Instalado desde AUR (`yay -S walker`) — paquete oficial del autor
(`abenz1267/walker`, 26 votos, mantenimiento activo, no confundir con los
paquetes `omarchy-*` de terceros que se evaluaron antes y se descartaron).

### Piezas necesarias

Walker 2.x es solo la interfaz — las búsquedas (apps, calculadora,
portapapeles, archivos, etc.) las resuelve un demonio aparte llamado
`elephant` (mismo autor/repo). Sin él, Walker abre pero no encuentra nada.

`elephant-all-bin` (el bundle con todos los proveedores en un solo paquete)
saturó la RAM del equipo (7.6GB) durante el empaquetado y no terminó de
instalarse. Se instaló dividido en paquetes individuales, mucho más liviano:

```
yay -S elephant-bin
yay -S elephant-desktopapplications-bin elephant-calc-bin elephant-websearch-bin \
       elephant-clipboard-bin elephant-files-bin elephant-runner-bin \
       elephant-symbols-bin elephant-unicode-bin
```

Mismo mantenedor de confianza (`Dominiquini`, 6 votos, apunta al repo
oficial `abenz1267/elephant`) para todos.

**Corrección (2026-09-11):** al principio se activó `elephant` como servicio
systemd de usuario (`elephant service enable`), pero **nunca arrancaba solo**
— ese servicio depende de `graphical-session.target`, y ese target no se
activa en esta sesión de Hyprland (se lanza directo desde GDM, sin UWSM, así
que nada le avisa a systemd que la sesión gráfica ya está lista). El síntoma
se sentía como "arranca lento", pero en realidad no arrancaba en absoluto
hasta lanzarlo a mano.

Se deshabilitó el servicio (`elephant service disable`) y se reemplazó por
un `exec-once = elephant` directo en `hyprland.conf`, igual que `walker` y
`wl-paste --watch cliphist`. `elephant` arranca en ~180ms — el binario en sí
es rápido, el problema era el mecanismo de arranque.

### Qué se configuró

- `$menu` en `hyprland.conf` ahora es `walker` (antes `wofi --show drun`)
- `SUPER+D` y `SUPER+R` (via `$menu`) y `SUPER+Espacio` abren Walker
- `exec-once = walker --gapplication-service` — corre como servicio en
  segundo plano para que abra instantáneo (sin esto tarda un poco cada vez)
- Config copiado a `~/.config/walker/config.toml` y tema a
  `~/.config/walker/themes/default/` (antes solo existían en `/etc/xdg/walker/`,
  ahora son tuyos y editables)
- Tema recoloreado a Catppuccin Mocha en
  `~/.config/walker/themes/default/style.css` para que combine con Hyprland/waybar/dunst

### Cómo aprovechar Walker

Abre con `SUPER+D` (o `SUPER+Espacio` / `SUPER+R`) y empieza a escribir.
Sin ningún prefijo busca aplicaciones, calculadora y búsqueda web a la vez
(los "proveedores por defecto" de `~/.config/walker/config.toml`).

Probado en vivo el 2026-09-11, esto es lo que **sí funciona** con los
proveedores que instalamos:

| Prefijo | Proveedor | Qué hace | Ejemplo |
|---|---|---|---|
| *(nada)* | apps / calc / web | Busca aplicaciones, calcula y sugiere búsqueda web a la vez | `firefox` |
| `=` | calc | Solo calculadora | `=2+2*10` |
| `@` | websearch | Solo búsqueda web | `@clima bucaramanga` |
| `:` | clipboard | Historial de portapapeles (alternativa a `SUPER+CTRL+V`) | `:prueba` |
| `/` | files | Buscar archivos por nombre | `/hyprland` |
| `.` | symbols | Buscar emoji por nombre en inglés | `.heart` → varios corazones (roto, azul, negro...) |
| `>` | runner | Ejecutar un comando de shell directo | `>htop` |

El proveedor `unicode` (nombres/códigos Unicode, ej. `HEART DECORATION`)
también quedó instalado pero **no tiene un prefijo asignado** en la config
por defecto — para usarlo hay que agregarle uno en
`~/.config/walker/config.toml`, sección `[[providers.prefixes]]`.

Prefijos que **no van a funcionar** todavía porque no se instaló su
proveedor (se puede agregar después con el mismo patrón de
`elephant-<nombre>-bin`):

| Prefijo | Proveedor faltante |
|---|---|
| `;` | providerlist (lista todos los proveedores) |
| `!` | todo (lista de tareas rápida) |
| `%` | bookmarks |
| `$` | windows |

### Calculadora (`=`, motor: qalc / libqalculate)

No es una calculadora básica — soporta conversión de unidades, porcentajes,
funciones y constantes. Ejemplos:

```
=2+2*10                  → 22
=sqrt(144)                → 12
=15% of 200               → 30
=10 km to miles            → 6.21371 miles
=2h 30min to min            → 150 min
=1 usd to eur              → conversion (requiere internet)
=pi*2                     → 6.28319
```

El resultado se puede copiar directo con `Return`.

`wofi` se mantiene instalado y en uso para los scripts propios (menú de
control, historial de portapapeles con `cliphist`) — no se tocó eso.

## 7. Todo lo instalado en este proceso (referencia rápida)

```
# Gestor de archivos, launcher, wallpaper, brillo, lock/idle, capturas
sudo pacman -S dolphin wofi hyprpaper brightnessctl hyprlock hypridle grim slurp

# Agente de autenticacion grafica (polkit)
sudo pacman -S polkit-gnome

# Historial de portapapeles + OCR
sudo pacman -S cliphist tesseract tesseract-data-eng tesseract-data-spa

# Launcher Walker + su backend de busqueda (elephant), divididos por RAM limitada
yay -S walker
yay -S elephant-bin
yay -S elephant-desktopapplications-bin elephant-calc-bin elephant-websearch-bin \
       elephant-clipboard-bin elephant-files-bin elephant-runner-bin \
       elephant-symbols-bin elephant-unicode-bin
```

Ya instalados de antes (no se tocaron): `waybar`, `firefox`, `kitty`,
`wireplumber`/`pipewire`, `wl-clipboard`, `dunst`, `libnotify`.

## 8. Aviso: `hyprland.conf` va a dejar de funcionar (migración a Lua)

Hyprland está reemplazando su formato de configuración (`.conf`, hyprlang)
por **Lua**. Es un cambio anunciado oficialmente por el proyecto, no algo
opcional de terceros.

**Por qué:** el formato viejo (`windowrule = immediate yes, border_size 4,
class:^(x)$...`) se volvió difícil de mantener. Lua permite lógica real
(timers, eventos, callbacks) que antes solo era posible con plugins.

**Cronograma oficial:**

- Desde v0.55: Lua es opcional — si existe `~/.config/hypr/hyprland.lua`,
  se usa esa en vez de `.conf`.
- `.conf` se mantiene soportado por "1-2 versiones desde la 0.55" — o sea
  0.55 y 0.56 (la versión actual en este equipo, 0.56.2). De ahí sale la
  advertencia `you are using .conf conf format support which will be
  removed in hyprland 0.57` que ya te está apareciendo.
- **En Hyprland 0.57, el soporte de `.conf` se elimina por completo.** Todo
  lo de este documento (`hyprland.conf`, `colors.conf`) dejará de leerse y
  habrá que reescribirlo en Lua.

**Estado a la fecha (2026-09-11):** la wiki oficial todavía no publica la
guía completa de sintaxis Lua ni ejemplos de conversión. Existe una
herramienta de migración de un tercero (`hypr-migrate`,
github.com/loeclos/hypr-migrate) pero no está empaquetada y no se probó
en esta config por ser muy nueva y no oficial.

**Qué hacer:** nada todavía — `.conf` sigue funcionando normal en 0.56.2.
Cuando la wiki publique la guía oficial de Lua, o cuando toque actualizar
a Hyprland 0.57 (lo que pase primero), hay que migrar todo este setup
(`hyprland.conf`, `colors.conf`, los `exec-once`, los binds custom, los
scripts en `~/.config/hypr/scripts/`) al nuevo formato de una sola vez.

## 9. Dolphin abandonado como gestor de archivos → se cambió a Nautilus

Los nombres de carpeta en la vista de iconos de Dolphin se veían casi
invisibles (texto oscuro sobre fondo oscuro), aunque el resto de la
ventana (panel lateral, barra de herramientas) sí tenía buen contraste.
Se intentó resolver por varias vías (ver más abajo) sin éxito consistente
— el comportamiento cambiaba de forma impredecible entre reinicios de
Dolphin sin que cambiara nada más, algo típico de apps KDE Frameworks
corriendo sin Plasma completo (sin `kded6` sincronizando colores en vivo).

**Decisión final: se reemplazó Dolphin por Nautilus como `$fileManager`.**
Nautilus es GTK (no Qt/KDE), así que no depende para nada de Kvantum,
qt6ct ni `kdeglobals` — usa directamente el tema GTK del sistema
(`Adwaita-dark`, ya configurado en oscuro desde antes). Confirmado
visualmente funcionando perfecto a la primera: fondo oscuro real, texto
blanco legible, sin ningún ajuste adicional.

Cambio en `hyprland.conf`:
```
$fileManager = nautilus
```
(el bind `SUPER+E` ya usaba la variable `$fileManager`, no hubo que tocar
el bind en sí).

`qt6ct`/`qt5ct` quedaron en `custom_palette=false` (el único estado que
se confirmó estable para apps Qt en general) — si en el futuro se
necesita alguna app Qt/KDE con tema oscuro real, retomar desde ahí.

**Causa raíz encontrada:** el motor de temas **Kvantum** no respeta bien
la paleta de colores en la vista de items (icon/list view) de las apps
KDE — pasa sin importar qué tema Kvantum se use (se probó
`KvAdaptaMaiaDark`, `KvArcDark`, `KvGnomeDark`, mismo bug en los tres).
No es un problema del tema en sí, es Kvantum como motor.

**Intentos que NO funcionaron (documentados para no repetirlos):**
- Cambiar de tema Kvantum → mismo bug en los 3 probados.
- Crear `~/.config/kdeglobals` con solo `ColorScheme=BreezeDark` (el
  nombre, sin los valores) → sin efecto, porque sin Plasma corriendo nada
  hace el "merge" real de colores.
- Copiar el esquema `BreezeDark.colors` completo a `kdeglobals` → tampoco
  resolvió, Kvantum lo sigue ignorando en esa vista.
- Cambiar `style` de `kvantum` a `Fusion` (el estilo nativo de Qt) → esto
  sí arregló la legibilidad, pero el resultado quedó **claro, no oscuro**
  (con `custom_palette=true` + un esquema oscuro personalizado el
  comportamiento fue inconsistente entre reinicios — típico de apps KDE
  Frameworks corriendo sin el demonio `kded6` de Plasma sincronizando
  colores en vivo).

Se agotaron las vías razonables de arreglo por configuración sin instalar
más piezas de Plasma, así que se decidió no seguir invirtiendo tiempo ahí.

**Estado final de `qt6ct`/`qt5ct`:** `style=Fusion`, `custom_palette=false`
— es el único estado que se confirmó estable para apps Qt en general
(claro, legible, sin crashes). Si en el futuro hace falta una app Qt/KDE
con tema oscuro real, abrir `qt6ct` (Walker → "qt6ct") y retomar desde ahí,
o instalar `kded6`/`plasma-integration` para la sincronización correcta.

**Verificación post-cambio (2026-09-11):** confirmado que el cambio a
Nautilus no rompió nada más —

| Chequeo | Resultado |
|---|---|
| Sintaxis `hyprland.conf` | OK (`hyprctl reload` → `ok`) |
| Bind `SUPER+E` → `$fileManager` (nautilus) | OK, probado en vivo |
| `exec-once`: waybar, hyprpaper, hypridle, dunst, elephant, walker, blueman-applet, cliphist | Todos corriendo |
| Crashes nuevos desde el cambio | Ninguno |
| Logs de waybar/nautilus | Sin errores ni advertencias |

## 10. waybar: crash recurrente arreglado (módulo `mpd` sin MPD instalado)

**Síntoma (2026-09-14):** waybar se cerraba solo, dejando la barra caída
hasta relanzarla a mano.

**Diagnóstico:**

```
coredumpctl list                    # 5 crashes de waybar en 4 días (10, 13, 14 sep), misma firma
coredumpctl info <pid>               # backtrace: raise → abort → std::terminate() → __cxa_throw
                                      # (excepción de C++ sin capturar, no un simple cuelgue)
which mpd mpc                        # ninguno instalado
systemctl status mpd                 # "Unit mpd.service could not be found"
```

El `modules-right` de `config.jsonc` tenía el módulo `mpd` activo, pero MPD
**no está instalado en el sistema**. El módulo de waybar intenta conectarse
periódicamente a un servidor MPD inexistente vía libmpdclient — es una causa
de crash de waybar muy documentada en su repositorio, y coincide con la firma
del coredump (excepción no capturada en un hilo secundario del módulo, no en
el hilo principal de GTK, que seguía vivo).

Se descartó `custom/weather` (el otro módulo con `exec`/JSON) como sospechoso:
probado a mano (`bash ~/.config/waybar/weather.sh`), cae a un JSON de
respaldo válido ante fallo de red. Se blindó de todos modos por si `jq`
llegara a fallar (antes no comprobaba su código de salida).

**Solución aplicada:**

1. `~/.config/waybar/config.jsonc` — se quitó `"mpd"` de `modules-right`.
2. `~/.config/waybar/weather.sh` — ahora also cae a JSON seguro si `jq` falla.
3. **Red de seguridad** (por si otro módulo causa un crash en el futuro):
   `~/.config/hypr/scripts/waybar-restart.sh`, un bucle `while true; do waybar; sleep 1; done`
   que relanza waybar sola si se cae. `hyprland.conf` ahora arranca waybar a
   través de ese script en vez de directo:
   ```
   exec-once = ~/.config/hypr/scripts/waybar-restart.sh & ...
   ```

## 11. hyprpaper: crashes esporádicos + regresión nueva sin resolver (bug de `libhyprtoolkit`)

**Diagnóstico de los crashes históricos:** `coredumpctl` mostraba varios
crashes de hyprpaper (10 y 11 sep) con firma idéntica:

```
raise → libhyprtoolkit.so.5+0x75b7f  (mismo offset exacto las dos veces)
       (hilo "Hyprtoolkit8CBackend9enterLoopEv" — el loop de render/eventos de la libreria)
```

No es un `abort()` vía excepción de C++ (como waybar) — es un `raise()`
llamado directo desde dentro de `libhyprtoolkit`, la librería de UI/render
que usan las herramientas del ecosistema Hyprland (hyprpaper, hyprlock...).
Versión instalada (`0.8.4-8`) ya es la más reciente disponible en el repo —
no hay update que lo resuelva. No se encontró ninguna causa en
`hyprpaper.conf` (el wallpaper referenciado existe, la sintaxis es correcta);
es un bug interno de la librería, no de esta config.

**Mitigación aplicada** (mismo patrón que waybar):
`~/.config/hypr/scripts/hyprpaper-restart.sh` + `exec-once` a través de ese
script. Si vuelve a abortar, se relanza sola.

**Regresión nueva encontrada hoy (2026-09-14), sin resolver:** al matar y
relanzar hyprpaper para probar el wrapper, empezó a fallar **de forma
determinista** (4 de 4 intentos, incluso tras esperar 15s entre intentos):

```
[ERR from hyprtoolkit]: [EGL] Command eglQueryDevicesEXT errored out with EGL_BAD_ALLOC
Monitor eDP-1 has no target: no wp will be created
```

Se descartó que sea un problema de EGL a nivel de sistema:

```
eglinfo    # responde bien, Mesa/iris (Intel UHD 620), sin errores
lspci -k   # driver i915 cargado normal
lsof | grep /dev/dri   # solo 9 procesos con el dispositivo abierto, nada anómalo
```

`eglQueryDevicesEXT` es una llamada específica de enumeración de
dispositivos EGL (extensión `EGL_EXT_device_query`) — el resto del sistema
(Hyprland, Chrome, Nautilus) renderiza sin problema usando la vía normal de
plataforma (GBM/Wayland), así que el fallo está acotado a cómo
`libhyprtoolkit` enumera dispositivos, no al driver ni al hardware.

**Resuelto tras reinicio (2026-09-14, mismo día):** se dejó en negro/vacío
por los intentos de diagnóstico, documentado como pendiente de reinicio de
sesión. El usuario reinició el equipo poco después — confirmado en el
primer arranque limpio: `journalctl --user -b` sin ningún `EGL_BAD_ALLOC` ni
"no wp will be created", y tanto `waybar-restart.sh` como
`hyprpaper-restart.sh` arrancaron solos vía `exec-once` sin intervención,
validando también el wrapper de la sección anterior en un arranque real.
Confirma que era estado acumulado de la sesión, no un bug determinista de
la librería en sí — la mitigación con el wrapper de auto-reinicio se deja
puesta de todos modos, por si vuelve a aparecer.

**Alternativa a considerar si persiste tras reiniciar sesión:** `swaybg`
(demonio de wallpaper para Wayland, no usa `libhyprtoolkit`, mucho más
simple) como reemplazo de hyprpaper. No se instaló todavía — queda como
opción si el bug de `libhyprtoolkit` resulta no ser transitorio.

## 12. Waybar: rediseño estético (estilo Omarchy)

**Motivo:** la barra usaba el estilo de ejemplo por defecto de la wiki de
waybar — cada módulo con su propio color de fondo sólido (efecto arcoíris),
solo recoloreado a la paleta Catppuccin Mocha pero con la misma estructura.

**Qué propone Omarchy realmente** (revisado en su repo,
`github.com/omacom/omarchy`, `config/waybar/style.css`): **nada de cajas de
color por módulo.** Su regla base es:

```css
* {
  background-color: @background;
  color: @foreground;
  border: none;
  border-radius: 0;
  min-height: 0;
}
```

Un solo fondo y un solo color de texto para *toda* la barra. La separación
entre módulos es espaciado (`margin`), no color. El color solo aparece para
señalar un estado que importa de verdad —
`#custom-screenrecording-indicator.active { color: #a55555; }`— y se aplica
al texto/ícono, nunca como relleno de fondo. La fuente es un Nerd Font
monoespaciado (`JetBrainsMono Nerd Font` en su caso).

**Aplicado a tu `style.css`** (mismo principio, tu paleta Catppuccin Mocha,
tus módulos):

- Se quitó el `background-color` de cada módulo (`#cpu`, `#memory`,
  `#network`, `#pulseaudio`, `#battery`, `#tray`, etc.) — ahora todos
  comparten el fondo semitransparente de `window#waybar`.
- Los workspaces mantienen un indicador de "dónde estoy", pero como
  subrayado (`box-shadow: inset 0 -3px`), no como caja rellena — ya estaba
  así en parte, se limpió el resto para ser consistente.
- Los estados sí conservan color, pero como color de texto/ícono en vez de
  fondo: batería cargando (verde), red desconectada (rojo), silenciado
  (gris apagado), perfil de energía en rendimiento (rojo) o ahorro (verde),
  bloqueo de mayúsculas (amarillo). La única excepción que sigue
  parpadeando con fondo es la batería crítica — es la única alerta que de
  verdad justifica interrumpir.
- Fuente: `Hack Nerd Font` (ya instalada en el sistema, no hizo falta
  instalar `JetBrainsMono Nerd Font` para tener el mismo efecto de íconos).

## 13. Mejora pendiente aplicada: indicador de notificaciones (dunst) en waybar

Nuevo módulo `custom/notification` en `config.jsonc`, script en
`~/.config/waybar/indicators/notification.sh`:

```bash
dunstctl count history      # cuántas notificaciones hay en el historial
dunstctl is-paused           # si "No molestar" está activo
```

- Ícono normal cuando no hay nada pendiente.
- Ícono + color azul (clase `has-notifications`) cuando hay notificaciones
  en el historial — clic izquierdo hace `dunstctl history-pop` (reabre la
  última).
- Ícono + color amarillo (clase `dnd`) cuando "No molestar" está activo —
  clic derecho hace `dunstctl set-paused toggle`.
- Se actualiza solo cada 3 segundos (`"interval": 3`), suficiente para un
  indicador de estado sin necesidad de enganchar señales a dunst.

## 14. Mejora pendiente aplicada: Hyprlock con estética a juego

Antes no existía `~/.config/hypr/hyprlock.conf` — usaba el estilo por
defecto de hyprlock sin ningún ajuste. Se creó uno nuevo:

- `source = ~/.config/hypr/colors.conf` — reutiliza la misma paleta que
  Hyprland/waybar/dunst, un solo lugar para cambiar de tema.
- Fondo: el mismo wallpaper de hyprpaper, con blur y oscurecido (igual que
  el patrón típico de hyprlock).
- Reloj grande centrado (hora, y debajo la fecha en español), nombre de
  usuario, y campo de contraseña con los colores de la paleta (`$blue` para
  el borde, `$mauve` para "verificando", `$red` para fallo/mayúsculas).

**Sin probar en vivo a propósito:** activar el lock screen automáticamente
desde una sesión de agente no es prudente (si algo se renderiza mal, no hay
forma de que el agente lo destrabe). Pendiente de que el usuario lo pruebe
con `SUPER+L` y confirme que se ve bien; la vía de escape si algo saliera
mal es cambiar de TTY (`Ctrl+Alt+F2`) y matar `hyprlock` desde ahí.

## 15. Mejora pendiente aplicada: menú de control y portapapeles migrados a Walker

Ambos scripts seguían usando `wofi --dmenu` a pesar de tener Walker
instalado desde la sección 6. Confirmado que Walker cubre los dos casos:

- `walker --help-all` expone `-d/--dmenu`, compatible con el mismo patrón
  `printf "opciones" | <launcher> --dmenu` que ya se usaba con wofi — cambio
  de una sola palabra en `control-menu.sh`.
- El proveedor `clipboard` de Walker (`elephant-clipboard-bin`, ya instalado
  en la sección 6) lista, filtra y copia al portapapeles él mismo al pulsar
  Enter — no hace falta seguir encadenando `cliphist list | ... | cliphist
  decode | wl-copy` a mano. `clipboard-history.sh` quedó en una sola línea:
  `walker -m clipboard -p "Portapapeles"`.

`wofi` se mantiene instalado (por si se necesita para algo suelto en el
futuro) pero ya no lo usa ningún script de este setup.

## 16. Fix de espaciado: `keyboard-state` (Caps/Num pegados al ícono)

Al quitar las cajas de color en la sección 12 se eliminó por error el
padding interno entre las dos etiquetas que muestra el módulo
`keyboard-state` (Caps y Num son dos `<label>` separadas dentro del mismo
widget, cada una con su propio candado). Detectado por foto del usuario:
"Caps" y "Num" pegados a su ícono de candado sin espacio, foto adjunta en la
conversación. Arreglado devolviendo el padding, pero
como espaciado (no como fondo de color, para no romper el principio de la
sección 12):

```css
#keyboard-state > label {
    padding: 0 4px;
}
```

**Verificado en vivo:** waybar no recargó el CSS solo, hubo que matar el
proceso (`kill <pid>`) para que el wrapper de la sección 10 lo relanzara
con el cambio. Confirmado visualmente por el usuario tras el reinicio: el
espaciado quedó bien.

## Qué falta si quieres seguir profundizando

- Probar `hyprlock` en vivo (`SUPER+L`) y ajustar posiciones/tamaños a gusto
  — se hizo a ciegas por prudencia (ver sección 14).
- Si se instala MPD en el futuro, el módulo `mpd` de waybar se puede volver
  a añadir a `modules-right` sin más — la config del módulo no se borró,
  solo se quitó de la lista activa.
