# Configuración de escritorios virtuales en Ubuntu/GNOME

## 🖥️ Escritorios virtuales

### Cambiar de escritorio

- `Ctrl + Alt + ←` → Escritorio anterior
- `Ctrl + Alt + →` → Escritorio siguiente

### Mover la ventana actual a otro escritorio

- `Ctrl + Alt + Shift + ←` → Mueve la ventana al escritorio anterior.
- `Ctrl + Alt + Shift + →` → Mueve la ventana al escritorio siguiente.

---

## 🧩 Dock separado por escritorio

El problema inicial era que las aplicaciones abiertas en otros escritorios seguían apareciendo en el Dock.

### 1. Aislar las aplicaciones del Dock por escritorio

```bash
gsettings set org.gnome.shell.extensions.dash-to-dock isolate-workspaces true
```

### 2. Hacer que el selector de aplicaciones también use solo el escritorio actual

```bash
gsettings set org.gnome.shell.app-switcher current-workspace-only true
```

### Configuración final

Puedes aplicar ambas con:

```bash
gsettings set org.gnome.shell.extensions.dash-to-dock isolate-workspaces true
gsettings set org.gnome.shell.app-switcher current-workspace-only true
```

### Comprobar la configuración

```bash
gsettings get org.gnome.shell.extensions.dash-to-dock isolate-workspaces
gsettings get org.gnome.shell.app-switcher current-workspace-only
```

Debe mostrar:

```text
true
true
```

---

## 🎯 Resultado

Ejemplo:

### Escritorio 1
- VS Code
- Brave
- Terminal

### Escritorio 2
- DBeaver
- Discord

Al cambiar al escritorio 2, las aplicaciones que están abiertas únicamente en el escritorio 1 ya no aparecen como abiertas en el Dock del escritorio 2.

Al volver al escritorio 1, vuelven a aparecer.

---

## 📋 Resumen rápido

| Acción | Atajo / configuración |
|---|---|
| Escritorio anterior | `Ctrl + Alt + ←` |
| Escritorio siguiente | `Ctrl + Alt + →` |
| Mover ventana atrás | `Ctrl + Alt + Shift + ←` |
| Mover ventana adelante | `Ctrl + Alt + Shift + →` |
| Dock aislado por escritorio | `isolate-workspaces = true` |
| Selector de apps aislado | `current-workspace-only = true` |

## 📝 Nota

También se planteó configurar el comportamiento del clic sobre una aplicación que ya está abierta en otro escritorio, para que pueda abrirse como una nueva ventana en el escritorio actual en lugar de llevarte a la ventana existente. Esa parte quedó pendiente de configurar.
