# Guía 19 — Configuracion

Propuesta 02 / Cristal vivo. **Estado: propuesta, sin aprobación gráfica individual.**

**Familia del manual:** `JN-PANT-19`.

## Piezas independientes

- `04-pantallas-y-situaciones/svg/jn-pant-19-grupo.svg` / `04-pantallas-y-situaciones/png/jn-pant-19-grupo.png` — grupo, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-19-interruptor.svg` / `04-pantallas-y-situaciones/png/jn-pant-19-interruptor.png` — interruptor, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-19-deslizador.svg` / `04-pantallas-y-situaciones/png/jn-pant-19-deslizador.png` — deslizador, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-19-separador.svg` / `04-pantallas-y-situaciones/png/jn-pant-19-separador.png` — separador, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-19-ayuda.svg` / `04-pantallas-y-situaciones/png/jn-pant-19-ayuda.png` — ayuda, 960×540 px.
- `04-pantallas-y-situaciones/svg/jn-pant-19-confirmacion.svg` / `04-pantallas-y-situaciones/png/jn-pant-19-confirmacion.png` — confirmacion, 960×540 px.

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
