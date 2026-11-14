# Guía 16 — Perfil Ezel

Propuesta 02 / Cristal vivo. **Estado: propuesta, sin aprobación gráfica individual.**

**Familia del manual:** `JN-PANT-16`.

## Piezas independientes

- `03-equipo-y-progresion/svg/jn-pant-16-retrato.svg` / `03-equipo-y-progresion/png/jn-pant-16-retrato.png` — retrato, 512×512 px.
- `03-equipo-y-progresion/svg/jn-pant-16-identidad.svg` / `03-equipo-y-progresion/png/jn-pant-16-identidad.png` — identidad, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-16-nivel.svg` / `03-equipo-y-progresion/png/jn-pant-16-nivel.png` — nivel, 800×94 px.
- `03-equipo-y-progresion/svg/jn-pant-16-experiencia.svg` / `03-equipo-y-progresion/png/jn-pant-16-experiencia.png` — experiencia, 800×94 px.
- `03-equipo-y-progresion/svg/jn-pant-16-equipo.svg` / `03-equipo-y-progresion/png/jn-pant-16-equipo.png` — equipo, 960×540 px.
- `03-equipo-y-progresion/svg/jn-pant-16-resonancia.svg` / `03-equipo-y-progresion/png/jn-pant-16-resonancia.png` — resonancia, 960×540 px.

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
