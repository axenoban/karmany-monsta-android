# Decisiones aprobadas y propuesta de entrenadores

Actualización: 14 de octubre de 2026. El creador aprobó Preview 4 y pidió aplicar las sugerencias 1 y 3; aclaró que las resonancias son habilidades del entrenador.

## Aprobado

- Equipo de hasta tres Karmany, uno activo por bando.
- Vida, Ataque, Defensa y Velocidad; valores por especie todavía pendientes.
- Tres habilidades iniciales por especie, incluida una insignia; efectos y valores todavía pendientes.
- Las resonancias son habilidades del entrenador. Habrá distintos tipos de entrenador, con distintas funciones.
- Tipo Curador: sus resonancias curan a sus Karmany. Todavía sin nombres, cantidades, recursos, recargas o selección de objetivos definidos.
- Tabla del Libro: Inicial Común 45%; Mejora 1 Común 60%/Raro 30%; Mejora 2 Común 75%/Raro 45%/Épico 20%. Cada cifra es por intento. Las rarezas no incluidas están bloqueadas.
- Tres intentos después de derrotar a un Karmany elegible; escape al agotar intentos y posibilidad de otro encuentro.

Las descripciones de resonancia lumínica/sombría de la enciclopedia son referencias ecológicas y narrativas. No se borran ni se convierten automáticamente en habilidades activables de una criatura. Las habilidades de Karmany y del entrenador deben tener catálogos independientes.

## Implementación de este bloque

Datos de Libro separados de lógica de captura, validación de mejoras que no reduzcan acceso/probabilidad, configuración de estructura, equipo con identidad individual y único activo, y registro de tipos de entrenador ampliable. Solo Curador está registrado; no se asigna un tipo a Ezel o Axe. El curador tiene habilidades vacías de forma explícita hasta definirlas.

Las pantallas del Libro y Entrenadores consultan esas reglas reales. No permiten comprar mejoras ni conceden un entrenador o Karmany inicial. Motor, firma, paquete y guardado aprobado se conservan.

## Propuesta de funcionamiento para decidir

Recomendación: durante el turno del jugador se elige entre una habilidad del Karmany, cambiar de criatura o usar una resonancia del entrenador. La resonancia reemplaza la acción del Karmany en ese turno. Así, curar compite con atacar y no concede una segunda acción gratuita. La recarga o coste de canalización necesita una ficha aprobada antes de implementarse.

Alternativa: el entrenador tiene una intervención independiente además del Karmany. Ofrece más acciones por turno, pero exige limitar su frecuencia o recurso para que curar/proteger no sea siempre una acción adicional sin decisión táctica. Aumenta la complejidad del primer combate y de la IA.

Para el primer prototipo propongo trabajar solo con Curador. Otros tipos posibles para revisar después, todavía no aprobados ni registrados:

| Tipo propuesto | Función propuesta |
|---|---|
| Protector | Mitigar daño o proteger al equipo. |
| Potenciador | Mejorar temporalmente capacidades de sus Karmany. |
| Controlador | Dificultar acciones o capacidades del rival. |

Son funciones de diseño, no nuevos personajes ni escuelas canónicas. No asignar afinidades elementales, nombres de poderes, estadísticas o lore sin fuente/aprobación.

## Decisiones que bloquean el combate completo

1. ¿Resonancia reemplaza la acción del Karmany o funciona como intervención adicional?
2. ¿Comenzamos el prototipo con Ezel como Curador, o quieres elegir otro enfoque para él? La enciclopedia no determina una clase jugable para Ezel.
3. Definir ficha del Curador: número de habilidades, objetivo permitido, curación, frecuencia y coste.
4. Aprobar fichas de balance de Karmany: valores de estadísticas, daño, técnica e insignia. Los nombres/efectos no se inventan por analogía con Monster Galaxy.

Orden práctico recomendado: resolver 1 y 2; después presentar fichas concretas para revisar de una vez, antes de programar el encuentro.
