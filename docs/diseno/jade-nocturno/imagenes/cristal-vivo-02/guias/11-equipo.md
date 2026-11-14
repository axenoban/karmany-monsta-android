# Guía 11 — Equipo

Propuesta 02 / Cristal vivo. **Estado: propuesta, sin aprobación gráfica individual.**

**Familia del manual:** `JN-PANT-11`.

## Piezas independientes

- `03-equipo-y-progresion/svg/jn-pant-11-protagonista.svg` / `03-equipo-y-progresion/png/jn-pant-11-protagonista.png` — protagonista, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-11-nombre.svg` / `03-equipo-y-progresion/png/jn-pant-11-nombre.png` — nombre, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-11-activo.svg` / `03-equipo-y-progresion/png/jn-pant-11-activo.png` — activo, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-11-reserva.svg` / `03-equipo-y-progresion/png/jn-pant-11-reserva.png` — reserva, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-11-estadisticas.svg` / `03-equipo-y-progresion/png/jn-pant-11-estadisticas.png` — estadisticas, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-11-acciones.svg` / `03-equipo-y-progresion/png/jn-pant-11-acciones.png` — acciones, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-11-tarjeta.svg` / `03-equipo-y-progresion/png/jn-pant-11-tarjeta.png` — tarjeta, 960×540 px.

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
