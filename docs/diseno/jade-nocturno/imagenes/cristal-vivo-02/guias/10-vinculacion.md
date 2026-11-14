# Guía 10 — Vinculacion

Propuesta 02 / Cristal vivo. **Estado: propuesta, sin aprobación gráfica individual.**

**Familia del manual:** `JN-PANT-10`.

## Piezas independientes

- `04-pantallas-y-situaciones/svg/jn-pant-10-libro.svg` / `04-pantallas-y-situaciones/png/jn-pant-10-libro.png` — libro, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-10-intento.svg` / `04-pantallas-y-situaciones/png/jn-pant-10-intento.png` — intento, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-10-accion.svg` / `04-pantallas-y-situaciones/png/jn-pant-10-accion.png` — accion, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-10-exito.svg` / `04-pantallas-y-situaciones/png/jn-pant-10-exito.png` — exito, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-10-fallo.svg` / `04-pantallas-y-situaciones/png/jn-pant-10-fallo.png` — fallo, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-10-escape.svg` / `04-pantallas-y-situaciones/png/jn-pant-10-escape.png` — escape, 960×540 px.

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
