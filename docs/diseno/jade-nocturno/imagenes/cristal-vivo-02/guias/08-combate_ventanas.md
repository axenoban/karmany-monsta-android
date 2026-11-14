# Guía 08 — Combate ventanas

Propuesta 02 / Cristal vivo. **Estado: propuesta, sin aprobación gráfica individual.**

**Familia del manual:** `JN-PANT-08`.

## Piezas independientes

- `02-iconos-mapa-combate/svg/jn-pant-08-detalle.svg` / `02-iconos-mapa-combate/png/jn-pant-08-detalle.png` — detalle, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-08-tecnicas.svg` / `02-iconos-mapa-combate/png/jn-pant-08-tecnicas.png` — tecnicas, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-08-entrenador.svg` / `02-iconos-mapa-combate/png/jn-pant-08-entrenador.png` — entrenador, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-08-resonancia.svg` / `02-iconos-mapa-combate/png/jn-pant-08-resonancia.png` — resonancia, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-08-miembro.svg` / `02-iconos-mapa-combate/png/jn-pant-08-miembro.png` — miembro, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-08-opciones.svg` / `02-iconos-mapa-combate/png/jn-pant-08-opciones.png` — opciones, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-08-cierre.svg` / `02-iconos-mapa-combate/png/jn-pant-08-cierre.png` — cierre, 960×540 px.

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
