# Guía 09 — Resultados

Propuesta 02 / Cristal vivo. **Estado: propuesta, sin aprobación gráfica individual.**

**Familia del manual:** `JN-PANT-09`.

## Piezas independientes

- `04-pantallas-y-situaciones/svg/jn-pant-09-victoria.svg` / `04-pantallas-y-situaciones/png/jn-pant-09-victoria.png` — victoria, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-09-derrota.svg` / `04-pantallas-y-situaciones/png/jn-pant-09-derrota.png` — derrota, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-09-recompensa.svg` / `04-pantallas-y-situaciones/png/jn-pant-09-recompensa.png` — recompensa, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-09-experiencia.svg` / `04-pantallas-y-situaciones/png/jn-pant-09-experiencia.png` — experiencia, 800×94 px.
- `04-pantallas-y-situaciones/svg/jn-pant-09-nivel.svg` / `04-pantallas-y-situaciones/png/jn-pant-09-nivel.png` — nivel, 800×94 px.
- `04-pantallas-y-situaciones/svg/jn-pant-09-continuacion.svg` / `04-pantallas-y-situaciones/png/jn-pant-09-continuacion.png` — continuacion, 960×540 px.

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
