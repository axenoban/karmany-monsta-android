# Combate táctico · Preview 0.8.0

Propuesta del 14 de octubre aprobada por el creador para ensayo. Pendiente de validación física; no integra dev/karmany-core. Baseline: 67d006d; propuesta: d4fc1cd.

Se recuperó el trabajo local interrumpido: tres PNG con alfa real y sus prompts, catálogo experimental, motor táctico y conexiones de campaña. Se completaron interfaz, animaciones, regresiones y compilación CI. Las fichas numéricas se mantienen según PROPUESTA_COMBATE_TACTICO_10.md y data/tactical_combat.json; no se presentan como canon definitivo.

## Comportamiento

Entrenamiento abre selector de Tanugami, Ushigane, Kitsunibi o Sakuromushi. Cada rival usa su ficha, insignia y recarga; Tanugami se cura solo si faltan al menos 12 de Vida. Zephyr sigue como inicial. Capturar entrega la especie derrotada una sola vez y conserva identidades, equipo máximo de tres y progreso del árbol.

El cambio voluntario exige confirmación y consume la acción del Karmany: responde el rival contra el nuevo activo. Cada individuo conserva Vida, efectos y recargas dentro del encuentro. Si cae el activo, se guarda la elección de reemplazo; elegirlo abre el siguiente turno sin ataque extra. El equipo no se puede reorganizar durante batalla, reemplazo o captura. Al comenzar otro ensayo se recupera la Vida.

Sakuromushi solicita beneficiario vivo antes de confirmar la insignia, incluyendo reservas y sí mismo. Los efectos simultáneos se aplican tras el daño; fuentes repetidas conservan el porcentaje mayor. La colección muestra las cifras y descripción experimental de cada insignia. Velocidad permanece sin función de iniciativa.

## Persistencia y presentación

EncounterRouter mantiene encuentros schema 1 con el motor anterior, incluso sus respuestas pendientes. Solo los encuentros nuevos usan schema 2. El perfil conserva schema 3; SaveStore valida antes de escribir, conserva respaldo y publica el estado en memoria tras una escritura correcta. No se recalculan recompensas ni se agregan reservas a encuentros antiguos.

Las animaciones son transformaciones 2D del recorte completo, sin rig esquelético: carga de Ushigane, salto de Kitsunibi, embestida corta de Sakuromushi, vuelo corto de Zephyr y balanceo de Tanugami. Cada insignia tiene trayectoria o secuencia propia y efecto visual distinto: ondas, halo de recuperación, anillo de bronce, luces orbitales o partículas de apoyo. Son efectos de presentación sin reglas adicionales. Duran 0,62 s, dentro de los 0,7 s ya existentes antes de la respuesta. El nodo detiene su proceso al terminar; destruirlo no deja coroutines ni decide daño. La revisión mediante imágenes sigue desactivada.

## Verificación

Las regresiones previas de encuentro/UI usan una fixture explícita schema 1 para proteger los encuentros guardados de Preview 15, sin cambiar sus aserciones de daño ni recarga. Las nuevas pruebas tácticas cubren especies, daño, efectos por individuo, duplicados, recargas, curación, cambio, reemplazo, derrota total, captura, guardado JSON, fallo de escritura, pausa, reanudación, migración legacy y botones reales con texto normal/grande. La CI ejecuta ambos conjuntos antes de exportar un APK con el mismo paquete y firma pública de pruebas.
