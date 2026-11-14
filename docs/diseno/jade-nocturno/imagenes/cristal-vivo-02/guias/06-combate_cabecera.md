# Guía 06 — Combate cabecera

Propuesta 02 / Cristal vivo. **Estado: propuesta, sin aprobación gráfica individual.**

**Familia del manual:** `JN-PANT-06`.

## Piezas independientes

- `02-iconos-mapa-combate/svg/jn-pant-06-retrato.svg` / `02-iconos-mapa-combate/png/jn-pant-06-retrato.png` — retrato, 512×512 px.
- `02-iconos-mapa-combate/svg/jn-pant-06-vida.svg` / `02-iconos-mapa-combate/png/jn-pant-06-vida.png` — vida, 800×94 px.
- `02-iconos-mapa-combate/svg/jn-pant-06-nivel.svg` / `02-iconos-mapa-combate/png/jn-pant-06-nivel.png` — nivel, 800×94 px.
- `02-iconos-mapa-combate/svg/jn-pant-06-turno.svg` / `02-iconos-mapa-combate/png/jn-pant-06-turno.png` — turno, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-06-oponente.svg` / `02-iconos-mapa-combate/png/jn-pant-06-oponente.png` — oponente, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-06-equipo.svg` / `02-iconos-mapa-combate/png/jn-pant-06-equipo.png` — equipo, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-06-reserva.svg` / `02-iconos-mapa-combate/png/jn-pant-06-reserva.png` — reserva, 960×540 px.

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
