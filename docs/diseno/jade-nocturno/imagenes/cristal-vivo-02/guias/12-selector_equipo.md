# Guía 12 — Selector equipo

Propuesta 02 / Cristal vivo. **Estado: propuesta, sin aprobación gráfica individual.**

**Familia del manual:** `JN-PANT-12`.

## Piezas independientes

- `03-equipo-y-progresion/svg/jn-pant-12-retrato.svg` / `03-equipo-y-progresion/png/jn-pant-12-retrato.png` — retrato, 512×512 px.
- `03-equipo-y-progresion/svg/jn-pant-12-seleccionado.svg` / `03-equipo-y-progresion/png/jn-pant-12-seleccionado.png` — seleccionado, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-12-hueco.svg` / `03-equipo-y-progresion/png/jn-pant-12-hueco.png` — hueco, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-12-coleccion.svg` / `03-equipo-y-progresion/png/jn-pant-12-coleccion.png` — coleccion, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-12-lista.svg` / `03-equipo-y-progresion/png/jn-pant-12-lista.png` — lista, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-12-activo.svg` / `03-equipo-y-progresion/png/jn-pant-12-activo.png` — activo, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-12-reserva.svg` / `03-equipo-y-progresion/png/jn-pant-12-reserva.png` — reserva, 960×540 px.

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
