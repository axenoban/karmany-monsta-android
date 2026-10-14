# Decisiones aprobadas y propuesta de entrenadores

Actualización: 14 de octubre de 2026. El creador aprobó Preview 4 y pidió aplicar las sugerencias 1 y 3; aclaró que las resonancias son habilidades del entrenador.

## Aprobado

- Equipo de hasta tres Karmany, uno activo por bando.
- Vida, Ataque, Defensa y Velocidad; valores por especie todavía pendientes.
- Tres habilidades iniciales por especie, incluida una insignia; efectos y valores todavía pendientes.
- Las resonancias son habilidades del entrenador. Habrá distintos tipos de entrenador, con distintas funciones.
- Aclaración posterior del creador: entrenador y Karmany comparten el turno; evitar turnos separados. El entrenador debe poder aprender resonancias y construir estrategias más complejas, sin quedar limitado a curar.
- Tipo Curador: sus resonancias curan a sus Karmany. Todavía sin nombres, cantidades, recursos, recargas o selección de objetivos definidos.
- Tabla del Libro: Inicial Común 45%; Mejora 1 Común 60%/Raro 30%; Mejora 2 Común 75%/Raro 45%/Épico 20%. Cada cifra es por intento. Las rarezas no incluidas están bloqueadas.
- Tres intentos después de derrotar a un Karmany elegible; escape al agotar intentos y posibilidad de otro encuentro.

Las descripciones de resonancia lumínica/sombría de la enciclopedia son referencias ecológicas y narrativas. No se borran ni se convierten automáticamente en habilidades activables de una criatura. Las habilidades de Karmany y del entrenador deben tener catálogos independientes.

## Implementación de este bloque

Datos de Libro separados de lógica de captura, validación de mejoras que no reduzcan acceso/probabilidad, configuración de estructura, equipo con identidad individual y único activo, y registro de tipos de entrenador ampliable. Solo Curador está registrado; no se asigna un tipo a Ezel o Axe. El curador tiene habilidades vacías de forma explícita hasta definirlas.

Las pantallas del Libro y Entrenadores consultan esas reglas reales. No permiten comprar mejoras ni conceden un entrenador o Karmany inicial. Motor, firma, paquete y guardado aprobado se conservan.

## Propuesta de funcionamiento para decidir

La recomendación anterior de sustituir la acción del Karmany por la del entrenador se retira como propuesta principal tras la aclaración del creador. No está implementada.

Nueva propuesta, pendiente de confirmar el presupuesto exacto: un turno compartido del bando permite hasta una acción del Karmany y una resonancia opcional del entrenador. El jugador decide el orden de ambas. El entrenador no tiene una entrada propia en la iniciativa ni un turno adicional. Usar la resonancia no exige renunciar siempre a actuar con el Karmany, pero requiere un límite de frecuencia/coste aprobado.

Ejemplos funcionales de combos para revisar, sin nombres canónicos ni valores: potenciar antes de atacar, proteger antes de una acción arriesgada, actuar con el Karmany y después curarlo, controlar al rival para apoyar otra acción. El orden importa solo cuando las reglas de duración/objetivo y resolución lo hagan relevante; no añadir pasos obligatorios sin efecto táctico.

La existencia de más botones no garantiza mayor profundidad. Si todas las resonancias son gratuitas y siempre convenientes, usarlas pasa a ser una rutina obligatoria. Necesitamos elecciones entre funciones y entre usar ahora o reservar, mediante costes y/o recargas, sin decidir cantidades todavía.

## Aprendizaje y especialización

Requisito confirmado: el entrenador aprende resonancias y puede desarrollar más de una estrategia. Curador es una función de ejemplo, no un catálogo limitado a repetir curación.

Propuesta para aprobación: distinguir resonancias aprendidas de resonancias equipadas para el combate. El personaje conserva sus aprendizajes, pero prepara una selección antes del encuentro. Cantidad de huecos, método de adquisición y posibilidad de cambiar durante el combate siguen pendientes.

También falta decidir si los tipos de entrenador son especializaciones con acceso a resonancias comunes más ventajas propias, o clases con repertorios exclusivos. No asignar bonificaciones, árboles de habilidad o restricciones por clase sin resolverlo. Ezel todavía no tiene un tipo jugable asignado.

Funciones posibles para revisar, todavía no aprobadas ni registradas salvo Curador:

| Tipo propuesto | Función propuesta |
|---|---|
| Protector | Mitigar daño o proteger al equipo. |
| Potenciador | Mejorar temporalmente capacidades de sus Karmany. |
| Controlador | Dificultar acciones o capacidades del rival. |

Son funciones de diseño, no nuevos personajes ni escuelas canónicas. No asignar afinidades elementales, nombres de poderes, estadísticas o lore sin fuente/aprobación.

## Decisiones que bloquean el combate completo

1. Confirmar número de acciones dentro del turno compartido y libertad de orden; propuesta: una acción de Karmany más una resonancia opcional.
2. Decidir repertorios comunes/especializados o exclusivos por tipo de entrenador, y cómo aprende/prepara resonancias.
3. Definir primer repertorio versátil del entrenador: funciones, objetivos, frecuencia y coste; no limitarlo arbitrariamente a curación.
4. Aprobar fichas de balance de Karmany: valores de estadísticas, daño, técnica e insignia. Los nombres/efectos no se inventan por analogía con Monster Galaxy. Orden de iniciativa y cambio de activo siguen pendientes de confirmación.

Orden práctico recomendado: resolver presupuesto de acciones y modelo de aprendizaje; después presentar reglas y fichas juntas para revisión. Los casos de cambio de criatura, derrota durante un combo y cierre del turno se especificarán antes de programarlos.

Esta actualización cambia solo documentación de diseño. Preview 5 conserva su código; no supone validación física del bloque 03 ni integración de ese bloque a dev/karmany-core.
