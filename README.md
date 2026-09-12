# 💻 workspace-config - Mi Entorno de Trabajo

Bienvenido a mi entorno personal de desarrollo en Linux. 

Este repositorio no es solo una colección de atajos; es mi **zona de confort**. Aquí centralizo absolutamente toda la arquitectura de mi sistema operativo (**Fedora Linux - KDE Plasma**), mis herramientas de trabajo diario, mi flujo de terminal y la configuración exacta de mis editores de código para sentirme como en casa en cualquier computadora.

---

## 🚀 ¿Qué es esto?
En el mundo de la ingeniería de software, a este tipo de repositorios se les llama **Dotfiles**. Sirven como un "respaldo maestro". Si algún día formateo mi computadora o empiezo a trabajar en una PC nueva, solo tengo que clonar este repositorio y recuperar todo mi flujo de trabajo (colores, fuentes tipográficas, atajos de teclado, automatizaciones y programas) en cuestión de segundos, sin tener que configurarlo a mano.

## 📂 Estructura del Proyecto

El repositorio está dividido en dos grandes secciones para mantenerlo ordenado:

### 1. `configs/` (El Motor)
Aquí viven todos los scripts automatizados y las configuraciones exportadas del sistema.
- **Instalador Automático (`install.sh`)**: Script maestro que instala y vincula todas las configuraciones.
- **KDE Plasma**: Respaldo maestro de atajos globales de escritorio (`.kksrc`).
- **Scripts Nativos**: Trucos lógicos de Bash (ej. integración con Dolphin vía D-Bus para abrir editores directamente en la carpeta actual).
- **Entorno de Terminal**: Temas, tipografías con ligaduras y ajustes para **Ghostty**, **Starship** y **Bash**.
- **Editores**: Configuraciones avanzadas para VS Code y Antigravity IDE.
- *(Puedes leer `configs/README.md` para una explicación paso a paso de cada carpeta)*.

### 2. `docs/` (La Base de Conocimiento)
Toda mi documentación técnica, trucos y tutoriales extraídos en formato Markdown puro:
- **`apps/`**: Inventario del software y comandos de instalación (Brave, VLC, Node, pnpm).
- **`desktop/`**: Guías de GNOME, KDE, barras de tareas y mis atajos de teclado.
- **`ides/`**: Integración profunda con VS Code, JetBrains y Antigravity.
- **`terminal/`**: Guía extensa sobre el funcionamiento y personalización de Ghostty.

## ⚙️ Instalación en una PC Nueva

Si estás en un sistema limpio (Linux con KDE Plasma), sigue estos pasos para replicar mi entorno:

1. **Clona este repositorio:**
   ```bash
   git clone https://github.com/TU-USUARIO/workspace-config.git
   cd workspace-config
   ```

2. **Ejecuta el instalador mágico:**
   ```bash
   cd configs
   ./install.sh
   ```
   *(El script instalará las fuentes Nerd Fonts, configurará Ghostty, Starship, Bash, y creará los comandos globales para editores en `~/.local/bin/`).*

3. **Importa los atajos de teclado:**
   - Ve a los ajustes de sistema de KDE.
   - Entra a **Teclado > Atajos** (Shortcuts).
   - Haz clic en **Import...** y selecciona el archivo `configs/kde/MIsShortCuts.kksrc`.
   - Dale a **Apply** y listo.

## 📜 Reglas del Repositorio (Agentes de IA)
Este repositorio está diseñado para ser operado en compañía de asistentes de código avanzados (Antigravity). El archivo `AGENTS.md` incluye el marco normativo estricto (uso exclusivo de `pnpm`, protecciones de sistema operativo y comandos seguros) que los agentes deben respetar sin excepción al interactuar con esta máquina.