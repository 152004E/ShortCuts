# Terminal

## Vista Previa de la Terminal (Ghostty + Starship)

Así se visualiza el prompt en tiempo real dentro de un proyecto con Node.js, TypeScript y Git activo:


## Qué información muestra automáticamente

Detecta automáticamente si estás en un proyecto con package.json o archivos JS/TS y muestra la versión de Node activa (ej. v22.23.1).

Indica en qué rama estás (main), si tienes cambios sin guardar (!), archivos nuevos (?) o commits adelante/atrás (⇡1).

Lee el archivo de configuración del proyecto y muestra la versión del paquete actual de forma discreta.

Si un script, compilación o test toma más de 2 segundos, el prompt te indica exactamente cuánto tiempo tardó (ej. took 3.4s).


## Cómo replicar toda la configuración en una nueva máquina

Este repositorio incluye un script automatizado que instala la fuente, Starship y copia las configuraciones sin requerir permisos de administrador:


## Configuración de Ghostty (~/.config/ghostty/config)

Ubicación en tu sistema: ~/.config/ghostty/config. Incluye ligaduras de código, opacidad suave y fuente Nerd Font:


## Configuración de Starship (~/.config/starship.toml)

Ubicación en tu sistema: ~/.config/starship.toml. Define el tema Catppuccin Mocha y los módulos activos:


## Configuración en VS Code / Antigravity IDE

Ubicación en tu sistema: ~/.config/Code/User/settings.json. Asocia la fuente Nerd Font, define Ghostty como terminal externa, y activa el copiado automático al seleccionar texto en la terminal integrada:


