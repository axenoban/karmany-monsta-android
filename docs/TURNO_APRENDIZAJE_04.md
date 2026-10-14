# Turno compartido y biblioteca de resonancias

## Reglas aprobadas

- Una acción del Karmany y una resonancia opcional del entrenador, dentro del mismo turno.
- Orden libre entre ambas acciones; el entrenador no tiene un turno separado.
- Resonancias generales aprendibles mediante biblioteca o escuela, sin depender del tipo.
- Resonancias especiales/explosivas vinculadas al tipo y la personalidad del entrenador.

## Contratos implementados

`SharedCombatTurn` reserva y confirma acciones con un cupo por actor. Las dos órdenes funcionan. Una acción invalidada puede cancelar su reserva sin gastar el cupo; doble toque, reserva concurrente, ticket antiguo o resolución duplicada se rechazan. El controlador futuro solo confirma tras aplicar correctamente el efecto. Este módulo no calcula daño, curación, costes ni recargas.

Se conserva el turno únicamente entre acciones resueltas. No se serializa una acción a medio aplicar. El futuro controlador del encuentro deberá resolver efectos y guardar como una transacción coherente; guardar el turno por sí solo no garantiza persistencia de vida, recursos o recompensas. El cierre del turno puede omitir la resonancia opcional y bloquear toda acción posterior.

`ResonanceLearning` separa resonancias generales de especiales/explosivas. Una general configurada puede aprenderse sin tipo o personalidad definidos. Las propias exigen los requisitos configurados de ambos. Conserva la identidad del entrenador y los aprendizajes con snapshot/restore, rechaza duplicados y restauraciones para otra identidad. No concede poderes automáticamente ni define valores o nombres.

Los registros de aprendizaje no están integrados todavía al guardado del jugador. Tampoco hay costes de escuela, compra, equipamiento, árbol de aprendizaje o transformación de personalidad. Los ejemplos de las pruebas son fixtures explícitos, no contenido del juego.

## Canon y ubicación

La enciclopedia aportada describe ostracismo por magia o por mostrar un Libro en Tierras Bajas de Jade. Axe se encuentra aislado en las afueras. Una escuela pública dentro de Valle Jade necesitaría una explicación narrativa aprobada.

Se implementa el proveedor de aprendizaje como sistema, sin añadir un edificio o punto de mapa. Opciones pendientes de decisión: aprendizaje privado con Axe; acceso clandestino; biblioteca/escuela en otra región. No asumir ninguna como canon.

## Contenido necesario para el primer encuentro

1. Tipo y personalidad de Ezel, o documento canónico que los determine.
2. Repertorio inicial de resonancias generales y su resonancia propia; efectos, objetivos, costes y recargas.
3. Especies iniciales y fichas de Vida/Ataque/Defensa/Velocidad, habilidades, daño y recargas.
4. Orden entre bandos, cambio del activo y efectos al derrotar al enemigo antes de terminar el combo.

Estos puntos son decisiones de juego y balance; no se inventan a partir de los fixtures. La interfaz y el APK siguen sin un encuentro jugable hasta disponer de las fichas.

## Pruebas

Suite específica: `godot --headless --path . --script tests/shared_turn_learning_tests.gd`.

Se mantienen además las regresiones de base, catálogo/captura y Libro/entrenadores. Este avance interno no requiere otra prueba manual de pantallas iguales; la validación de Preview 5 continúa pendiente.
