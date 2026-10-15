# Cifras experimentales para completar el bloque21

Estado: pendiente de aprobación. No incorporadas a data/tactical_combat.json ni al APK. La enciclopedia aporta anatomía/comportamiento/rango; estas magnitudes son propuestas de adaptación jugable, no canon.

Dirección de recorrido aceptada por el creador el15/10/2026: inicio rápido, progreso más lento conforme sube el nivel; seis etapas distintas en Jade/Bosque, enemigos crecientes, final de dos rivales por relevos y capturas que conservan el nivel encontrado. No se solicita de nuevo aprobación de esa dirección.

## Curva ajustada y comprobada

Se mantiene100×nivel como requisito, evitando reinterpretar XP guardada. Se modera el bono de primera victoria en etapas avanzadas; la XP repetible se conserva. No se añade una segunda fórmula global ni se reduce el nivel existente.

| Región | XP de primeras victorias | Salida tras seis etapas | Repeticiones finales hasta el tope | Encuentros ganados totales |
| --- | --- | --- | --- | --- |
| Jade | 400,500,600,650,700,750 | Nv9/XP0 | 3 de300XP | 9 |
| Bosque | 700,750,800,850,900,950 | Nv14/XP350 | 4 de325XP (la última aplica75) | 10 |

Suponen individuo presente en equipo desde inicio de región, Nv1/XP0 oNv10/XP0; las repeticiones son de la final de dos enemigos. Son9/10 encuentros,13/15 rivales individuales respectivamente. Se pueden repetir etapas normales si se prefiere, necesitando más victorias por su menor recompensa. No hay subida automática por escena: en Bosque, la cuarta etapa llena la barra sin subir y el último nivel requiere cuatro victorias adicionales tras la primera pasada. Los niveles de enemigos no se adaptan hacia arriba al nivel del jugador.

Tope individual conservado: entrenador o criatura ya al límite no recibenXP allí; compañeros inferiores sí. Ningún bono anterior para integrantes incorporados después. El requisito al pasar10→11 continúa1000XP, no700: el avance rápido inicial proviene de bonos y etapas, no de falsificar niveles.

## Tabla concreta que falta aprobar

Todas las cifras representan nivel1. Vida/Ataque/Defensa escalan después con el +5% base por nivel ya aprobado; Velocidad10 y efectos/recargas permanecen fijos. Los porcentajes de daño son respecto al ataque básico. Curar y proteger sin daño reutiliza el patrón existente de Tanugami. No se introducen estados nuevos ni iniciativa por Velocidad.

| Especie | Vida | Ataque | Defensa | Velocidad | Insignia experimental | Recarga |
| --- | --- | --- | --- | --- | --- | --- |
| Sakuraneko | 72 | 20 | 7 | 10 | Cura10 de Vida y protección20%, sin daño | 3 |
| Inubari | 84 | 18 | 11 | 10 | Daño110% y protección propia30% | 2 |
| Suzumeko | 64 | 23 | 5 | 10 | Daño125% y reduce20% el próximo daño del rival | 2 |
| Kodamashi | 84 | 17 | 10 | 10 | Cura14 de Vida y protección20%, sin daño | 3 |
| Mujina-Kage | 76 | 20 | 8 | 10 | Daño110% y reduce30% el próximo daño del rival | 2 |
| Tsukimi-Usagi | 72 | 18 | 8 | 10 | Daño100% y potencia30% el próximo golpe del compañero elegido | 2 |
| Kodama-Shin | 80 | 18 | 10 | 10 | Cura10 de Vida y protección25%, sin daño | 3 |
| Karasu-Origami | 68 | 23 | 6 | 10 | Daño130% | 2 |

Semántica de recarga: usar el mismo mecanismo de ready del juego, no crear un temporizador alternativo. Protección/reducción se consumen con el próximo ataque, sin acumulación aditiva nueva. Apoyo de Tsukimi usa el selector de compañero existente, como Sakuromushi.

## Cribado exploratorio ejecutado

`python3 docs/proposals/simulate_combat_21.py`:160 duelos aproximados a niveles1/8/10/15,143 victorias y17 derrotas de los cinco aliados existentes contra candidatos,0 inconclusos,4–22 turnos. El jugador actúa primero y usa política fija; esto sesga resultados, no son probabilidades de victoria ni balance validado.

Final Jade, equipo Zephyr/Ushigane/Kitsunibi Nv8 contra Inubari/Ushigane Nv10: victoria21 turnos,61 Vida total restante. Final Bosque, mismo equipo Nv13 contra Karasu-Origami/Mujina-Kage Nv15: victoria13 turnos,157 Vida total restante. Sin curación automática entre rivales, cambio solo al caer el activo. Esta aproximación Python no sustituye pruebas Godot con resonancias, equipos mixtos y decisiones distintas. No publicar como «combate probado».

## Recomendaciones pendientes adicionales, dentro del bloque

- Stamina10 en cada una de cinco etapas normales y30 en final (80 por recorrido). Requiere reasignar el coste del antiguo punto4 de Jade. Incluirlo en aprobación del paquete.
- Migración: no borrar completados ni adivinar participantes históricos. Recomiendo que una etapa ya completada permita reclamar el bono de la nueva curva una sola vez al volver a ganarla, con el equipo presente en esa victoria. Marcar región/etapa/versión de bono atómicamente. Encuentros antiguos activos terminan con sus reglas congeladas; nunca cambiar una captura o recompensa pendiente a mitad. Este ajuste económico debe aprobarse junto con la tabla.
- Final: un vínculo elegido entre derrotados y tres intentos compartidos para esa elección, sin nueva captura de la reserva por defecto. Mantener política del Libro congelada al entrar; no crear tiradas al elegir ni al recargar. Resolver ruta/recompensa una sola vez después del equipo completo.

## Paso de implementación

Tras aprobar esta tabla y esas políticas concretas, implementar motor regional/XP por etapa y bonos, enemigos por relevo, captura a nivel encontrado, migración y animación de múltiples subidas; después integrar ocho especies con arte original, escenarios y mapas de seis puntos. Ejecutar pruebas Godot reales y CI antes de entregar APK. main y el baseline jugable dev continúan en Preview29 mientras falte esa aprobación.
