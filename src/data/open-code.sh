#!/usr/bin/env bash
#
# open-code — abre Visual Studio Code con la carpeta activa de Dolphin
#
# Vincula este script a Super + C en:
#   KDE System Settings → Shortcuts → Custom Shortcuts
#   Trigger: Meta + C
#   Action:  /home/emerson/.local/bin/open-code
#
# Comportamiento:
#   - Dolphin enfocado → code "/ruta/de/la/carpeta"
#   - Otra aplicación   → code (sin argumentos)
#
# Requisito único (una sola vez):
#   Activar "ShowFullPathInTitlebar=true" en Dolphin para que el título
#   de la ventana contenga la ruta completa en lugar de solo el nombre.
#
#   Para activarlo:
#     kwriteconfig6 --file dolphinrc --group General --key ShowFullPathInTitlebar true
#
#   O desde la GUI: Preferencias → Configurar Dolphin → General →
#   "Mostrar la ruta completa en la barra de título"
#
# Dependencias:
#   - qdbus6 (qt6-tools, ya instalado en Plasma 6)
#
#=============================================================================
# Funciones
#=============================================================================

# Descubre dinámicamente los objetos D-Bus de Dolphin bajo un servicio.
discover_dolphin_views() {
    local service="$1"
    qdbus6 "$service" 2>/dev/null \
        | grep -E "^/dolphin/Dolphin_[0-9]+$"
}

# Busca la ventana de Dolphin que tiene el foco entre todas las instancias.
find_active_dolphin() {
    DOLPHIN_SERVICE=""
    DOLPHIN_VIEW=""

    local svc view active
    while IFS= read -r svc; do
        svc="${svc#"${svc%%[! ]*}"}"
        svc="${svc%"${svc##*[! ]}"}"
        [ -z "$svc" ] && continue

        for view in $(discover_dolphin_views "$svc"); do
            active=$(qdbus6 "$svc" "$view" \
                org.kde.dolphin.MainWindow.isActiveWindow 2>/dev/null)
            if [ "$active" = "true" ]; then
                DOLPHIN_SERVICE="$svc"
                DOLPHIN_VIEW="$view"
                return 0
            fi
        done
    done < <(qdbus6 | grep "org.kde.dolphin-")

    return 1
}

# Lee la ruta completa desde el título de la ventana de Dolphin.
get_dolphin_path() {
    local service="$1"
    local view="$2"

    local title
    title=$(qdbus6 "$service" "$view" \
        org.qtproject.Qt.QWidget.windowTitle 2>/dev/null)

    if [[ "$title" == /* ]] && [ -d "$title" ]; then
        printf "%s" "$title"
        return 0
    fi

    return 1
}

# Abre VS Code. Si recibe una ruta válida, la abre como proyecto.
open_vscode() {
    if [ -n "$1" ]; then
        exec code "$1"
    else
        exec code
    fi
}

#=============================================================================
# Ejecución principal
#=============================================================================

main() {
    local folder=""

    # 1. Detectar si Dolphin está enfocado y cuál es la ventana activa
    find_active_dolphin

    if [ -n "$DOLPHIN_SERVICE" ] && [ -n "$DOLPHIN_VIEW" ]; then
        # 2. Leer la ruta directamente del título de la ventana
        folder=$(get_dolphin_path "$DOLPHIN_SERVICE" "$DOLPHIN_VIEW")
    fi

    # 3. Abrir VS Code con la ruta obtenida, o sin argumentos si no hay ruta
    open_vscode "$folder"
}

# Solo ejecutar cuando el script se invoca directamente (no al hacer source)
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    main "$@"
fi