# Registro de Configuración, Problemas y Soluciones en KDE Plasma 6 (Fedora 44)

Documento de referencia para el entorno de escritorio personal: especificaciones técnicas del hardware, temas instalados, problemas encontrados durante la personalización y sus soluciones técnicas definitivas.

---

## 1. Ficha Técnica del Sistema

* **Sistema Operativo:** Fedora Linux 44 (KDE Plasma Desktop Edition)
* **Versión de Plasma:** KDE Plasma 6.7.4 sobre Wayland (`kwin_wayland`)
* **Frameworks y Qt:** Qt 6.x / KDE Frameworks 6.x
* **Herramientas del sistema:** `kpackagetool6`, `qdbus-qt6`, `python3`, `jq`, `zip`
* **Procesador Gráfico (GPU):** Gráfica integrada **Intel UHD Graphics 630 (CFL GT2)** con Mesa 26.1.8

---

## 2. Componentes Instalados

1. **Tema Global macOS Tahoe Liquid:**
   * Repositorio: `lestercorderomurillo/macos-tahoe-liquid-kde`
   * Componentes: Esquemas de color, decoraciones de ventana Aurorae (`MacTahoeLiquidKde-Dark`), estilo de aplicaciones Qt Kvantum (`mac-tahoe-liquid-kdeDark`), cursores e iconos.
2. **Widgets Oficiales Liquid Glass:**
   * Repositorio: `jaxparrow07/liquidglass-kde-widgets`
   * Componentes: 14 plasmoides instalados en `~/.local/share/plasma/plasmoids/` (relojes, reproductor con shaders dinámicos de vidrio líquido, clima, calendario y temporizador).

---

## 3. Registro de Problemas y Soluciones Técnicas

### Problema 1: El tema quedó en Modo Claro (Light) en lugar de Oscuro (Dark)
* **Causa:** El instalador del tema aplicó por defecto la variante clara (`MacTahoeLiquidKdeLight`) y el servicio de conmutación horaria por systemd estaba inactivo.
* **Solución:**
  Se ejecutó el script de conmutación oficial del tema en espacio de usuario:
  ```bash
  ~/.local/bin/mac-tahoe-theme-switch dark
  ```
  Esto actualizó de forma sincronizada el Look and Feel (`org.kde.mac-tahoe-liquid-kde.dark`), el esquema de colores (`MacTahoeLiquidKdeDark`), el tema de Plasma (`MacTahoeLiquidKde-Dark`), Kvantum y las decoraciones de ventana a modo oscuro permanente.

---

### Problema 2: La barra superior estaba fija en transparente ("Opaco adaptable" no funcionaba)
* **Causa:** El instalador del tema había añadido a la barra superior (Containment 118) un plugin llamado **`Panel Colorizer`** (`luisbocanegra.panel.colorizer`). Este plugin estaba configurado con `hideWidget: true` (invisible en el modo edición) y forzaba `opacity: 0` directamente en el motor de renderizado de la barra, cancelando cualquier opción de opacidad nativa de KDE Plasma.
* **Solución:**
  1. Se cerró `plasmashell` limpiamente (`qdbus-qt6 org.kde.plasmashell /MainApplication quit`).
  2. En `~/.config/plasma-org.kde.plasma.desktop-appletsrc`, se eliminó el bloque de `Panel Colorizer` (Applet 119) y se retiró del `AppletOrder`.
  3. En `~/.config/plasmashellrc`, bajo `[PlasmaViews][Panel 118]`, se configuró `panelOpacity=0` (Opaco adaptable nativo).
  4. Se reinició `plasmashell` (`kstart /usr/bin/plasmashell`).
* **Resultado:** La barra ahora es translúcida cuando el escritorio está vacío y se vuelve sólida y opaca automáticamente en cuanto una ventana la toca o se maximiza.

---

### Problema 3: Rendimiento lento, con tirones y lag gráfico ("trabado")
* **Causa:** Al contar el equipo con una gráfica integrada **Intel UHD Graphics 630**, el efecto de KWin `liquidglass` activó shaders multi-pasada excesivamente pesados (generación de ruido por píxel, aberración cromática e iridiscencia, y desenfoque forzado sobre todas las ventanas del sistema, incluso aplicaciones sólidas como navegadores o terminales).
* **Solución:**
  En `~/.config/kwinrc`, dentro de la sección `[Effect-liquidglass]`, se aplicaron las siguientes optimizaciones:
  ```ini
  [Effect-liquidglass]
  NoiseStrength=0
  IridescenceStrength=0
  RgbRinging=0
  MagnifyGlassStrength=0
  BlurNonMatching=false
  GlassInactiveWindows=false
  BlurStrength=4
  ```
  Se aplicaron los cambios en vivo sin cerrar sesión:
  ```bash
  qdbus-qt6 org.kde.KWin /KWin reconfigure
  ```
* **Resultado:** Se eliminó la sobrecarga en la GPU Intel. El entorno y las animaciones ahora funcionan fluidos a 60 FPS estables manteniendo los bordes de vidrio y el desenfoque en los paneles y ventanas que lo solicitan.

---

### Problema 4: El Dock no se veía al abrir ventanas
* **Causa:** El diseño del tema fijó el Dock con `panelVisibility=2` (`dodgewindows` / esquivar ventanas). Al tener una ventana maximizada o cerca del borde inferior, el Dock se oculta para no estorbar.
* **Solución:** Llevar el cursor al borde inferior de la pantalla o cambiar la visibilidad a "Siempre visible" si se desea un dock estático.

---

### Problema 5: En el Dock se veían aplicaciones de otros escritorios virtuales
* **Causa combinada:**
  1. El administrador de tareas no tenía activo el filtro por escritorio virtual.
  2. La aplicación (por ejemplo, Brave Browser) estaba anclada como lanzador permanente (`launchers=preferred://browser`). Al ser un lanzador anclado fijo, el icono nunca se retiraba del dock y mostraba el punto de ejecución (`•`) porque la app estaba abierta en el Escritorio 1.
* **Solución:**
  1. En `~/.config/plasma-org.kde.plasma.desktop-appletsrc`, bajo `[Containments][139][Applets][142][Configuration][General]`, se configuró:
     * `showOnlyCurrentDesktop=true` (mostrar solo tareas del escritorio virtual activo).
     * `launchers=` (vaciado de lanzadores fijos para convertir el Dock en una barra 100% dinámica).
  2. Se recargó `plasmashell`.
* **Resultado:** Si estás en el Escritorio 2 con VS Code y Antigravity, el Dock **solo** muestra VS Code y Antigravity. Brave desaparece por completo del dock y únicamente aparece cuando cambias al Escritorio 1.
