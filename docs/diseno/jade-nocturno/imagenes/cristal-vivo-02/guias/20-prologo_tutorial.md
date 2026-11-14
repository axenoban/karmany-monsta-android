# Guía 20 — Prologo tutorial

Propuesta 02 / Cristal vivo. **Estado: propuesta, sin aprobación gráfica individual.**

**Familia del manual:** `JN-PANT-20`.

## Piezas independientes

- `04-pantallas-y-situaciones/svg/jn-pant-20-dialogo.svg` / `04-pantallas-y-situaciones/png/jn-pant-20-dialogo.png` — dialogo, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-20-retrato.svg` / `04-pantallas-y-situaciones/png/jn-pant-20-retrato.png` — retrato, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-20-avanzar.svg` / `04-pantallas-y-situaciones/png/jn-pant-20-avanzar.png` — avanzar, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-20-omitir.svg` / `04-pantallas-y-situaciones/png/jn-pant-20-omitir.png` — omitir, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-20-ayuda.svg` / `04-pantallas-y-situaciones/png/jn-pant-20-ayuda.png` — ayuda, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-20-paso.svg` / `04-pantallas-y-situaciones/png/jn-pant-20-paso.png` — paso, 960×540 px.

## Ensamblaje y límites

- La composición de demostración no incorpora cifras, reglas ni contenido nuevos.
- Colocar ilustraciones canónicas y texto vivo en nodos Godot; los SVG/PNG son superficies visuales.
- Respetar Safe Area, jerarquía, 48dp efectivos de área táctil y texto ampliado.
- No estirar esquinas ornamentales: usar paneles NinePatch con márgenes medidos por recurso.
- Registrar aprobación individual antes de trasladar al juego.

## Prueba

- Revisar a 1280×720 y 960×540 con texto normal y grande.
- Confirmar selección, foco, bloqueo y contraste sin depender exclusivamente del color.
- Asegurar que los modales no cubren permanentemente los controles necesarios.
