# Cristal vivo 02 — kit gráfico parametrizado

**Estado: propuesta, no aprobación artística ni incorporación a Godot.** No modifica APK, reglas, guardados ni assets activos.

Este bloque contiene **401 SVG con identificadores y variantes** distribuidos por 53 familias, con manifiesto SHA-256 y generador Python. Reutilizar geometrías de paneles entre pantallas es intencional; 401 archivos NO equivalen a 401 obras distintas.

### Reproducir SVG/PNG y revisar en una galería offline

`python -m pip install pillow cairosvg`

`python generar_kit.py --output /ruta/kit`

`python crear_galeria.py /ruta/kit`

Después abrir `GALERIA_VISUAL.html` desde la carpeta resultante, o consultar las 53 láminas de `galeria/`. Los PNG transparentes no se commitean individualmente: se generan automáticamente desde SVG y se entregan también en el ZIP de revisión. La miniatura PNG `VISTA_PREVIA_MAESTRA.png` funciona como referencia rápida en el repositorio.

**Diseño:** Jade Nocturno / Cristal Vivo 02; paneles verde profundo, brillos de jade, marcos dorados. Golpe, Protección e Insignia con símbolos propios; estados normal, pulsado, seleccionado, enfocado, deshabilitado, bloqueado diferenciados por forma y acabado.

Las guías de pantallas y archivos son prototipos de estructura reutilizables, no maquetas 100% fieles a todo arte o a cada pantalla final. El canon, las estadísticas y las cifras de juego siguen siendo dinámicos.

### QA y restricciones

805 comprobaciones estructurales locales, y aserciones semánticas de iconos, correctas para el paquete vectorial+PNG. **No se ejecutaron pruebas Godot ni prueba física Android para esta entrega.** Revisar visualmente la calidad antes de aceptar familias, medir NinePatch por recurso, accesibilidad y 1280×720/960×540 en el juego real. No integrar sin aprobación explícita.
