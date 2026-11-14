# Guía 01 — Inicio

Propuesta 02 / Cristal vivo. **Estado: propuesta, sin aprobación gráfica individual.**

**Familia del manual:** `JN-PANT-01`.

## Piezas independientes

- `04-pantallas-y-situaciones/svg/jn-pant-01-cabecera.svg` / `04-pantallas-y-situaciones/png/jn-pant-01-cabecera.png` — cabecera, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-01-menu.svg` / `04-pantallas-y-situaciones/png/jn-pant-01-menu.png` — menu, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-01-continuar.svg` / `04-pantallas-y-situaciones/png/jn-pant-01-continuar.png` — continuar, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-01-nueva_partida.svg` / `04-pantallas-y-situaciones/png/jn-pant-01-nueva_partida.png` — nueva_partida, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-01-confirmacion.svg` / `04-pantallas-y-situaciones/png/jn-pant-01-confirmacion.png` — confirmacion, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-01-fondo.svg` / `04-pantallas-y-situaciones/png/jn-pant-01-fondo.png` — fondo, 960×540 px.

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
