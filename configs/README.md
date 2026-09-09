# 🛠️ Carpeta de Configuraciones (Configs)

¡Hola! Si eres nuevo aquí o simplemente no recuerdas para qué sirve todo esto, no te preocupes. **Esta carpeta es el corazón de tu sistema.**

Aquí guardamos todos los "planos" y ajustes para que tu computadora, tu terminal y tus editores de código funcionen y se vean exactamente como a ti te gusta, sin tener que configurarlos a mano uno por uno.

## 🚀 ¿Cómo se usa todo esto?
¡Es automático! No tienes que copiar los archivos uno por uno. 
Solo debes abrir tu terminal y ejecutar el instalador maestro que está aquí mismo:

```bash
cd configs
./install.sh
```
*(Ese script hará todo el trabajo aburrido por ti: instalará las fuentes de texto, configurará la terminal, instalará los comandos y dejará tu PC lista para programar).*

---

## 📂 ¿Qué hay dentro de cada carpeta?
Por si tienes curiosidad de saber dónde vive cada cosa, aquí tienes una explicación sencilla:

- **`bash/`** 
  Contiene un pequeño fragmento de código que le dice a tu terminal tradicional cómo debe arrancar y qué diseño usar.

- **`ghostty/`** 
  Aquí está el archivo `config`. Es el que le dice a tu terminal principal (Ghostty) qué colores usar, cómo manejar el portapapeles y qué tamaño de letra poner.

- **`kde/`** 
  **NUEVO:** Aquí se encuentra el archivo `MIsShortCuts.kksrc`. Es la copia de seguridad de todos tus atajos de teclado globales de KDE Plasma (por ejemplo, qué teclas apretar para abrir programas, tomar capturas de pantalla, etc). Desde la configuración de KDE puedes importar este archivo para recuperar tus atajos al instante.

- **`scripts/`** 
  Guarda pequeños programas lógicos creados por nosotros. Por ejemplo, aquí vive `open-editor.sh`, que es un "truco" que permite que al presionar tus atajos de teclado de KDE, se abra automáticamente VS Code o Antigravity justo en la carpeta que estás viendo en tu gestor de archivos (Dolphin).

- **`starship/`** 
  Guarda el archivo `starship.toml`. "Starship" es el programa encargado de dibujar los íconos, colores, flechas y la información de Git en tu línea de comandos para que se vea moderna y profesional.

- **`vscode/`** 
  Contiene los ajustes base para Visual Studio Code (y Antigravity IDE) para asegurar que la terminal integrada dentro del editor use las mismas letras bonitas (Nerd Fonts) y funcione igual de rápido.
