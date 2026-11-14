# Guía 04 — Localizacion

Propuesta 02 / Cristal vivo. **Estado: propuesta, sin aprobación gráfica individual.**

**Familia del manual:** `JN-PANT-04`.

## Piezas independientes

- `02-iconos-mapa-combate/svg/jn-pant-04-ficha.svg` / `02-iconos-mapa-combate/png/jn-pant-04-ficha.png` — ficha, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-04-ilustracion.svg` / `02-iconos-mapa-combate/png/jn-pant-04-ilustracion.png` — ilustracion, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-04-nombre.svg` / `02-iconos-mapa-combate/png/jn-pant-04-nombre.png` — nombre, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-04-coste.svg` / `02-iconos-mapa-combate/png/jn-pant-04-coste.png` — coste, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-04-datos.svg` / `02-iconos-mapa-combate/png/jn-pant-04-datos.png` — datos, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-04-acceso.svg` / `02-iconos-mapa-combate/png/jn-pant-04-acceso.png` — acceso, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-04-marco.svg` / `02-iconos-mapa-combate/png/jn-pant-04-marco.png` — marco, 960×540 px.

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
