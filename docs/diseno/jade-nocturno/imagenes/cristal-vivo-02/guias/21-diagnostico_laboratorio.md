# Guía 21 — Diagnostico laboratorio

Propuesta 02 / Cristal vivo. **Estado: propuesta, sin aprobación gráfica individual.**

**Familia del manual:** `JN-PANT-21`.

## Piezas independientes

- `04-pantallas-y-situaciones/svg/jn-pant-21-panel.svg` / `04-pantallas-y-situaciones/png/jn-pant-21-panel.png` — panel, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-21-formulario.svg` / `04-pantallas-y-situaciones/png/jn-pant-21-formulario.png` — formulario, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-21-modo_qa.svg` / `04-pantallas-y-situaciones/png/jn-pant-21-modo_qa.png` — modo_qa, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-21-mensaje.svg` / `04-pantallas-y-situaciones/png/jn-pant-21-mensaje.png` — mensaje, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-21-confirmacion.svg` / `04-pantallas-y-situaciones/png/jn-pant-21-confirmacion.png` — confirmacion, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-21-seleccion.svg` / `04-pantallas-y-situaciones/png/jn-pant-21-seleccion.png` — seleccion, 960×540 px.

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
