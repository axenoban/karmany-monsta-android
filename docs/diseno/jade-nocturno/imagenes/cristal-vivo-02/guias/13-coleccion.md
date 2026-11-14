# Guía 13 — Coleccion

Propuesta 02 / Cristal vivo. **Estado: propuesta, sin aprobación gráfica individual.**

**Familia del manual:** `JN-PANT-13`.

## Piezas independientes

- `03-equipo-y-progresion/svg/jn-pant-13-tarjeta.svg` / `03-equipo-y-progresion/png/jn-pant-13-tarjeta.png` — tarjeta, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-13-resumen.svg` / `03-equipo-y-progresion/png/jn-pant-13-resumen.png` — resumen, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-13-seleccion.svg` / `03-equipo-y-progresion/png/jn-pant-13-seleccion.png` — seleccion, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-13-incorporar.svg` / `03-equipo-y-progresion/png/jn-pant-13-incorporar.png` — incorporar, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-13-filtro.svg` / `03-equipo-y-progresion/png/jn-pant-13-filtro.png` — filtro, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-13-detalle.svg` / `03-equipo-y-progresion/png/jn-pant-13-detalle.png` — detalle, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-13-lista.svg` / `03-equipo-y-progresion/png/jn-pant-13-lista.png` — lista, 960×540 px.

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
