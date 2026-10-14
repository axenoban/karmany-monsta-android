# Claridad del combate · Preview 0.8.1

Baseline aprobado: Preview 16 (0.8.0), c3be194, cierre 2d90c5e. El creador validó el bloque 10 y autorizó continuar el 14 de octubre de 2026. El creador validó físicamente este bloque mediante Preview 17 el 14 de octubre de 2026; integrado por fast-forward a dev/karmany-core.

Objetivo: consultar las reglas ya implementadas durante el combate desde Android, sin depender de un tooltip sobre un botón deshabilitado. No modifica fichas, resolución, iniciativa, captura, economía, progresión o datos de guardado.

## Componentes del bloque

1. Adaptador de lectura separado del motor, con copia de los datos del encuentro.
2. Consulta de Vida actual/máxima, Ataque y Defensa del activo y del rival.
3. Presentación de protección, potenciación y debilitamiento, con dirección y condición de consumo.
4. Equipo por identidad individual: activo, reserva o derrotado, Vida, efectos y recarga propia.
5. Explicación de las tres técnicas y del beneficiario elegido para apoyo.
6. Resonancias equipadas con sus cifras reales según rango y redondeo del motor.
7. Recarga nominal, turno de disponibilidad y motivo actual de bloqueo obtenido del propio motor.
8. Panel táctil con cuatro pestañas y desplazamiento vertical, texto grande y cierre sin acciones de combate.
9. Adaptación de lectura de encuentros antiguos: cifras de Preview 15 y respuesta rival cada tercer turno.
10. Regresiones de pureza, dirección de efectos, duplicados, disposición móvil, interacción y teardown.

## Interacción y persistencia

El botón «Estado y técnicas» está en la cabecera del combate, también durante reemplazo o captura. Las pestañas Activos, Equipo, Técnicas y Resonancias permiten inspeccionar el estado. No se añade otra fila al área de acciones. El panel utiliza cifras del snapshot actual; no ejecuta acciones ni guarda cambios. No muestra Velocidad como ventaja de iniciativa porque aún no tiene esa función.

Abrirlo no detiene ni reinicia la respuesta rival de 0,7 s. Si esta se resuelve con el panel abierto, la actualización de pantalla elimina el snapshot anterior para evitar información obsoleta. Cerrar o destruir la página libera el panel y no deja coroutines. Consultarlo funciona aunque la ruta de guardado no sea escribible.

Las técnicas muestran efectos numéricos y no una predicción de daño final. La Vida recuperada real sigue limitada por la Vida faltante. El turno de disponibilidad y los motivos de bloqueo se muestran por separado: una recarga vencida no implica poder actuar durante la fase rival o de reemplazo.

No se alteran motor, firma, paquete ni esquemas. La revisión mediante imágenes continúa desactivada. Ver PRUEBA_ANDROID_11.md para validación física.
