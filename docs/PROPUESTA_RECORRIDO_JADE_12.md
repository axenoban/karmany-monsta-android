# Propuesta de bloque 12 · Recorrido jugable de Valle Jade

Estado: ruta guiada y avance por victoria aprobados por el creador el 14 de octubre de 2026. Implementación en RECORRIDO_JADE_12.md; pendiente de validación física. Baseline: Preview 17 (0.8.1), código 1f6deae, cierre aprobado eded1d0, 14 de octubre de 2026.

## Objetivo recomendado

Pasar del encuentro de entrenamiento repetible a un recorrido con avance visible y persistente. Reutilizar los cuatro rivales actuales y sus fichas aprobadas: Tanugami, Ushigane, Kitsunibi y Sakuromushi. El entrenamiento se conserva como acceso separado. Los puntos del recorrido serán identificadores funcionales de prueba; no se presentan como localizaciones canónicas nuevas.

## Decisiones presentadas (resueltas)

1. Acceso: ruta guiada que desbloquea el siguiente encuentro, o cuatro puntos disponibles desde el inicio. Recomendación: guiada, para comprobar un recorrido de principio a fin.
2. Condición de avance: vencer, manteniendo la captura opcional, o capturar para completar el punto. Recomendación: vencer; no hacer depender el avance de los intentos de Libro. Si la captura falla tres veces, sigue siendo una victoria y se permite repetir el encuentro para intentar el vínculo.

El creador eligió explícitamente ambas recomendaciones: acceso guiado y victoria suficiente, con captura opcional.

## Bloque técnico propuesto

1. Datos del recorrido desacoplados de textos y presentación del mapa.
2. Modelo de progreso con identidades de puntos y resultados completados.
3. Mapa por puntos con acceso y estado visible, sin inventar geografía o trama.
4. Comprobación de acceso en el modelo, además de botones deshabilitados.
5. Identificación del encuentro y su origen: entrenamiento o recorrido.
6. Registro idempotente del resultado para que reabrir no duplique avance ni recompensas existentes.
7. Persistencia compatible: las partidas anteriores comienzan sin progreso ficticio del recorrido.
8. Reanudación del encuentro asociado al punto, incluyendo respuesta rival, reemplazo y Libro.
9. Presentación de avance, resultado y finalización del recorrido de prueba.
10. Regresiones de acceso, victoria/derrota, captura/escape, repetición, escritura fallida, suspensión y actualización desde Preview 17.

Se conservan equipo de tres, activo, curación al iniciar ensayo, recargas, resonancias, arte, captura y progreso de entrenador actuales. No se conceden premios nuevos ni se cambia la progresión por repetir encuentros. No se añaden costes de desplazamiento, desgaste entre encuentros, monedas, inventario, evoluciones, especies, diálogos o misiones.

## Etapas posteriores sugeridas, aún sin diseño aprobado

- Progresión del Libro: las probabilidades ya están aprobadas, pero falta decidir cómo desbloquear sus mejoras y sus condiciones/costes.
- Primer tramo narrativo: requiere fuente o texto aprobado para Ezel y Axe, objetivos y localizaciones.
- Expansión de especies y habilidades: exige otra propuesta conjunta de fichas, arte y balance.

No abrir estas tres integraciones simultáneamente ni tratarlas como autorizadas por validar el panel de combate. Elegir y validar cada bloque con una build actualizable.
