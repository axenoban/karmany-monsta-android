# Guía 07 — Combate acciones

Propuesta 02 / Cristal vivo. **Estado: propuesta, sin aprobación gráfica individual.**

**Familia del manual:** `JN-PANT-07`.

## Piezas independientes

- `02-iconos-mapa-combate/svg/jn-pant-07-golpe.svg` / `02-iconos-mapa-combate/png/jn-pant-07-golpe.png` — golpe, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-07-proteccion.svg` / `02-iconos-mapa-combate/png/jn-pant-07-proteccion.png` — proteccion, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-07-insignia.svg` / `02-iconos-mapa-combate/png/jn-pant-07-insignia.png` — insignia, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-07-entrenador.svg` / `02-iconos-mapa-combate/png/jn-pant-07-entrenador.png` — entrenador, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-07-equipo.svg` / `02-iconos-mapa-combate/png/jn-pant-07-equipo.png` — equipo, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-07-detalles.svg` / `02-iconos-mapa-combate/png/jn-pant-07-detalles.png` — detalles, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-07-marco.svg` / `02-iconos-mapa-combate/png/jn-pant-07-marco.png` — marco, 960×540 px.

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
