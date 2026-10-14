# Turno automático · Preview 0.7.0

El creador validó Preview 14 y reemplazó el orden libre por: resonancia opcional del entrenador primero; habilidad del Karmany después; respuesta automática del rival. Se conserva una acción por propietario y la resonancia sigue siendo opcional. La nueva regla se aplica en feature/automatic-combat-turns desde el baseline validado 0.6.1, integrado por fast-forward.

Toda habilidad del Karmany, incluida Protección, termina la fase del jugador. El turno se cierra en el modelo y no permite una resonancia tardía, segunda habilidad o retirada durante la respuesta pendiente. Si el rival queda derrotado, se pasa directamente al Libro sin respuesta. Las cifras, recargas, progresión, probabilidades y reglas de captura no cambian.

## Resolución y persistencia

La habilidad guarda su resultado y enemy_pending antes de la respuesta. Un Timer único, hijo del autoload App, espera 0,7 segundos para que el último ataque del jugador sea legible y resuelve al rival. No hay coroutines asociadas a páginas que puedan quedar destruidas. Cambiar de pantalla no cancela la respuesta; una señal actualiza combate/mapa cuando se resuelve.

Suspender la aplicación detiene el Timer; reanudar lo programa desde el mismo estado pendiente. La identidad del encuentro y la revisión esperada evitan respuestas obsoletas, dobles toques y daño duplicado. Al confirmar la respuesta, el guardado avanza al siguiente turno o derrota. Una escritura fallida conserva el checkpoint pendiente, muestra error y ofrece Reintentar respuesta en la fila inferior; no aplica daño silenciosamente ni ejecuta un bucle de reintentos.

El esquema del perfil sigue siendo 3 con un campo compatible en el encuentro. Las partidas anteriores que ya gastaron la habilidad y esperaban cierre manual se reconocen por el historial de presupuesto y reciben una sola respuesta automática. Vida, efectos ya aplicados, árbol, colección, activo, recargas y resultados del Libro se conservan. Los encuentros en captura o terminados no programan respuesta.

SharedCombatTurn conserva su contrato genérico de presupuesto, útil para restaurar snapshots antiguos. TrialEncounter aplica el cierre al actuar el Karmany y el orden entrenador primero; combat_structure.json registra la nueva regla. Las pruebas del orden anterior en el juego se adaptan a la decisión nueva sin retirar las verificaciones de presupuesto, cooldowns, daño, guardado y captura.

## Verificación

Las pruebas de botones sin resonancias mantienen sus límites de disposición y completan ahora el combate mediante el Timer, sin un control manual. Las nuevas pruebas comprueban orden, bloqueo, Protección, pausa/reanudación, teardown de UI, errores de escritura/reintento, golpe final, recompensas únicas, migración y callback obsoleto. Las pruebas anteriores de equipo, Libro, árbol y privacidad siguen vigentes. La revisión automática mediante imágenes permanece desactivada.
