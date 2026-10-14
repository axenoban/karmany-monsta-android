# Turno compartido y aprendizaje de resonancias

> El proveedor biblioteca/escuela se reemplazó por el árbol a petición del usuario. Las decisiones actuales de aprendizaje, mejoras y equipamiento están en [Árbol de resonancias](ARBOL_RESONANCIAS_05.md). Este documento conserva el alcance del contrato de turno del avance anterior.

## Reglas aprobadas

- Una acción del Karmany y una resonancia opcional del entrenador, dentro del mismo turno.
- Orden libre entre ambas acciones; el entrenador no tiene un turno separado.
- Resonancias generales aprendibles mediante biblioteca o escuela, sin depender del tipo.
- Resonancias especiales/explosivas vinculadas al tipo y la personalidad del entrenador.

## Contratos implementados

`SharedCombatTurn` reserva y confirma acciones con un cupo por actor. Las dos órdenes funcionan. Una acción invalidada puede cancelar su reserva sin gastar el cupo; doble toque, reserva concurrente, ticket antiguo o resolución duplicada se rechazan. El controlador futuro solo confirma tras aplicar correctamente el efecto. Este módulo no calcula daño, curación, costes ni recargas.

Se conserva el turno únicamente entre acciones resueltas. No se serializa una acción a medio aplicar. El futuro controlador del encuentro deberá resolver efectos y guardar como una transacción coherente; guardar el turno por sí solo no garantiza persistencia de vida, recursos o recompensas. El cierre del turno puede omitir la resonancia opcional y bloquear toda acción posterior.

`ResonanceLearning` separa resonancias generales de especiales/explosivas. Una general configurada puede aprenderse sin tipo o personalidad definidos. Las propias exigen los requisitos configurados de ambos. Conserva la identidad del entrenador y los aprendizajes con snapshot/restore, rechaza duplicados y restauraciones para otra identidad. No concede poderes automáticamente ni define valores o nombres.

En este contrato anterior, los registros de aprendizaje eran independientes del guardado del jugador. Ahora TrainerSkillTree gestiona los rangos aprendidos y el equipamiento persistente, con costes y requisitos descritos en ARBOL_RESONANCIAS_05.md. Las definiciones de efectos del contrato continúan como fixtures de pruebas.

## Canon y ubicación

La enciclopedia aportada describe ostracismo por magia o por mostrar un Libro en Tierras Bajas de Jade. Axe se encuentra aislado en las afueras. Una escuela pública dentro de Valle Jade necesitaría una explicación narrativa aprobada.

El usuario reemplazó el edificio por un árbol de habilidades. No se añade ninguna escuela ni biblioteca al mapa.

## Contenido necesario para el primer encuentro

1. Tipo y personalidad de Ezel, o documento canónico que los determine.
2. Repertorio inicial de resonancias generales y su resonancia propia; efectos, objetivos, costes y recargas.
3. Especies iniciales y fichas de Vida/Ataque/Defensa/Velocidad, habilidades, daño y recargas.
4. Orden entre bandos, cambio del activo y efectos al derrotar al enemigo antes de terminar el combo.

Estos puntos son decisiones de juego y balance; no se inventan a partir de los fixtures. La interfaz y el APK siguen sin un encuentro jugable hasta disponer de las fichas.

## Pruebas

Suite específica: `godot --headless --path . --script tests/shared_turn_learning_tests.gd`.

Se mantienen además las regresiones de base, catálogo/captura y Libro/entrenadores. Este avance interno no requiere otra prueba manual de pantallas iguales; la validación de Preview 5 continúa pendiente.
