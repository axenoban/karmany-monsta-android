# Guía 03 — Mapa

Propuesta 02 / Cristal vivo. **Estado: propuesta, sin aprobación gráfica individual.**

**Familia del manual:** `JN-PANT-03`.

## Piezas independientes

- `02-iconos-mapa-combate/svg/jn-pant-03-marcador.svg` / `02-iconos-mapa-combate/png/jn-pant-03-marcador.png` — marcador, 170×170 px.
- `02-iconos-mapa-combate/svg/jn-pant-03-conexion.svg` / `02-iconos-mapa-combate/png/jn-pant-03-conexion.png` — conexion, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-03-disponible.svg` / `02-iconos-mapa-combate/png/jn-pant-03-disponible.png` — disponible, 170×170 px.
- `02-iconos-mapa-combate/svg/jn-pant-03-completado.svg` / `02-iconos-mapa-combate/png/jn-pant-03-completado.png` — completado, 170×170 px.
- `02-iconos-mapa-combate/svg/jn-pant-03-bloqueado.svg` / `02-iconos-mapa-combate/png/jn-pant-03-bloqueado.png` — bloqueado, 170×170 px.
- `02-iconos-mapa-combate/svg/jn-pant-03-seleccion.svg` / `02-iconos-mapa-combate/png/jn-pant-03-seleccion.png` — seleccion, 170×170 px.
- `02-iconos-mapa-combate/svg/jn-pant-03-stamina.svg` / `02-iconos-mapa-combate/png/jn-pant-03-stamina.png` — stamina, 960×540 px.
- `02-iconos-mapa-combate/svg/jn-pant-03-cabecera.svg` / `02-iconos-mapa-combate/png/jn-pant-03-cabecera.png` — cabecera, 960×540 px.

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
