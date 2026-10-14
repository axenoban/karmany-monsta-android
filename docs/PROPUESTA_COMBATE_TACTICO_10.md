# Propuesta 10 · Combate táctico y cinco especies

Estado: propuesta aprobada por el creador para ensayo; implementada en Preview 0.8.0, pendiente de validación física. Fecha: 14 de octubre de 2026. Baseline remoto verificado: dev/karmany-core, 67d006dd268f95dc6351b9bc39a9ba42b54a3c2b. Este documento registra la propuesta original; la implementación está descrita en COMBATE_TACTICO_10.md y no constituye canon definitivo.

## Alcance ya decidido por el creador

- Prioridad: combate táctico; equipo máximo de tres, un activo.
- Cambio voluntario: consume la acción del Karmany y provoca respuesta rival automática; resonancia opcional antes.
- Incorporaciones: Ushigane, Kitsunibi y Sakuromushi; se mantienen Zephyr y Tanugami.
- Cuando cae el activo, elegir un compañero disponible sin recibir otro ataque rival por ese reemplazo.
- Preparar fichas experimentales para aprobación antes de programar sus cifras y efectos.

## Canon y adaptación

Fuente de las tres especies: data/jade_species.json, entradas 3, 6 y 2 respectivamente; catálogo previamente aprobado de la Enciclopedia Oficial de Shisai. Las tres son comunes de Tierras Bajas de Jade. Ushigane tiene placas similares al bronce; Kitsunibi es un zorro crema con fósforo en la cola; Sakuromushi es un coleóptero con caparazón similar a madera de cerezo. Tanugami conserva la calabaza como parte anatómica. Zephyr conserva su referencia visual aprobada.

El canon no define estadísticas de combate, efectos numéricos ni estos nombres de habilidades. Todos los nombres siguientes son etiquetas funcionales de ensayo. La traducción a mecánicas no añade estados lumínico/sombrío seleccionables, afinidades elementales, evoluciones o diálogos. No se atribuye a la fisiología el porcentaje propuesto como si apareciera en la fuente.

## Estadísticas propuestas

| Especie | Vida | Ataque | Defensa | Velocidad | Función de ensayo |
|---|---:|---:|---:|---:|---|
| Zephyr | 80 | 20 | 8 | 10 | Daño directo; referencia actual |
| Tanugami | 80 | 20 | 8 | 10 | Recuperación personal |
| Ushigane | 96 | 18 | 10 | 10 | Resistencia y protección |
| Kitsunibi | 68 | 22 | 6 | 10 | Ofensiva con reducción de respuesta rival |
| Sakuromushi | 76 | 19 | 9 | 10 | Apoyo al próximo ataque de un compañero |

Vida/Ataque/Defensa de Zephyr y Tanugami conservan las cifras aprobadas del prototipo. Velocidad permanece 10 y no altera la iniciativa: actualmente no tiene uso en el motor. Darle prioridad de acciones contradiría el flujo jugador-respuesta rival aprobado; su función se diseñaría en otra fase. No mostrarla como si otorgara una ventaja táctica.

## Tres habilidades por especie

Todas conservan dos habilidades base: **Golpe**, potencia 100%, sin recarga; **Protección**, reducción del 50% del próximo ataque recibido, sin recarga. Protección también entrega la fase al rival. No causa daño ni se acumula consigo misma.

| Especie | Insignia de ensayo | Efecto propuesto | Recarga |
|---|---|---|---:|
| Zephyr | Insignia de impacto | Ataque con potencia 150%; comportamiento actual | 2 |
| Tanugami | Insignia de recuperación | Recuperar 12 de Vida propia y proteger un 25% ante el próximo ataque recibido; no causa daño | 3 |
| Ushigane | Insignia de bronce | Ataque con potencia 125% y protección propia del 25% ante el próximo ataque recibido | 2 |
| Kitsunibi | Insignia del candil | Ataque con potencia 120%; reducir 30% el daño del próximo ataque del rival | 2 |
| Sakuromushi | Insignia de apoyo | Ataque con potencia 100%; otorgar +25% al próximo ataque de un miembro vivo del equipo, elegido antes de confirmar | 2 |

Recarga N significa esperar N turnos completos: usar en turno 1 una insignia de recarga 2 permite repetirla en turno 4; la de recarga 3, en turno 5. Cada individuo conserva sus recargas al cambiar de posición. No se necesita ni consume un recurso nuevo.

La insignia de Tanugami sustituiría explícitamente su ataque especial genérico; este es un cambio de balance pendiente de aprobación. Si tiene Vida completa, no puede usarla. Recuperar Vida nunca supera el máximo ni revive a un derrotado. La protección puede coincidir con otras fuentes, pero solo cuenta el mayor porcentaje.

Sakuromushi puede elegirse a sí mismo. Primero resuelve su ataque consumiendo la potenciación previa; después otorga la nueva potenciación al destinatario. El apoyo a una reserva queda asociado a ese individuo para su próximo ataque. No transfiere una acción, no revive ni permite atacar desde la reserva.

## Resolución y efectos

1. Daño base = max(1, round(Ataque × potencia × (1 + potenciación) − Defensa del destinatario)). Potencia 100% equivale a 1,0, no a 100 puntos de daño.
2. Daño final = max(1, round(daño base × (1 − protección del destinatario) × (1 − debilitamiento del atacante))). Se conserva el orden aritmético existente y el redondeo positivo de Godot.
3. En una habilidad con daño y efecto, el daño se resuelve primero y el efecto después. Un enemigo derrotado no actúa; se pasa al Libro. No se aplican efectos a un objetivo derrotado.
4. Protección, potenciación y debilitamiento no se suman entre fuentes: conservar el mayor porcentaje pendiente. Protección/debilitamiento se consumen con el siguiente ataque pertinente; potenciación con el próximo ataque del beneficiario. Una habilidad sin daño no consume potenciación ni debilitamiento. Fin del encuentro elimina esos efectos.
5. Efectos y recargas pertenecen a cada individuo; cambiar de activo no los elimina ni los duplica. Se conserva el máximo defensivo del prototipo: 80% para protección/debilitamiento, daño mínimo 1.
6. Resonancias del entrenador conservan cifras, escalado de rango, equipo y recargas aprobados. Se dirigen al activo en ese momento; los efectos que le conceden no migran al nuevo activo. Los efectos dirigidos al enemigo permanecen sobre ese enemigo. Mostrar destinatario y aviso antes de confirmar un cambio.

El punto 4 requiere ampliar la combinación de efectos del motor para habilidades nuevas, manteniendo los resultados anteriores cuando interviene una sola fuente. Es una regla nueva pendiente de aprobación, no una corrección silenciosa del balance estable.

## Equipo, cambio y derrota

- Cada encuentro inicia con los miembros del equipo a Vida completa, como los ensayos actuales; la Vida de cada reserva se conserva durante ese encuentro. No se introduce desgaste entre encuentros, sistema de descanso ni costes de curación.
- Se puede cambiar a un miembro vivo distinto del activo. Cancelar o seleccionar el mismo no consume acción. Confirmar guarda el cambio, consume la acción y programa una sola respuesta del rival contra el nuevo activo.
- Cambiar no concede otra resonancia. Si no se usó la resonancia antes, se omite al confirmar el cambio.
- Si el activo cae por respuesta rival, detener la resolución en una fase persistente de elección de reemplazo. No ejecutar un ataque adicional, no elegir automáticamente un miembro y no permitir resonancias mientras se elige.
- Confirmar reemplazo abre la fase siguiente del jugador con su resonancia y acción disponibles. No añade un turno adicional aparte del siguiente turno normal y no adelanta recargas por doble incremento.
- Si no queda ningún miembro vivo, derrota. No se pierden colección, puntos o criaturas. No se autoriza revivir ni cambiar integrantes del equipo durante un encuentro.
- Capturar añade la especie realmente derrotada con identificador individual, una sola vez. No se incorpora al combate ya terminado. El equipo sigue limitado a tres; cinco especies disponibles no significa cinco plazas.
- El activo elegido durante el combate se conserva como selección para el siguiente ensayo, donde comienza recuperado. Cambios de composición permanecen fuera del combate.

## Encuentros y rival

Propuesta de acceso: conservar el punto de Entrenamiento del mapa y añadir dentro de él un selector de rival entre Tanugami, Ushigane, Kitsunibi y Sakuromushi. No se inventan puntos narrativos, misiones, pesos aleatorios o localizaciones específicas. Zephyr sigue siendo el inicial; no se propone su captura salvaje.

Cada rival usa su ficha y habilidades reales, con las mismas cifras y recargas del jugador. IA inicial reproducible: usar insignia si está disponible; Tanugami solo si le faltan al menos 12 de Vida, de lo contrario Golpe. Sakuromushi rival se apoya a sí mismo. Sin resonancias de entrenador rival, ataques extra, adaptación oculta ni acceso a tiradas de captura. La IA no usa Protección en esta primera política; el jugador sí puede hacerlo.

Libro sin cambios: estas cuatro especies rivales comunes son elegibles tras derrota, probabilidad inicial 45%, hasta tres intentos y escape final; se puede reencontrar la especie. Las capturas siguen alimentando los hitos por especies distintas del árbol. No se implementan mejoras comprables, monedas o economía en este bloque.

## Comprobación inicial de balance

Ver proposals/COMBAT_10_SCREENING.md y su simulador reproducible. Se compararon 20 duelos: cinco aliados frente a cuatro rivales, sin entrenador, cambios ni apoyo a reservas. La política de insignia descrita arriba produce resultados en 4–16 turnos; ningún duelo alcanzó el límite de 60. El límite solo permite informar un resultado inconcluso en el análisis; no impone duración al juego.

Zephyr como jugador vence los cuatro rivales; Ushigane también. Esto incluye ventaja de actuar primero y no demuestra equilibrio global ni dominancia de Ushigane. Kitsunibi pierde ante Ushigane y queda con solo 1 de Vida frente a Sakuromushi: señal de fragilidad a revisar. Tanugami contra sí mismo dura 16 turnos por recuperación: riesgo de encuentros largos. Sakuromushi conserva valor de apoyo no medido por duelos individuales.

Una propuesta preliminar de Tanugami con curación 16/recarga 2 alargaba su espejo a 38 turnos; se redujo a 12/recarga 3 antes de presentar la ficha. No se modificó el juego aprobado. Las cifras finales de esta propuesta requieren pruebas con resonancias, cambios y equipos de hasta tres antes de considerarlas balance definitivo.

## Implementación propuesta tras aprobación

Un bloque con 13 componentes relacionados: catálogo jugable versionado; resolución de efectos múltiples; estado de individuos; cambio voluntario; reemplazo forzoso; IA; selector de encuentros; captura multiespecie; colección/equipo genéricos; adaptación de UI/ayudas; tres ilustraciones canónicas; migración/guardado; regresiones y APK.

- Separar los encuentros nuevos del formato antiguo. Los encuentros en curso de Preview 15 terminan con sus cifras y reglas anteriores, incluida su respuesta pendiente, y no incorporan reservas retroactivamente. El nuevo motor se aplica al siguiente encuentro.
- Conservar partida, identidad de capturas, árbol y equipo. Añadir migración validada y respaldo; no convertir un estado de captura en combate ni volver a entregar recompensas.
- Guardar Vida, destinatarios, efectos, recargas, cambio pendiente y fase de reemplazo. Timer/respuesta por revisión siguen evitando duplicación al suspender o cerrar.
- Arte 2D separado de fondos, usando fichas del catálogo y referencias aprobadas. No generar variantes sombrías/lumínicas o nuevas escenas narrativas.
- Última acción única describe daño y efecto juntos, incluyendo beneficiario. Barra de equipo muestra Vida y derrotados; tocar reserva abre elección con coste visible, sin cambiar al primer toque accidental.
- Mantener capturas de revisión desactivadas. Validar geometría y acciones por pruebas de nodos; comprobación visual física por el creador.

## Criterios de entrega

Regresiones anteriores, migración de encuentros antiguos y capturas, dos ejemplares de una especie con estados independientes, efectos sin acumulación, apoyo con destinatario, recargas al rotar, cambios dobles, respuesta contra nuevo activo, derrota/reemplazo sin golpe extra, derrota total, captura correcta de cada especie, hitos distintos del árbol, guardado fallido, suspensión en respuesta/reemplazo y render desactivado. APK actualizable sobre Preview 15. No integrar a dev hasta validación física.

## Solicitud original de aprobación (resuelta)

El creador aprobó probar estas fichas el 14 de octubre de 2026. La solicitud original incluía: sustitución de insignia de Tanugami, efectos no acumulables asociados al individuo, recargas, ausencia de iniciativa por Velocidad, recuperación al iniciar ensayo, selector de cuatro rivales y política inicial de IA. La selección de especies y el coste del cambio/reemplazo ya fueron decididos; no se solicitan nuevamente.
