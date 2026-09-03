# --- Starship Prompt Integration ---
# Añadir al final de ~/.bashrc
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
fi
