# Teclado Logitech K380 — ficha de referencia

Exportado desde `napoleon-aspiree5476g` (donde funciona aceptablemente) el
2026-09-14, para diagnosticar por qué falla en Sway en la Toshiba. Si estás
leyendo esto desde una sesión de Claude en la Toshiba: la idea es comparar
punto por punto contra lo que veas ahí con los mismos comandos.

## 1. Identificación del dispositivo

```
Nombre reportado por el kernel: Keyboard K380 Keyboard
Nombre reportado por Bluetooth:  Keyboard K380
Bus:                              Bluetooth (bustype 0005)
Vendor:Product (hex):             046d:b342   (046d = Logitech)
Vendor:Product (decimal):         1133:45890
Version:                          4201
MAC del dispositivo (uniq):       F4:73:35:92:09:CC
Driver del kernel:                hid-generic (vía uhid, HID sobre Bluetooth normal —
                                   NO es un receptor Unifying/USB, es Bluetooth directo)
```

Comando para reobtenerlo en cualquier máquina Linux:

```bash
grep -l "K380" /sys/class/input/event*/device/name
cat /sys/class/input/eventNN/device/uevent   # NN = el que encontró el grep de arriba
udevadm info /sys/class/input/eventNN
```

## 2. Emparejamiento Bluetooth (aquí)

```
$ bluetoothctl info F4:73:35:92:09:CC

Paired: yes
Bonded: yes
Trusted: yes
Blocked: no
Connected: yes
Class: 0x00000540 (1344)
Icon: input-keyboard
UUID: Human Interface Device (00001124-0000-1000-8000-00805f9b34fb)
Modalias: usb:v046DpB342d4201
```

Si en la Toshiba el problema es que el teclado se desconecta, tarda en
reconectar, o pierde teclas al reconectar — eso es capa Bluetooth/kernel,
no de Sway ni de xkb. Comparar `Trusted`/`Bonded` ahí; si `Trusted: no`,
correr `bluetoothctl trust F4:73:35:92:09:CC`.

## 3. Configuración de teclado usada aquí (Hyprland)

**No hay ningún mapeo especial para el K380.** Es la config global de
siempre, la misma que usan todos los teclados del sistema:

```
# ~/.config/hypr/hyprland.conf
input {
    kb_layout = es
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =
}
```

Confirmado con `hyprctl devices` — el K380 (identificador interno
`keyboard-k380-keyboard`) reporta `rules: l "es"`, `active keymap: Spanish`,
igual que el teclado interno del portátil.

## 4. Equivalente en Sway

```
# ~/.config/sway/config
input "type:keyboard" {
    xkb_layout es
}
```

O apuntado solo al K380 (formato de Sway: `vendor:producto:Nombre_con_guiones_bajos`):

```
input "1133:45890:Keyboard_K380_Keyboard" {
    xkb_layout es
}
```

**Verificar el identificador real en la Toshiba** (puede variar un poco de
formato entre versiones de Sway/wlroots):

```bash
swaymsg -t get_inputs
```

## 5. Si el layout ya está bien pero algo más falla

Como aquí no hay ningún ajuste fuera de lo normal, si en la Toshiba el
K380 sigue sin funcionar bien después de poner `xkb_layout es`, el
problema no es de mapeo de teclas — hay que mirar otra capa. Con esto
puedes comparar:

```bash
# Capacidades de teclas que el kernel detecta (deberia verse igual)
cat /sys/class/input/eventNN/device/uevent
```

Salida de referencia aquí (2026-09-14):

```
PRODUCT=5/46d/b342/4201
NAME="Keyboard K380 Keyboard"
PHYS="50:5b:c2:9d:29:8a"
UNIQ="f4:73:35:92:09:cc"
PROP=0
EV=12001b
KEY=40000000000000 0 1000002000007 ff9f307ac1405fff febeffdfffefffff fffffffffffffffe
ABS=10000000000
MSC=10
LED=1f
MODALIAS=input:b0005v046DpB342e4201-e0,1,3,4,11,14,k71,72,73,74,75,77,79,7A,7B,7C,7D,7E,7F,80,81,82,83,84,85,86,87,88,89,8A,8B,8C,8E,96,98,9E,9F,A1,A3,A4,A5,A6,AC,AD,B0,B1,B2,B3,B4,B7,B8,B9,BA,BB,BC,BD,BE,BF,C0,C1,C2,D9,F0,176,ra28,m4,l0,1,2,3,4,sfw
```

Si el `KEY=` bitmap sale distinto en la Toshiba, el kernel/hwdb de esa
máquina está viendo un set de teclas diferente — eso apunta a una versión
de kernel/udev-hwdb desactualizada ahí, no a nada de Sway.
