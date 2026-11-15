# Archivo de imágenes · Jade nocturno

[Manual de componentes](../README.md) · [Catálogo](../catalogo.csv) · [Registro de archivos](registro.csv)

| Carpeta | Contenido |
|---|---|
| 00-referencias | Conceptos aportados; no son recursos de producción aprobados |
| 01-kit-maestro | Identidad, marcos, botones, paneles, tipografía y estados |
| 02-iconos-mapa-combate | Iconos, mapa, exploración y HUD/menús de combate |
| 03-equipo-y-progresion | Equipo, colección, Bestiario, Libro, perfil y resonancias |
| 04-pantallas-y-situaciones | Composiciones, tutorial, ajustes, resultados, vinculación y efectos |

Cada bloque contiene propuestas/ y aprobados/. Todavía no hay nuevas propuestas ni piezas de producción aprobadas. La referencia elegida está en00-referencias.

## Nombres y versiones
Usar minúsculas ASCII, guiones y versión de tres dígitos. Ejemplos de nombres futuros:
- jn-ctrl-01-boton-principal-normal-v001.png
- jn-ctrl-01-boton-principal-pulsado-v001.png
- jn-base-03-marco-panel-v001.svg
- jn-pant-06-combate-cabecera-v001.png

Una lámina con varias familias puede llamarse jn-kit-maestro-lamina-v001.png; registrar todos sus IDs separados por punto y coma. No sobreescribir versiones enviadas a revisión. Una variante aprobada se conserva en aprobados/ con el mismo número, registrando su origen y evidencia; las propuestas siguen en historial.

## Registro
Una fila por archivo en registro.csv: ruta relativa a esta carpeta, IDs, versión, estado, tamaño, transparencia, procedencia, fuente editable y aprobación. No inventar aprobaciones. Estados de archivo: referencia, propuesta, en_revision, aprobado, superado. Actualizar también el catálogo de familias.

Conservar originales y editables; no guardar cachés, temporales ni renders duplicados innecesarios. Para recursos grandes, revisar peso antes de subir; no convertir toda una pantalla en una textura del juego. Los PNG de muestra no sustituyen texto/barra/controles interactivos. El directorio queda fuera de la APK por estar bajo docs y de las importaciones Godot mediante .gdignore.

## Primera referencia
jn-referencia-estilo-v001.png es la imagen adjunta aportada por Axe el14/11/2026. Su dirección Jade nocturno fue elegida; no otorga aprobación individual de componentes ni cambia el canon.
