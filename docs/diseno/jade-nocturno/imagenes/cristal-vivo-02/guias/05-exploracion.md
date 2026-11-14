# Guía 05 — Exploracion

Propuesta 02 / Cristal vivo. **Estado: propuesta, sin aprobación gráfica individual.**

**Familia del manual:** `JN-PANT-05`.

## Piezas independientes

- `02-iconos-mapa-combate/svg/jn-pant-05-hud.svg` / `02-iconos-mapa-combate/png/jn-pant-05-hud.png` — hud, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-05-contexto.svg` / `02-iconos-mapa-combate/png/jn-pant-05-contexto.png` — contexto, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-05-accion.svg` / `02-iconos-mapa-combate/png/jn-pant-05-accion.png` — accion, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-05-aviso.svg` / `02-iconos-mapa-combate/png/jn-pant-05-aviso.png` — aviso, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-05-transicion.svg` / `02-iconos-mapa-combate/png/jn-pant-05-transicion.png` — transicion, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-05-marco.svg` / `02-iconos-mapa-combate/png/jn-pant-05-marco.png` — marco, 960×540 px.

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
