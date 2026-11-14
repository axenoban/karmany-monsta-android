# Guía 15 — Libro

Propuesta 02 / Cristal vivo. **Estado: propuesta, sin aprobación gráfica individual.**

**Familia del manual:** `JN-PANT-15`.

## Piezas independientes

- `03-equipo-y-progresion/svg/jn-pant-15-ilustracion.svg` / `03-equipo-y-progresion/png/jn-pant-15-ilustracion.png` — ilustracion, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-15-nivel.svg` / `03-equipo-y-progresion/png/jn-pant-15-nivel.png` — nivel, 800×94 px.
- `03-equipo-y-progresion/svg/jn-pant-15-probabilidad.svg` / `03-equipo-y-progresion/png/jn-pant-15-probabilidad.png` — probabilidad, 800×94 px.
- `03-equipo-y-progresion/svg/jn-pant-15-mejora.svg` / `03-equipo-y-progresion/png/jn-pant-15-mejora.png` — mejora, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-15-requisitos.svg` / `03-equipo-y-progresion/png/jn-pant-15-requisitos.png` — requisitos, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-15-confirmacion.svg` / `03-equipo-y-progresion/png/jn-pant-15-confirmacion.png` — confirmacion, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-15-marco.svg` / `03-equipo-y-progresion/png/jn-pant-15-marco.png` — marco, 960×540 px.

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
