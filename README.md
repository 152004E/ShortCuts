# 💻 MySetup (SenaFactory Dotfiles)

Bienvenido a mi entorno personal de desarrollo en Linux. 

Este repositorio contiene la arquitectura completa de mi sistema operativo (**Fedora Linux 44 - KDE Plasma**), incluyendo mis aplicaciones de uso diario, atajos de teclado personalizados, automatizaciones y configuraciones de terminal para desarrollo frontend.

---

## 🚀 ¿Qué es esto?
En el mundo del desarrollo, a este tipo de repositorios se les llama **Dotfiles**. Sirven para que, si algún día formateas tu computadora o compras una nueva, puedas clonar este repositorio y recuperar todo tu entorno de trabajo (colores, fuentes, atajos, programas) en cuestión de segundos, sin tener que configurarlo a mano.

## 📂 Estructura del Proyecto

El repositorio está dividido en dos grandes secciones para mantenerlo ordenado:

### 1. `configs/` (El Motor)
Aquí viven todos los scripts automatizados y las configuraciones exportadas del sistema.
- **Instalador Automático (`install.sh`)**: Script maestro que instala y vincula todo.
- **KDE Plasma**: Respaldo maestro de atajos globales de escritorio (`.kksrc`).
- **Scripts Nativos**: Trucos lógicos de Bash (ej. integración con Dolphin vía D-Bus para abrir editores).
- **Entorno de Terminal**: Temas y ajustes para **Ghostty**, **Starship** y **Bash**.
- *(Puedes leer `configs/README.md` para una explicación paso a paso de cada carpeta)*.

### 2. `docs/` (La Base de Conocimiento)
Toda mi documentación técnica, trucos y tutoriales extraídos en formato Markdown puro:
- **`apps/`**: Inventario del software y comandos de instalación (Brave, VLC, Node, pnpm).
- **`desktop/`**: Guías de GNOME, KDE, barras de tareas y mis atajos de teclado.
- **`ides/`**: Integración profunda con VS Code, JetBrains y Antigravity.
- **`terminal/`**: Guía extensa sobre el funcionamiento de Ghostty.

## ⚙️ Instalación en una PC Nueva

Si estás en un sistema limpio (preferiblemente basado en Fedora/Arch con KDE), sigue estos pasos:

1. **Clona este repositorio:**
   ```bash
   git clone https://github.com/SenaFactory/MySetup.git
   cd MySetup
   ```

2. **Ejecuta el instalador mágico:**
   ```bash
   cd configs
   ./install.sh
   ```
   *(El script instalará las fuentes Nerd Fonts, configurará Ghostty, Starship, Bash, y creará los comandos globales para editores en `~/.local/bin/`).*

3. **Importa tus atajos de teclado:**
   - Ve a los ajustes de sistema de KDE.
   - En la sección de Atajos Globales, importa el archivo `configs/kde/MIsShortCuts.kksrc`.

## 📜 Reglas del Repositorio (Agentes de IA)
Este repositorio está diseñado para ser operado en compañía de asistentes de código avanzados. El archivo `AGENTS.md` incluye el marco normativo (uso estricto de `pnpm`, protecciones de sistema y comandos seguros) que los agentes deben respetar al interactuar con esta máquina.