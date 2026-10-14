# Bloque 02 · Bestiario y contratos de captura

Estado: pendiente de validación del creador.

## Incluye

- Consulta de 15 especies de Tierras Bajas de Jade, extraídas de las entradas 1–15 de la enciclopedia aportada. Conserva fuente, sección y huella SHA-256 del PDF.
- Filtros por rareza, fisiología, comportamiento y resonancias lumínica/sombría.
- Contratos técnicos de Libro y captura: elegibilidad posterior a derrota, rareza permitida, tres intentos, escape, éxito terminal, rechazo de doble acción y serialización de intentos.
- Probabilidades de producción ausentes hasta aprobación. Los números utilizados por las regresiones son fixtures sintéticos; no son reglas de Karmany.

El bestiario es una consulta de la enciclopedia en esta preview. No es la colección del jugador ni establece reglas de descubrimiento/desbloqueo. No confirma disponibilidad de las 15 especies como encuentros del primer capítulo.

El motor de captura no está conectado todavía a combate o guardado de partida. Dispone de snapshot/restore para la futura integración, probados con JSON. No se añaden criaturas o recompensas a la partida en este bloque.

## Prueba en el teléfono

1. Instalar el APK encima de Preview 3, sin desinstalar.
2. Comprobar que Continuar conserva la visita y los ajustes anteriores.
3. Desde Valle Jade abrir Bestiario de Valle Jade.
4. Todas debe mostrar 15 especies; Común 9; Raro 5; Épico 1.
5. Abrir Tanugami, Kirin-Chigo y una ficha al final de la lista. Revisar desplazamiento, lectura y textos de resonancia.
6. Volver desde una ficha debe regresar a la lista manteniendo el filtro. Volver desde el bestiario regresa a Valle Jade.
7. Con Texto grande activado, repetir filtros y lectura.
8. Suspender/reabrir y comprobar que los controles siguen funcionando.

Resultado esperado: no hay errores, pérdida de guardado, filtros incorrectos ni fichas inventadas. Todavía no existe combate jugable.

## Regresiones

Se conserva la suite de guardado/navegación del bloque validado y se amplía con navegación del catálogo. Una suite independiente comprueba catálogo, acceso por Libro, tres fallos, cuarto intento, éxito terminal, doble toque, restauración y reencuentro con ID nuevo.

Para continuar al primer combate, revisar `docs/COMBATE_PROPUESTA_01.md` y aprobar las decisiones de diseño pendientes.
