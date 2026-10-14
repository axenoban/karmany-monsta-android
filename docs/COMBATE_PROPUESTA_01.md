# Propuesta experimental de combate 01

Estado: estructura de equipo, estadísticas, tres habilidades por especie y tabla del Libro aprobadas el 14 de octubre de 2026. Turnos, costes, fórmulas, efectos y balance por especie siguen pendientes. Las resonancias pertenecen al entrenador, según la aclaración del creador; ver DECISIONES_ENTRENADORES_03.md.

## Objetivo

Un primer encuentro completo y táctico, fácil de entender desde Android, con pocos sistemas que puedan ampliarse después. Las probabilidades y efectos aquí propuestos no se cargan en el juego hasta aprobarlos.

## Reglas propuestas

| Tema | Propuesta |
|---|---|
| Equipo | Hasta tres Karmany; uno activo por bando. Primer prototipo contra un enemigo salvaje. |
| Turno | Cada ronda ordena participantes por Velocidad. Cada participante dispone de una acción. Empates: prioridad alternada entre rondas para evitar ventaja permanente. |
| Cambio | Cambiar el Karmany activo consume la acción. Se limita a aliados disponibles. |
| Estadísticas | Vida, Ataque, Defensa y Velocidad. Valores concretos todavía pendientes de una ficha de balance. |
| Habilidades | Tres por especie en el primer prototipo: una acción física, una técnica con utilidad propia y una insignia. No repetir tres ataques que solo difieran en potencia. |
| Coste | Habilidad básica sin recarga; técnica e insignia con recargas a definir por ficha. Evitar introducir maná, consumibles o energía de espera antes de probar la base. |
| Precisión | Acciones deterministas inicialmente: sin pulsaciones cronometradas, críticos o fallos aleatorios. La incertidumbre inicial estará en captura. |
| Defensa | Ofrecer habilidades de protección como alternativa al daño. No añadir otro botón universal hasta comprobar necesidad. |
| Derrota | Vida cero significa fuera de combate. La derrota no se representa como muerte. |
| Captura | Tras derrotar al salvaje elegible, aplicar reglas aprobadas del Libro y los tres intentos. |
| Victoria del enemigo | Regreso al punto de partida sin pérdida de criaturas; recuperación fuera del combate pendiente de concretar. |
| Afinidades | No introducir zodiaco ni una tabla elemental. Resonancias no se convierten automáticamente en tipos elementales. |

Antes de programar daño, salud, recargas, recuperación o estados, deben aprobarse sus fórmulas y valores. Separar consentimiento sobre estructura de consentimiento sobre balance.

## Primer grupo candidato

Se proponen seis especies comunes de Tierras Bajas de Jade: Tanugami, Sakuromushi, Ushigane, Sakuraneko, Inubari y Kitsunibi. No se asignan estadísticas ni se supone que sean criaturas iniciales de Ezel.

| Especie | Referencia ecológica canónica; no asignación de habilidades | Pendiente |
|---|---|---|
| Tanugami | Aceite lumínico que purifica agua y alivia quemaduras. | Decidir traducción jugable; no asumir curación universal. |
| Sakuromushi | Chirrido lumínico que estimula germinación. | Definir utilidad de combate sin convertir arbitrariamente germinación en aumento de ataque. |
| Ushigane | Lomo lumínico protector que disipa fatiga. | Precisar alcance, duración y efecto de protección. |
| Sakuraneko | Aroma lumínico que calma el pulso y reduce espasmos. | Definir qué estados o recuperación admite el juego. |
| Inubari | Espinas lumínicas flexibles y sombrías proyectables. | Decidir qué manifestación puede usar una criatura al comienzo. |
| Kitsunibi | Flama lumínica que disipa bruma y reconforta; humo sombrío que bloquea visión. | Precisar relación entre resonancia disponible y habilidades. |

La fuente ofrece descripciones ecológicas, no una lista completa de ataques. Las fichas jugables serán propuestas explícitas, no información canónica inventada. Las resonancias activas son habilidades del entrenador; esta tabla no concede habilidades de resonancia a las criaturas.

## Tabla de Libro aprobada para pruebas

Tabla aprobada por el creador y configurada en data/book_levels.json. No establece todavía costes, compra de mejoras o niveles de entrenador.

| Libro | Común, por intento | Raro, por intento | Épico, por intento |
|---|---:|---:|---:|
| Inicial | 45% | Bloqueado | Bloqueado |
| Mejora 1 | 60% | 30% | Bloqueado |
| Mejora 2 | 75% | 45% | 20% |

Tres intentos independientes producen una posibilidad acumulada de éxito de `1 - (1 - p)^3`: 45% por intento equivale a 83,36% dentro de tres; 30% equivale a 65,7%; 20% equivale a 48,8%. El éxito termina antes los intentos. Un reencuentro es un combate nuevo, no un cuarto intento del mismo encuentro.

No cubrir rarezas legendarias, únicas ni excepciones de sellado hasta contar con reglas específicas. Costes de mejora, origen del Libro y condiciones de reencuentro siguen pendientes.

## Decisiones prioritarias actualizadas

Equipo, estadísticas, cantidad de habilidades y Libro ya están aprobados. Para continuar, decidir economía de acciones del entrenador, tipo inicial de Ezel y fichas concretas de habilidades/estadísticas. Ver DECISIONES_ENTRENADORES_03.md. No implementar reglas de las otras filas como si la aprobación de la estructura las incluyera.
