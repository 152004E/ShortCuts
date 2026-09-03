#!/usr/bin/env bash
# ==============================================================================
# Script de Instalación Rápida: Ghostty + Starship + JetBrainsMono Nerd Font
# 100% en espacio de usuario (sin necesidad de sudo)
# ==============================================================================

set -e

echo "🚀 [1/5] Creando directorios en espacio de usuario..."
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/fonts/JetBrainsMono"
mkdir -p "$HOME/.config/ghostty"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔤 [2/5] Verificando e instalando JetBrainsMono Nerd Font..."
if ! fc-list : family | grep -iq "JetBrainsMono Nerd Font"; then
    echo "⬇️  Descargando JetBrainsMono Nerd Font..."
    curl -fLo /tmp/JetBrainsMono.tar.xz https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
    tar -xJf /tmp/JetBrainsMono.tar.xz -C "$HOME/.local/share/fonts/JetBrainsMono/"
    rm -f /tmp/JetBrainsMono.tar.xz
    fc-cache -f "$HOME/.local/share/fonts"
    echo "✅ Fuente instalada con éxito."
else
    echo "✅ JetBrainsMono Nerd Font ya está instalada."
fi

echo "⭐ [3/5] Verificando e instalando Starship Prompt..."
if ! command -v starship &> /dev/null; then
    echo "⬇️  Descargando binario oficial de Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir "$HOME/.local/bin" -y
    echo "✅ Starship instalado en $HOME/.local/bin/starship."
else
    echo "✅ Starship ya está instalado."
fi

echo "⚙️  [4/5] Copiando archivos de configuración (dotfiles)..."
cp -v "$SCRIPT_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
cp -v "$SCRIPT_DIR/ghostty/config" "$HOME/.config/ghostty/config"

echo "🐚 [5/5] Configurando ~/.bashrc..."
if ! grep -q 'starship init bash' "$HOME/.bashrc"; then
    echo '' >> "$HOME/.bashrc"
    echo '# Starship Prompt' >> "$HOME/.bashrc"
    echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
    echo "✅ Starship agregado a ~/.bashrc."
else
    echo "✅ Starship ya estaba configurado en ~/.bashrc."
fi

echo ""
echo "🎉 ¡Instalación y configuración completadas!"
echo "👉 Abre una nueva terminal o ejecuta: source ~/.bashrc"
