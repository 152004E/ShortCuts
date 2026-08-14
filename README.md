# MyShortcuts

Guía personal de atajos de teclado y configuración de escritorio para Linux.

## Stack

- [Astro](https://astro.build) 7.x (estático, ideal para GitHub Pages)
- [Tailwind CSS](https://tailwindcss.com) 4.x (`@tailwindcss/vite`)
- Node.js 24 (LTS)

## Desarrollo

```bash
pnpm install   # primera vez
pnpm dev       # servidor local con hot-reload
pnpm build     # genera el sitio estático en dist/
pnpm preview   # sirve dist/ localmente
```

## Páginas

| Ruta | Contenido |
|---|---|
| `/` | Atajos de teclado KDE Plasma 6 (buscador) |
| `/open-code/` | Script `Meta+C` — abrir VS Code con la carpeta de Dolphin |
| `/guia-gnome/` | Escritorios virtuales en Ubuntu/GNOME |
| `/barras-pantallas/` | Plan: barras en 2 pantallas con una tecla (KDE) |

## Deploy a GitHub Pages

El workflow `.github/workflows/deploy.yml` compila y publica en GitHub Pages en cada push a `main`. La configuración `site`/`base` en `astro.config.mjs` apunta al repositorio GitHub Pages correspondiente — ajústalos si cambias de repo.

## Extras

- El buscador de la portada es JS vanilla en `src/pages/index.astro`.
- El tema oscuro vive en `src/styles/global.css` mediante tokens de Tailwind 4 (`@theme`).