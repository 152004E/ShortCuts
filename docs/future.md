# MyShortcuts — Documento de futuro: animaciones de scroll

> Estado: propuesta técnica. Fecha: agosto 2026.
> Objetivo: definir las mejores opciones de animaciones de scroll para este proyecto Astro, cómo implementarlas y por dónde empezar.

---

## 1. Estado actual del proyecto

El proyecto es un sitio estático (SSG) hecho con **Astro 7.2.2 + Tailwind CSS 4.3.3**, sin ningún framework de UI (React/Vue/Svelte) y con **3 dependencias nada más**.

```json
// package.json (dependencias)
"astro": "^7.2.2",
"tailwindcss": "^4.3.3",
"@tailwindcss/vite": "^4.3.3"
```

### Lo que existe hoy en cuanto a animación

**Ninguna animación de scroll.** El proyecto está en estado "limpio":

- **Único `<script>` de cliente:** el buscador de `src/pages/index.astro:227–244` (JS vanilla, alterna la clase `hidden`).
- **Solo 3 puntos de "interacción animada"**, todos CSS declarativo de Tailwind (`transition-colors`):
  | Elemento | Archivo | Línea |
  |---|---|---|
  | Pills de navegación (hover/focus) | `src/components/Nav.astro` | 23 |
  | Input de búsqueda (focus ring) | `src/layouts/Base.astro` | 44 |
  | Subrayado de enlaces (hover) | `src/styles/global.css` | 96 |
- **No existe:** `@keyframes`, `IntersectionObserver`, `requestAnimationFrame`, View Transitions de Astro, `scroll-behavior`, ni librerías como GSAP / Lenis / Framer Motion / astro-reveal.

### Puntos de integración natural del DOM

Si se añaden animaciones de scroll, estos selectores son los objetivos:

- `<section>` — elemento que genera `Section.astro:22` → ideal para reveal por sección.
- `.prose-md` — envoltorio del slot en `Base.astro:49` → para páginas Markdown.
- `table` dentro de cada `Section` → tablas de atajos.
- `<header>` / `h1` en `Base.astro:27–32` → entrada al cargar.
- Tokens de tema en `src/styles/global.css:3–21` (`@theme`) → placeholders para definir easings/durations custom.

---

## 2. Las mejores opciones de animación de scroll en 2026

El panorama en 2026 cambió drásticamente: **las animaciones de scroll nativas de CSS (`animation-timeline`, `scroll()`, `view()`) y la View Transitions API ya son multiplataforma** y han reemplazado a la mayoría de librerías. GSAP y Framer Motion ya no son el default: son la excepción para casos complejos.

### Resumen comparativo

| Opción | JS en producción | Rendimiento | Complejidad | Ideal para |
|---|---|---|---|---|
| **CSS Scroll-Driven (nativo)** | 0 KB | Máximo (compositor, fuera del main thread) | Baja | fade/slide/parallax/progress bar al hacer scroll |
| **Astro View Transitions (`<ClientRouter />`)** | ~0 KB extra | Alto | Baja | transiciones entre páginas (fade, slide) |
| **IntersectionObserver + CSS (astronomía/reveal)** | ~0.6 KB | Alto | Baja | "reveal una vez y queda" universal |
| **astro-reveal (librería)** | 0 KB o 0.6 KB | Alto | Muy baja | reveal sin escribir JS, gota `data-reveal` |
| **GSAP ScrollTrigger + Lenis** | ~70–100 KB | Medio | Alta | scrub complejo, pinning, timelines sincronizados |
| **Motion / Motion One** | 30–50 KB | Medio | Media | UI state transitions (React islands) |

Regla general (Mintec, datos reales): **~70% de las animaciones decorativas que antes se hacían con librerías ahora se hacen con CSS scroll-driven + View Transitions.** Solo se llega a GSAP cuando hace falta control programático (play/pause/reverse, secuencias indexadas) o física de muelles.

---

## 3. Cómo se usa cada una (con código)

### 3.1 CSS Scroll-Driven Animations (recomendada como base)

Animación **scrubbable** ligada a la posición de scroll. Cero JavaScript; el navegador la ejecuta en el compositor.

**Reveal al entrar en viewport (`view()` + `animation-range`):**

```css
/* En @supports para no romper navegadores antiguos */
@supports (animation-timeline: scroll()) {
  .reveal {
    opacity: 0;
    transform: translateY(2rem);
    animation: reveal linear both;
    animation-timeline: view();
    animation-range: entry 0% entry 60%; /* empieza al entrar, termina al 60% */
  }
}

@keyframes reveal {
  to { opacity: 1; transform: translateY(0); }
}
```

**Barra de progreso de scroll (`scroll()`):**

```css
@supports (animation-timeline: scroll()) {
  .progress-bar {
    transform-origin: left;
    animation: grow linear both;
    animation-timeline: scroll(); /* timeline del scroller root */
  }
}
@keyframes grow { from { scale: 0 1; } to { scale: 1 1; } }
```

**Parallax sutil:** usar `view()` + `transform` con `animation-range` acotado.

**Aspectos críticos:**

- El estado visible (reposo) debe ser el default; el estado oculto solo dentro de `@supports` → **evita FOUC / contenido invisible** en navegadores que no soporten la API.
- `animation-timeline` debe declararse **después** del shorthand `animation` (es reset-only).
- Añadir `animation-duration: 1ms` porque Firefox lo exige.
- En `prefers-reduced-motion: reduce` hay que resetear explícitamente: `animation-timeline: auto !important` (si no, el elemento queda invisible).
- Soporte: Chrome 115+, Safari 17.4+, Edge 115+. **Firefox aún lo tiene tras flag** → el guard `@supports` es obligatorio.

**En Astro:** se aplica como CSS normal desde `src/styles/global.css`. Compatible con `<style>` de componentes o `is:global`.

---

### 3.2 Astro View Transitions (`<ClientRouter />`)

Transiciones **entre páginas** (no scroll). Astro 7 lo soporta de serie, cero dependencias.

**Activación** (en `Base.astro`):

```astro
---
import { ClientRouter } from "astro:transitions";
---
<html>
  <head>
    <ClientRouter />
  </head>
</html>
```

**Animar con directivas:**

```astro
<div transition:animate="fade">...</div>   <!-- default: crossfade -->
<div transition:animate="slide">...</div>  <!-- slide; en retroceso se invierte -->
<div transition:animate="none">...</div>
<div transition:name="logo">...</div>      <!-- morph entre elementos con el mismo name -->
```

- Respeta `prefers-reduced-motion` automáticamente.
- Ideal para que la navegación de este proyecto (4 páginas) se sienta fluida.
- Los scroll-reveals requieren re-inicializarse en `astro:page-load` (ver 3.3/3.4).

---

### 3.3 IntersectionObserver + CSS (patrón "reveal una vez y queda")

El clásico y universal: un único observer añade una clase al entrar en viewport.

```js
let revealObserver = null;

function initReveal() {
  if (revealObserver) revealObserver.disconnect();
  const els = document.querySelectorAll(".reveal");
  if (!els.length) return;

  revealObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-visible");
          revealObserver.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.1, rootMargin: "0px 0px -20px 0px" }
  );
  els.forEach((el) => revealObserver.observe(el));
}

// Se debe reinicializar tras cada navegación con View Transitions:
document.addEventListener("astro:page-load", initReveal);
document.addEventListener("astro:before-swap", () => {
  if (revealObserver) revealObserver.disconnect();
});
```

```css
.reveal { opacity: 0; transform: translateY(2rem); transition: opacity .5s, transform .5s; }
.reveal.is-visible { opacity: 1; transform: none; }

@media (prefers-reduced-motion: reduce) {
  .reveal { opacity: 1 !important; transform: none !important; transition: none; }
}
```

**En Astro:** este bloque va en un `<script>` de `Base.astro` (se procesa inline) o como componente `<Reveal />`. En páginas `.md` los elementos viven dentro de `.prose-md`.

---

### 3.4 astro-reveal (librería especializada)

Sin framework de UI. **0 JS en producción** por defecto (usa scroll-driven nativo) o modo `observer` (~0.6 KB gzipped) para soporte universal ("reveal y queda").

```html
<div
  data-reveal="bottom"      <!-- dirección: top/bottom/left/right/scale/diagonales -->
  data-speed="fast"         <!-- preset de velocidad -->
  data-easing="smooth"      <!-- smooth | bounce | elastic | sharp | soft -->
  data-distance="large"     <!-- preset de distancia -->
  data-delay="200"          <!-- ms -->
  data-stagger              <!-- + data-stagger-delay para cascada -->
  data-threshold="0.5"
>
  Contenido
</div>
```

```ts
// modes: "scroll" (nativo, default) | "observer" (JS) | "auto" (nativo + fallback JS)
import { reveal } from "astro-reveal";
reveal({ mode: "auto", once: true, threshold: 0.15 });
```

Muy recomendable acoplarlo a `astro:page-load` si se usan View Transitions. Variantes del mismo ecosistema: `@arraypress/reveal-astro` (selector por clases + un `<Reveal />` en el layout).

---

### 3.5 GSAP ScrollTrigger + Lenis (cuando hace falta potencia)

El stack "premium" para scroll-stop / hero scrolled: **GSAP ScrollTrigger** (mapeo scroll→progreso, pinning, scrub) + **Lenis** (smooth scroll con inercia que no rompe el scroll nativo).

```bash
pnpm add gsap lenis
```

```js
import gsap from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
import Lenis from "lenis";

gsap.registerPlugin(ScrollTrigger);
const lenis = new Lenis();
lenis.on("scroll", ScrollTrigger.update);
gsap.ticker.add((t) => lenis.raf(t * 1000));
gsap.ticker.lagSmoothing(0);

gsap.to(".hero-inner", {
  scale: 0.9, opacity: 0.3, ease: "none",
  scrollTrigger: { trigger: ".hero", start: "top top", end: "bottom top", scrub: true },
});
```

- **Coste real:** GSAP ~70 KB, Lenis ~10 KB. Con tree-shaking e islas de Astro solo en el hero se reducen a no impactar el resto de páginas.
- Ideal para: scrub de hero, pinning, línea de tiempo con varios elementos encadenados, secuencias indexadas (`stagger`).

---

## 4. Recomendación para MyShortcuts

Este proyecto es una guía de atajos, no un showcase. El contenido es tablas + texto, por lo que conviene **animación sutil y rendimiento por defecto** (cero JS de más, respetar `prefers-reduced-motion`).

### Plan sugerido

| Fase | Qué | Técnica | Esfuerzo |
|---|---|---|---|
| 1 | Reveal suave de `<section>` al hacer scroll | CSS scroll-driven `view()` envuelto en `@supports` | Bajo |
| 2 | Transiciones suaves entre las 4 páginas | `<ClientRouter />` + `transition:animate="fade"` en el contenido | Bajo |
| 3 | Reveal de filas de tablas en cascada (`stagger`) | IntersectionObserver + `transition-delay`, o astro-reveal en modo `observer`/`auto` | Medio |
| 4 | Barra de progreso de lectura fija arriba (`index`/`open-code`) | CSS `scroll()` + `scroll()` | Bajo |
| 5 | (Opcional) Parallax sutil del header gradiente | CSS `view()` | Medio |

### Reglas obligatorias (para cualquier técnica)

1. **Baseline visible siempre** — el contenido debe verse sin animación en navegadores sin soporte.
2. **`@supports (animation-timeline: scroll())`** para todo lo scroll-driven.
3. **`prefers-reduced-motion: reduce`** desactiva todo (en CSS scroll-driven hay que resetear `animation-timeline: auto !important`).
4. Animar solo `opacity` y `transform` (compositor, sin layout jank).
5. Si se usa View Transitions + scroll reveal: reinicializar el reveal en `astro:page-load` y desconectar en `astro:before-swap`.
6. Astro 7 enruta con `ClientRouter`; `transition:animate="none"` sobre contenedores animados manualmente evita conflictos.

### Qué NO hace falta instalar

Para este proyecto, **GSAP/Lenis/Motion son exceso**. La vía nativa (CSS scroll-driven + View Transitions) cubre el 95% de lo que aportaría valor aquí, con 0 KB de JS nuevo.

---

## 5. Fuentes y referencias

- Astro View Transitions: https://docs.astro.build/en/guides/view-transitions/
- MDN — Scroll-driven animations / Timelines: https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_scroll-driven_animations
- MDN — `animation-timeline`: https://developer.mozilla.org/en-US/docs/Web/CSS/animation-timeline
- Chrome for Developers — Scroll-driven animations: https://developer.chrome.com/docs/css-ui/scroll-driven-animations
- CSS Scroll-Driven — Browser support & progressive enhancement: https://www.css-scroll-driven.com/core-animation-fundamentals-browser-mechanics/browser-support-progressive-enhancement/
- Can I use — `animation-timeline`: https://caniuse.com/mdn-css_properties_animation-timeline_scroll
- astro-reveal: https://github.com/polgubau/astro-reveal · https://npm.io/package/astro-reveal
- arraypress/reveal-astro: https://github.com/arraypress/reveal-astro
- "Smooth scroll reveal in Astro 6" (NDLSK): https://ndlsk.com/blog/smooth-scroll-reveal-astro/
- "Scroll-Driven Animations and View Transitions" (Mintec): https://mintec.co/blog/scroll-driven-view-transitions-css-2026/
- "Scroll-Stop Animations: The 2026 Playbook" (C&E): https://causeandeffectsp.com/blog/scroll-stop-animations-2026-playbook/