---
layout: "../layouts/Base.astro"
title: "Mostrar las 2 barras en ambas pantallas con una tecla"
subtitle: "KDE Plasma · Barras en 2 pantallas"
page: "barras-pantallas"
prose: true
---

# PENDIENTE · Mostrar las 2 barras en ambas pantallas con una tecla

> **Para hacer mañana** · Fecha del estudio: 11/08/2026 · KDE Plasma 6.7.4 · Arch Linux · Wayland
> Contexto: IdeaPad 60%, 2 pantallas (eDP-1 laptop + HDMI-A-1 externa).

---

## 1. El objetivo (lo que pidió Emerson, literal)

1. Que la **barra superior** (reloj, bandeja, monitores, menú global) y la **barra de apps** (launcher/tarea)
   se muestren **igual que se muestra ahora la superior**: al mantener una tecla/comando aparecen, al soltarla se ocultan.
2. Que esto funcione en **las dos pantallas**, no solo en la principal.
3. Que el comando muestre las barras **en la pantalla donde está el cursor** (no el Overview de `Super`, que muestra apps y ventanas).

Nota importante del usuario: `Super` ya enseña las barras pero **también el Overview (las apps)**.
Él quiere **solo las barras**.

---

## 2. Estado actual del sistema (verificado)

| Pantalla | Descripción | Containment |
|---|---|---|
| Pantalla principal (eDP-1, **screen 0**) | Barra superior: reloj, bandeja, monitores, appmenu | `[Containments][55]` (ubicación `3` = Top) |
| Pantalla principal | Barra de apps/tareas | `[Containments][57]` (ubicación `4` = Bottom) |
| Pantalla externa (HDMI-A-1, **screen 1**) | Solo el escritorio/fondo | `[Containments][92]` (folder) |

- Archivo de configuración: `~/.config/plasma-org.kde.plasma.desktop.appletsrc`
- Las barras (55 y 57) existen **solo en la pantalla 0** → por eso solo aparecen ahí al pasar el ratón por el borde.
- Contenido del panel 55: Kickoff (menú), appmenu (menú global), systemtray (batería, bluetooth, red, volumen, brillo, portapapeles, notificaciones, clima, etc.), monitores de disco/RAM/CPU, reloj digital (`applet 91`), separadores. `AppletOrder=56;59;91;62;61;84;83;82;76;78`.
- Contenido del panel 57: solo `icontasks` con launchers (systemsettings, code, brave).

### Geometrías reales (kscreen-doctor)

- HDMI-A-1 (externa): `Geometry: 0,0 1920x1080` → está **a la izquierda**.
- eDP-1 (laptop): `Geometry: 1920,0 1746x1091`, `Scale: 1.1` → a la **derecha** (1746x1091 ya es el tamaño lógico: 1920/1.1 y 1200/1.1).
- `xdotool getmouselocation --shell` funciona en Wayland-KDE y devuelve coordenadas **globales** (ej. probado: `X=3345 Y=509` ⇒ cursor en la pantalla de la laptop, X≥1920).

---

## 3. Atajos globales relevantes (kglobalshortcutsrc)

| Tecla | Ocupada por |
|---|---|
| `Alt+F4` | Cerrar ventana (default KWin) |
| `Meta+Q` | **Actividades** (`manage activities` → switcher de escritorios) ← por eso "abre los escritorios" |
| `Meta+W` | **Overview / cuadrícula de escritorios** |
| `Meta+D` | Mostrar escritorio |
| `Meta+B` | Perfil de energía |
| `Ctrl+Esc` | **Libre** ← candidata elegida para mantener=m/liviano |
| `Ctrl+Alt+H`, `Ctrl+Shift+Esc`, `Ctrl+Alt+U`, `Ctrl+Alt+Y`, `Ctrl+Alt+G` | **Libres** (alternativas) |
| `Meta+F` | **Libre** → ya se asignó a **Cerrar ventana** (2º atajo) |

---

## 4. Lo que se descubrió (importante para mañana)

### 4.1 `evaluateScript` de plasmashell devuelve vacío en 6.7.4
- Comando probado: `qdbus6 --literal org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript '<codigo>'`
- **Resultado**: devuelve `""` para TODO, incluso `'1+1'`, `'"hola"'`, `panelById(55).id`.
- El método existe en D-Bus y `dumpCurrentLayoutJS()` sí funciona (devuelve la serialización del layout).
- Conclusión: **NO confiar en `evaluateScript` para el `.show()/.hide()` de paneles** en esta versión.
  Probar alternativas ANTES de montar nada (ver sección 6).

### 4.2 El grupo `input` es necesario para leer el teclado con evdev
- Dispositivos: `/dev/input/event*` → permisos `crw-rw---- root input`.
- El usuario **no está en el grupo `input`** (solo `emerson docker wheel`).
- `from evdev import list_devices()` devuelve `[]` sin permiso.
- Solución: `sudo usermod -aG input emerson` + **cerrar sesión** (o `newgrp input` en la terminal para probar al momento).

### 4.3 xdotool SÍ funciona en este Wayland-KDE
- `xdotool getmouselocation --shell` → da `X=... Y=...` global correcto (KDE mantiene el puntero global en XWayland).
- No hay que instalar nada extra: ya instalado.

### 4.4 Comportamiento raro del sandbox (lección para el equipo)
- Durante la prueba, `~/.config/plasma-org.kde.plasma.desktop.appletsrc` se volvió **ilegible de forma intermitente** desde bash
  (aparecía en `ls` pero `cat`/`stat`/`open` daban `No such file or directory`, o `0` bytes).
- Coincidió con el apagado de plasmashell (guardado atómico del config con rename).
- La herramienta `Read`/`Edit` del IDE sí lo veía; el bash no. **Regla práctica**: para editar el config de Plasma,
  reiniciar plasmashell y verificar por DUPLICADO (Read + bash); si hay incoherencia, esperar unos segundos y reintentar.

### 4.5 Cómo reiniciar plasmashell sin romper nada
```bash
kquitapp6 plasmashell            # cierre ordenado
# esperar a que muera:  for i in $(seq 1 15); do pgrep -x plasmashell >/dev/null || break; sleep 1; done
setsid nohup plasmashell >/tmp/plasmashell.log 2>&1 &
qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.shell   # debe decir org.kde.plasma.desktop
```
- ⚠️ Si el escritorio "no se ve", casi siempre es que plasmashell está muerto → relanzarlo con lo anterior.
- ⚠️ Siempre hacer backup antes: `cp ~/.config/plasma-org.kde.plasma.desktop.appletsrc ~/.config/appletsrc.bak.$(date +%Y%m%d)`

---

## 5. Plan propuesto (para mañana) — PASO A PASO

### Fase A — Barras duplicadas en la pantalla externa
1. Backup del config.
2. Detener plasmashell.
3. Editar `plasma-org.kde.plasma.desktop.appletsrc`:
   - Clonar bloque `[Containments][55]` → `[Containments][93]`:
     - `lastScreen=0` → `lastScreen=1` (solo la cabecera del containment, NO las internas).
     - `global=Alt+F1` (kickoff) → `global=` para no duplicar el atajo del menú.
   - Clonar bloque `[Containments][57]` → `[Containments][94]`:
     - `lastScreen=0` → `lastScreen=1`.
4. Arrancar plasmashell y verificar que aparecen 93 y 94 (con `dumpCurrentLayoutJS`).
   - Datos ya preparados: bloque clon de 55 completo y de 57 completo (ver historial del edit del día 11/08).

### Fase B — Comando "mantener = mostrar / soltar = ocultar" (daemon evdev)
1. Hecho ya: `sudo pacman -S python-evdev xdotool`.
2. **Pendiente**: `sudo usermod -aG input emerson` + relogin (necesario, ver 4.2).
3. Daemon `~/.local/bin/mostrar-barras.py`:
   - Escucha en todos los teclados (`evdev.list_devices`, filtrar por capacidad KEYBOARD).
   - Detecta **abajo/arriba** de `Ctrl`izq + `Esc` (y opcional `CtrlAlt+H`).
   - Al mantener → detectar pantalla del cursor→ mostrar barras de esa pantalla.
   - Al soltar → ocultar esas barras.
4. Servicio systemd de usuario `~/.config/systemd/user/barras.service`:
   ```ini
   [Unit]
   Description=Mostrar barras al mantener Ctrl+Esc
   After=graphical-session.target

   [Service]
   Type=simple
   ExecStart=/usr/bin/python3 %h/.local/bin/mostrar-barras.py
   Restart=on-failure

   [Install]
   WantedBy=default.target
   ```
   ```bash
   systemctl --user daemon-reload && systemctl --user enable --now barras
   ```

### Fase C — Definir "pantalla del cursor"
Orden de preferencia (probar el 1º, si falla el 2º):
1. `xdotool getmouselocation --shell` + geometrías de `kscreen-doctor -o`
   (mapeo conocido: X<1920 ⇒ externa=screen1; X>=1920 ⇒ laptop=screen0; OJO si cambias la disposición).
2. KWin script que exponga `workspace.cursorPos` por D-Bus.
3. Fallback: mostrar en **ambas** pantallas (más simple, funcionaría siempre).

---

## 6. Qué verificar ANTES de implementar (para no repetir el desastre)

1. [ ] ¿`evaluateScript` funciona tras un **reinicio completo de plasmashell**? (re-probuilder: `qdbus6 --literal ... evaluateScript '1+1'`).
2. [ ] Si `evaluateScript` sigue vacío → ¿hay modo de mostrar/ocultar panel sin él?
   - Ideas a probar: `kwin` script con `callDBus`; objeto D-Bus de cada panel; atajo nativo KWin "Cerrar ventana" style.
3. [ ] Probar `.show()/.hide()` MECÁNICAMENTE sobre un panel real antes de tocar el config (sin editar archivos).
4. [ ] Pisar el `input` group y comprobar `python3 -c "from evdev import list_devices; print(list_devices())"` (debe listar eventos).
5. [ ] Confirmar con el usuario qué prefieren para el mapeo de pantalla (option C1/C2/C3).

---

## 7. Comandos útiles (cheat sheet)

```bash
# Geometría de pantallas
kscreen-doctor -o

# Posición global del cursor
xdotool getmouselocation --shell

# Estado de plasmashell en DBus
qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.shell

# Dump del layout cargado (verificar paneles)
qdbus6 --literal org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.dumpCurrentLayoutJS

# Panel ids en el config
grep -n "^\[Containments\]\[5\|^\[Containments\]\[9" ~/.config/plasma-org.kde.plasma.desktop.appletsrc

# Grupo input + teclados
groups
cat /proc/bus/input/devices | grep -A1 "Keyboard"
```

---

## 8. Decisiones pendientes del usuario

- Tecla definitiva: **`Ctrl+Esc`** (recomendada) o `Ctrl+Alt+H` (respaldo). ⏳ confirmar.
- ¿Las barras en la 2ª pantalla deben tener **los mismos widgets** (reloj, bandeja completa, monitores) o versión minimalista?
- Comportamiento del cursor: pantalla exacta vs ambas.