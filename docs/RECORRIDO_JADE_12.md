# Recorrido de Valle Jade · Preview 0.9.0

Baseline: Preview 17, cierre eded1d0. Decisiones aprobadas el 14 de octubre de 2026: desbloquear los encuentros en orden y completar cada punto por victoria; capturar es opcional. Pendiente de validación física en feature/jade-guided-route.

## Recorrido jugable

Mapa con cuatro puntos funcionales de prueba, sin nuevas localizaciones narrativas: Tanugami, Ushigane, Kitsunibi y Sakuromushi, en ese orden, siguiendo la lista de la propuesta. Las especies conservan sus fichas aprobadas. Solo el primer punto empieza disponible. Vencer completa el punto y habilita el siguiente. Un punto completado se puede repetir para intentar capturas; no se pierde avance por derrota o retirada. No se cambian las recompensas existentes por encuentro ni se añaden premios de recorrido.

Entrenamiento libre conserva el selector de cuatro rivales y nunca completa puntos del recorrido. Con un encuentro activo, el mapa ofrece Retomar encuentro y bloquea nuevos inicios. La comprobación de acceso también existe en el modelo, no solo en botones.

## Victoria y vínculo opcional

La victoria, el progreso habitual del entrenador y el recibo de avance se guardan en una sola transacción. Primero se completa el punto; después se presenta el Libro con sus reglas aprobadas. Es posible intentar el vínculo o elegir «Continuar recorrido sin vínculo». Esta segunda opción requiere confirmación y renuncia a los intentos restantes de ese encuentro; no simula captura ni escape ni concede una criatura. Se puede repetir el punto después.

Tras captura o escape aparece Continuar recorrido. Un tercer fallo de captura conserva el avance obtenido al vencer. Continuar solo limpia el encuentro ya ganado y su origen, manteniendo colección, equipo, árbol y puntos completados. La confirmación incluye identidad y revisión del encuentro para rechazar callbacks obsoletos.

## Estado y compatibilidad

JadeRoute separa definición, acceso, recibos y validación. Los datos viven en data/jade_route.json. campaign.route contiene schema 1, lista ordenada de puntos completados con el identificador de su primera victoria, y origen del encuentro actual. Cada origen debe coincidir con identidad y especie del encuentro real. Un recibo no se vuelve a añadir al repetir o reabrir el mismo resultado.

El perfil permanece en schema 3. La ausencia de route se acepta en partidas previas; la normalización incorpora un recorrido vacío. Ninguna victoria antigua de entrenamiento se convierte en progreso retroactivo. Se conservan encuentros schema 1/2 en combate, respuesta pendiente, reemplazo o Libro. El estado de la ruta no se mueve al cambiar de activo.

El progreso solo se publica en memoria si SaveStore finaliza la escritura. Una escritura fallida al iniciar, vencer o continuar conserva el checkpoint anterior. Pausa/reanudación mantienen el mismo encuentro y origen; el Timer aprobado sigue evitando respuestas duplicadas. Empezar un viaje nuevo reinicia también el recorrido mediante el mismo reinicio confirmado existente.

## Alcance y verificación

Se conservan motor, firma, paquete, estadísticas, iniciativa, Vida por encuentro, resonancias, recargas, captura y recompensas existentes. No se añaden historia, misiones, economía, inventario, desgaste ni evoluciones. La revisión mediante imágenes sigue desactivada.

Regresiones nuevas: acceso secuencial por modelo/UI, entrenamiento independiente, victoria antes de captura, escape, captura correcta, continuación confirmada, repetición sin recibos duplicados, derrota/reintento, reemplazo y respuesta pendiente, migración, datos inconsistentes, escritura fallida y controles con texto grande. Las regresiones anteriores también se ejecutan antes de exportar el APK. Prueba física en PRUEBA_ANDROID_12.md.
