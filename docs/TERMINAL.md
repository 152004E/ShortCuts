# Guía de Configuración de Terminal Profesional (Ghostty + Starship)

Esta guía documenta la configuración del entorno de terminal profesional utilizado en el sistema, basado en **Ghostty**, el motor de prompt **Starship** y la tipografía **JetBrainsMono Nerd Font**.

---

## 1. Características Principales

- **Detección de Entornos:**
  - **Node.js:** Muestra el icono `󰎙` y la versión de Node instalada/activa automáticamente cuando el directorio contiene un `package.json`, `.nvmrc` o archivos JS/TS.
  - **Git:** Muestra la rama actual (` main`), commits adelante/atrás (`⇡1`, `⇣2`), y estado de cambios (`!` modificado, `?` sin rastrear, `+` en stage).
  - **Gestor de paquetes:** Muestra el paquete y versión de `pnpm` o `npm`.
  - **Tiempo de ejecución:** Informa cuánto tardó la última ejecución si superó los 2 segundos (`took 2.4s`).
- **Tema Visual:** Paleta **Catppuccin Mocha** coherente en terminal, prompt y editores de código.
- **Tipografía y Glifos:** **JetBrainsMono Nerd Font** con soporte completo de ligaduras de código (`!=`, `===`, `=>`).
- **Instalación 100% en espacio de usuario:** No requiere permisos de `sudo` ni altera paquetes de la distribución base.

---

## 2. Estructura de Archivos (Dotfiles)

Los archivos de configuración se encuentran respaldados en este repositorio bajo la carpeta `configs/`:

```text
ShortCuts/configs/
├── ghostty/
│   └── config                  # Configuración de Ghostty (~/.config/ghostty/config)
├── starship/
│   └── starship.toml           # Configuración del prompt (~/.config/starship.toml)
├── vscode/
│   └── settings.json           # Integración para VS Code / Antigravity IDE
├── bash/
│   └── bashrc_snippet.sh       # Snippet de inicialización en ~/.bashrc
└── install.sh                  # Script de instalación automática
```

---

## 3. Instalación Rápida en una Nueva Máquina

Para replicar exactamente esta configuración en cualquier máquina Linux:

```bash
# 1. Navegar al repositorio
cd ~/Documentos/MyProjects/ShortCuts

# 2. Dar permisos y ejecutar el instalador
chmod +x ./configs/install.sh
./configs/install.sh

# 3. Recargar la terminal
source ~/.bashrc
```

El script se encarga de:
1. Crear los directorios `~/.local/bin`, `~/.local/share/fonts` y `~/.config/ghostty`.
2. Descargar e instalar los archivos `.ttf` de **JetBrainsMono Nerd Font** y actualizar `fc-cache`.
3. Descargar el binario oficial de **Starship** en `~/.local/bin/starship`.
4. Copiar los archivos `starship.toml` y `config` a sus ubicaciones de usuario.
5. Inyectar `eval "$(starship init bash)"` en `~/.bashrc`.

---

## 4. Configuración en Editores (VS Code / Antigravity IDE)

Para que la terminal integrada de tu editor utilice la misma fuente y reconozca los iconos de Starship:

Abre la configuración de usuario (`Ctrl + Shift + P` ➔ `Preferences: Open User Settings (JSON)`) y añade:

```json
{
  "terminal.integrated.fontFamily": "'JetBrainsMono Nerd Font', monospace",
  "terminal.integrated.fontSize": 12,
  "terminal.external.linuxExec": "ghostty"
}
```

---

## 5. Personalización de Starship

El archivo de configuración se encuentra en `~/.config/starship.toml`. Si deseas personalizar elementos:

- **Cambiar el símbolo del prompt:** Edita la sección `[character]` (por defecto usa `❯`).
- **Modificar colores:** Starship admite nombres o códigos HEX compatibles con Catppuccin (`#89b4fa`, `#a6e3a1`, `#f38ba8`, `#cba6f7`).
- **Verificar la configuración:** Ejecuta `starship print-config` para comprobar la sintaxis.
