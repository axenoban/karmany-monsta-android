# Guía 14 — Bestiario

Propuesta 02 / Cristal vivo. **Estado: propuesta, sin aprobación gráfica individual.**

**Familia del manual:** `JN-PANT-14`.

## Piezas independientes

- `03-equipo-y-progresion/svg/jn-pant-14-especie.svg` / `03-equipo-y-progresion/png/jn-pant-14-especie.png` — especie, 512×512 px.
- `03-equipo-y-progresion/svg/jn-pant-14-silueta.svg` / `03-equipo-y-progresion/png/jn-pant-14-silueta.png` — silueta, 512×512 px.
- `03-equipo-y-progresion/svg/jn-pant-14-filtro.svg` / `03-equipo-y-progresion/png/jn-pant-14-filtro.png` — filtro, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-14-rareza.svg` / `03-equipo-y-progresion/png/jn-pant-14-rareza.png` — rareza, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-14-registro.svg` / `03-equipo-y-progresion/png/jn-pant-14-registro.png` — registro, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-14-ficha.svg` / `03-equipo-y-progresion/png/jn-pant-14-ficha.png` — ficha, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-14-lista.svg` / `03-equipo-y-progresion/png/jn-pant-14-lista.png` — lista, 960×540 px.

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
