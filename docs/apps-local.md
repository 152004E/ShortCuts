# Aplicaciones de Uso Frecuente (PC Local)

Este documento contiene el inventario del software principal utilizado en este equipo. Está configurado sobre **Fedora Linux 44 (KDE Plasma)**, por lo que los comandos de instalación son específicos para este sistema.

## 1. Uso Diario y Productividad

### Brave Browser
Navegador web principal, enfocado en privacidad y bloqueo de anuncios nativo.
- **Instalación:**
  ```bash
  sudo dnf install dnf-plugins-core
  sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
  sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
  sudo dnf install brave-browser
  ```

### Dolphin
El potente gestor de archivos nativo de KDE Plasma. Lo usamos en conjunto con scripts de D-Bus (`qdbus6`) para detectar la ruta actual y abrir editores dinámicamente.
- **Instalación:** Preinstalado con Fedora KDE.
  ```bash
  sudo dnf install dolphin
  ```

### VLC Media Player
Reproductor multimedia ligero y altamente compatible con múltiples formatos.
- **Instalación:**
  ```bash
  sudo dnf install vlc
  ```

## 2. Terminal y Entorno de Línea de Comandos

### Ghostty
Emulador de terminal principal, optimizado para alto rendimiento y renderizado por GPU.
- **Instalación:**
  ```bash
  sudo dnf copr enable pgdev/ghostty
  sudo dnf install ghostty
  ```

### Starship
Prompt minimalista y rápido utilizado para la terminal (provee métricas en tiempo real de Git y Node).
- **Instalación:**
  ```bash
  curl -sS https://starship.rs/install.sh | sh
  ```

## 3. Entorno de Desarrollo y Código

### Visual Studio Code
El editor de código principal. Se configura junto con fuentes *JetBrainsMono Nerd Font* para soportar íconos en la terminal integrada.
- **Instalación:**
  ```bash
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  sudo dnf install code
  ```

### JetBrains IDEA
Entorno de desarrollo avanzado (IDE) utilizado como alternativa pesada para desarrollo backend o full-stack.
- **Instalación:** Generalmente instalado de forma local a través de JetBrains Toolbox o un archivo tar.gz (se lanza a través de `jetbrains-idea.desktop`).

### Google Antigravity IDE & CLI (`agy`)
Tu asistente de inteligencia artificial para pair-programming y generación de código.
- **Instalación:** Descarga del binario oficial y ejecución en Sandbox.

## 4. Dependencias del Sistema (Backend)

### Node.js & pnpm
El entorno de ejecución de JavaScript, utilizado principalmente para el frontend (Astro). **Regla estricta del proyecto:** Uso exclusivo de `pnpm` (prohibido `npm`).
- **Instalación:**
  ```bash
  sudo dnf install nodejs
  curl -fsSL https://get.pnpm.io/install.sh | sh -
  ```

### Git
Sistema de control de versiones.
- **Instalación:**
  ```bash
  sudo dnf install git
  ```
