#!/usr/bin/env bash
#
# open-editor — abre el editor especificado con la carpeta activa de Dolphin
#
# Ejemplos de uso en archivos .desktop:
#   Exec=/home/SenaFactory/.local/bin/open-editor code
#   Exec=/home/SenaFactory/.local/bin/open-editor antigravity
#
# Comportamiento:
#   - Dolphin enfocado → editor "/ruta/de/la/carpeta"
#   - Otra aplicación   → editor (sin argumentos)
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
#   - qdbus6 / qdbus-qt6 (qt6-tools)
#
#=============================================================================
# Funciones
#=============================================================================

QDBUS=$(command -v qdbus6 2>/dev/null || command -v qdbus-qt6 2>/dev/null || command -v qdbus 2>/dev/null)

# Descubre dinámicamente los objetos D-Bus de Dolphin bajo un servicio.
discover_dolphin_views() {
    local service="$1"
    [ -z "$QDBUS" ] && return 1
    "$QDBUS" "$service" 2>/dev/null \
        | grep -E "^/dolphin/Dolphin_[0-9]+$"
}

# Busca la ventana de Dolphin que tiene el foco entre todas las instancias.
find_active_dolphin() {
    DOLPHIN_SERVICE=""
    DOLPHIN_VIEW=""
    [ -z "$QDBUS" ] && return 1

    local svc view active
    while IFS= read -r svc; do
        svc="${svc#"${svc%%[! ]*}"}"
        svc="${svc%"${svc##*[! ]}"}"
        [ -z "$svc" ] && continue

        for view in $(discover_dolphin_views "$svc"); do
            active=$("$QDBUS" "$svc" "$view" \
                org.kde.dolphin.MainWindow.isActiveWindow 2>/dev/null)
            if [ "$active" = "true" ]; then
                DOLPHIN_SERVICE="$svc"
                DOLPHIN_VIEW="$view"
                return 0
            fi
        done
    done < <("$QDBUS" | grep "org.kde.dolphin-")

    return 1
}

# Lee la ruta completa desde el título de la ventana de Dolphin.
get_dolphin_path() {
    local service="$1"
    local view="$2"
    [ -z "$QDBUS" ] && return 1

    local title
    title=$("$QDBUS" "$service" "$view" \
        org.qtproject.Qt.QWidget.windowTitle 2>/dev/null)

    if [[ "$title" == /* ]] && [ -d "$title" ]; then
        printf "%s" "$title"
        return 0
    fi

    return 1
}

#=============================================================================
# Ejecución principal
#=============================================================================

main() {
    local editor="$1"
    
    if [ -z "$editor" ]; then
        echo "Uso: $0 <comando-del-editor>"
        exit 1
    fi
    
    local folder=""

    # 1. Detectar si Dolphin está enfocado y cuál es la ventana activa
    find_active_dolphin

    if [ -n "$DOLPHIN_SERVICE" ] && [ -n "$DOLPHIN_VIEW" ]; then
        # 2. Leer la ruta directamente del título de la ventana
        folder=$(get_dolphin_path "$DOLPHIN_SERVICE" "$DOLPHIN_VIEW")
    fi

    # 3. Abrir el editor con la ruta obtenida, o sin argumentos si no hay ruta
    if [ -n "$folder" ]; then
        exec "$editor" "$folder"
    else
        exec "$editor"
    fi
}

# Solo ejecutar cuando el script se invoca directamente (no al hacer source)
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    main "$@"
fi
