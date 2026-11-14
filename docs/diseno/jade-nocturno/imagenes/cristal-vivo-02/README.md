# Cristal vivo 02 — kit gráfico parametrizado

Estado: **PROPUESTA DE RECURSOS**, no aprobación artística individual; no se han modificado escenas Godot ni APK. La elección de la dirección Cristal vivo NO aprueba automáticamente cada exportación.

Este directorio contiene **401 SVG con identificadores y variantes independientes** en las carpetas de cada bloque, un generador reproducible y un manifiesto con 401 filas.

Reutilización intencional: muchas variantes de pantallas y paneles reutilizan la misma geometría; los 401 nombres no representan 401 ilustraciones originales diferentes. Personajes, escenarios y cifras no se dibujan aquí ni sustituyen los recursos canónicos.

**Identidad gráfica:** cristal jade, superficies tinta/translúcidas, borde dorado biselado, gesto orgánico de filigrana, jerarquías claras; Golpe cálido, Protección fría, Insignia dorada. Los símbolos de navegación y combate corresponden a los nombres existentes.

**Rutas:** `../01-kit-maestro/propuestas/cristal-vivo-02/svg/`, `../02-iconos-mapa-combate/...`, `../03-equipo-y-progresion/...`, `../04-pantallas-y-situaciones/...`. Los PNG transparentes y hojas de revisión se producen con el script `generar_kit.py`, ejecutado localmente y archivado para entrega de revisión.

**Reproducir:** `python -m pip install pillow cairosvg` y luego `python generar_kit.py --output /ruta/de/salida` (fondo opcional con `--background`). No sustituir `assets/ui` sin aprobación expresa.

**Verificación del kit:** 401 SVG XML válidos, 401 PNG RGBA de tamaño esperado, 53 familias, 21 guías de pantalla, botones con iconos semánticos comprobados: 805 controles estructurales, más aserciones de semántica. Esto no es una prueba de regresión Godot ni una validación Android.

**Pendientes antes de usar en producción:** revisión artística por familia, contraste y tactilidad Android, regla de escalado/NinePatch con cortes por marco, pruebas 1280×720 y 960×540, licencia de tipografía, integración progresiva y regresiones.

El `manifiesto.csv` incluye hash SHA-256 de SVG y PNG, pero el código Git almacena únicamente los SVG + generador para evitar duplicar ráster regenerable en la rama visual. El paquete completo con PNG y guías se entrega separadamente para revisión.
