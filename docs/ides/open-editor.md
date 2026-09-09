# Open-editor

## Qué hace

Con `Meta + C` abres Visual Studio Code y con `Meta + A` abres Antigravity IDE.
      La parte interesante: si tienes Dolphin (gestor de archivos) enfocado, el editor se abre
      directamente con la carpeta que estás viendo como proyecto. Si no hay Dolphin enfocado, abre
      el editor de forma normal (sin argumentos).


## Archivos que intervienen

- El script (el corazón de todo):
        ~/.local/bin/open-editor
- Los lanzadores .desktop (para que KDE los vea como aplicación y les puedas dar atajo):
        ~/.local/share/applications/net.local.open-code.desktop
        
        ~/.local/share/applications/net.local.open-antigravity.desktop
- Los atajos globales (las líneas que atan los atajos a los lanzadores):
        ~/.config/kglobalshortcutsrc

## Cómo se hace paso a paso

- Crear el script genérico con el contenido de abajo y darle permisos de ejecución:
- Activar la ruta completa en Dolphin (una sola vez):
        
        O desde la GUI: Preferencias → Configurar Dolphin → General → "Mostrar la ruta completa en la barra de título".
- Crear los lanzadores .desktop (mira la sección más abajo).
- Asignar los atajos (la parte que hace que funcionen).
        Desde la GUI: Configuración del sistema → Atajos → Atajos globales, busca
        VsCode y Antigravity IDE y ponles sus atajos.
        O por línea de comandos:
- Reiniciar la sesión o recargar atajos para que los cambios surtan efecto:

## El código del script (open-editor)

Guardado en ~/.local/bin/open-editor:


## Los lanzadores .desktop

Guardado en ~/.local/share/applications/net.local.open-code.desktop:

Guardado en ~/.local/share/applications/net.local.open-antigravity.desktop:


## Por qué funciona así

- KDE guarda todos los atajos globales en ~/.config/kglobalshortcutsrc.
        El formato de cada línea es acción=activo,por_defecto,nombre.
- La línea clave que ata todo es:
- Al presionar el atajo, KDE ejecuta el Exec del .desktop, que invoca
        open-editor &lt;comando&gt;, que a su vez consulta D-Bus para saber si Dolphin está enfocado
        y lee la ruta desde el título de la ventana.
- Es un atajo de "Servicio de aplicación" (services) y no de "Atajos personalizados"
        (khotkeys), por eso se configura con _launch.

## Solución de problemas

| Síntoma | Por qué / qué revisar |
| --- | --- |
| El atajo no hace nada | La tecla Meta puede estar desactivada por firmware (Fn+Meta). O el atajo global
          se perdió: revisa las líneas en kglobalshortcutsrc. |
| Abre el editor pero sin el proyecto | Dolphin no está enfocado, o falta ShowFullPathInTitlebar=true en
          dolphinrc. Verifícalo con kwriteconfig6 --file dolphinrc --group General --key ShowFullPathInTitlebar. |
| El título de Dolphin no es la ruta | Reinicia Dolphin tras cambiar la opción de la barra de título (o cierra y abre todas sus ventanas). |
| qdbus6 no existe | Instala qt6-tools: sudo pacman -S qt6-tools. |

