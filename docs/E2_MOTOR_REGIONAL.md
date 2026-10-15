# E2 · Motor regional sobre E1

Base: `1719c6821319279f191734a0d4fbf836e9de428e` (E1).
Responsable escritor: Work. Rama: `feature/e2-regional-engine`.
Estado: implementación técnica; pendiente revisión de Chat/CI remota y prueba física. No integrado a dev.

## Contrato implementado

- Rutas consultables por región configurada, sin registrar ni habilitar Bosque. Se preserva `route.completed` de Jade y los identificadores históricos; el contador global `jade-N` no cambia para mantener partidas anteriores.
- Una entrada con `level`, `first_xp`, `repeat_xp`, `cost` y opcionalmente `enemies` activa el contrato regional. El contrato guarda niveles y enemigos, región, tope, recompensa, repetición y clave de bono antes del combate. Las entradas sin estos campos siguen el comportamiento heredado.
- Bonos `región/punto/v1`, registrados en la misma transacción que la victoria, el recibo de XP, el progreso y el objeto de stamina. Una etapa ya completada antes de E2 permite reclamar el nuevo bono una vez al volver a ganarla. No se asignan recompensas a integrantes históricos desconocidos.
- Equipo enemigo de hasta dos miembros conforme a E1: uno activo; entra la reserva conservando su estado. No se cura al equipo aliado, no se reinician efectos/recargas y no hay golpe gratuito del nuevo enemigo. Se abre el siguiente turno normal. Solo la derrota del último rival concede victoria/XP.
- Al vencer a dos rivales se elige uno: la selección se guarda y queda bloqueada; no consume intento ni genera tiradas. Los tres intentos originales pertenecen al único vínculo. Con un rival la elección es automática.
- Captura regional al nivel encontrado y XP parcial cero. Los encuentros y capturas anteriores mantienen nivel uno y recompensa heredada. Las capturas y niveles existentes no se reinterpretan.
- Resumen de XP con paso por todos los niveles cruzados y cifras de estadísticas correspondientes al nivel mostrado. Ambos modos de movimiento terminan con los valores persistidos.
- El golpe con relevo y bonus temporal de Sakuromushi de E1 permanece intacto; se prueba también cuando ese golpe derrota al primer miembro del equipo enemigo.

## Frontera con E3 y E4

Este bloque NO modifica `data/jade_route.json`: los cuatro puntos jugables continúan con la configuración anterior. La activación de seis etapas, cifras aprobadas, Sakuraneko/Inubari y arte pertenece a E3. No activar una final provisional con otras especies ni publicar fixtures como contenido real.

La selección funcional de vínculo ya existe en la UI. La caída/entrada cinematográfica del rival y el fondo continuo pertenecen a E4. E2 no afirma haber completado la solicitud visual previa.

Los tests usan datos temporales en memoria y especies existentes para ejercitar el motor. Se excluyen del APK. No son reglas nuevas ni una ruta desbloqueable por el jugador.

## Validación reproducible

```bash
godot --headless --editor --path . --import --quit
godot --headless --path . --script tests/regional_engine_tests.gd
godot --headless --path . --script tests/tactical_tests.gd
godot --headless --path . --script tests/experience_summary_tests.gd
python3 -m unittest discover -s tests -p test_apk_privacy.py
```

La suite completa sigue definida en `.github/workflows/android-preview.yml`, con el nuevo test regional incluido. No se modifica ni elimina ningún assert existente.

## Revisión de Chat

Comparar contra E1, no contra Preview32. Revisar validación/normalización del estado, el vencimiento del bonus de relevo al avanzar de ronda, selección irreversible de un solo objetivo, migración sin borrado de completados, y exclusión de los tests del APK. No editar simultáneamente archivos reservados por Work.

## Prueba Android

Instalar la entrega E2 sobre E1/Preview29 sin borrar datos; NO usarla como actualización compatible de Preview30–32/Bosque, una rama divergente que este árbol no importa. conservar equipo, niveles, Libro y progreso. Probar una pelea, la Insignia de Sakuromushi con reserva viva, el contraataque al entrante, guardar/reabrir, captura y regreso al mapa. Probar texto grande y movimiento reducido. El mapa aún muestra cuatro puntos; los contratos nuevos se validan automáticamente hasta su activación en E3.

Siguiente: revisión E2, validación de la actualización y después E3. E1/E2 no se integran a dev sin aprobación física expresa; main permanece reservado para publicación.
