# Bloque19 ampliado · Niveles, experiencia y desbloqueos

Estado: reglas parciales confirmadas por el creador el14/10/2026. Cifras de balance todavía pendientes. No modificar combate/guardado hasta completar decisiones.

## Confirmado por el usuario
- Libros y regiones se desbloquean por nivel del entrenador.
- Karmany con nivel individual; solo integrantes del equipo principal reciben experiencia.
- Valle Jade entrega experiencia únicamente a individuos por debajo de nivel10. Entrenador/Karmany en10 o superior no gana allí; los demás integrantes inferiores siguen siendo elegibles.
- Desbloqueos con puntos del árbol de habilidades.
- Reconocer capturas y niveles existentes.

## Estado real y límites de migración
- Entrenador: skill_tree.level de1 a10; App.trial_action concede un nivel por victoria. No existe XP de entrenador.
- Karmany: identidad por instance_id, equipo hasta3, colección persistente; no hay nivel/XP histórico por individuo.
- Puntos: earned_points=level+bonos por hitos de especies, spent_points=suma de rangos de resonancias. Añadir gastos de desbloqueo exige un registro persistente para no permitir doble compra/reembolso infinito.
- Redistribución actual en laboratorio: devuelve asignaciones de resonancias. Los desbloqueos permanentes deben conservar su coste si se aprueba esta política; falta decisión.
- No se puede reconstruir experiencia histórica individual: no existe registro de participación por victoria. Conservar colección y nivel del entrenador es posible; asignar nivel a criaturas existentes requiere decisión explícita.
- Captura guarda política/probabilidad/intentos/tiradas. Mejora del Libro no debe reinterpretar una sesión activa.
- Solo Valle Jade tiene ruta jugable. Otras regiones necesitan contenido/niveles/condiciones aprobados antes de habilitarlas.

## Propuesta experimental para aprobación (no aplicada)
1. XP:25 para el entrenador y25 para cada Karmany del equipo por victoria; no repartir una bolsa. Requisito para subir:100×nivel actual. Experiencia del derrotado/retirada:0. Tope regional por individuo; al alcanzar10 en Jade se descarta excedente, sin acumularlo para otra región. Mantener puntos/capturas/nivel actual del entrenador y comenzar XP parcial en0.
2. Karmany antiguos y capturas nuevas: empezar nivel1/XP0; estadísticas base aprobadas representan nivel1. Por nivel adicional:+5% de Vida/Ataque/Defensa sobre la base, redondeo al entero más cercano; Velocidad fija. Propuesta de balance nueva que necesita aprobación. Riesgo: afecta duración del combate; simular antes de entregar. Si se prefieren niveles sin escalado temporal, requiere aceptación explícita.
3. Libros: Mejora1 requiere nivel4 y1 punto; Mejora2 nivel8 y2 puntos, secuenciales y comprados fuera de encuentros activos. Probabilidades aprobadas intactas. Redistribuir resonancias no devuelve puntos de libros/regiones; permitir redistribuir resonancias desde pantalla normal con confirmación para evitar bloqueo de jugadores que gastaron todos sus puntos. Estos costes y política de redistribución necesitan aprobación.
4. Regiones: mantener Jade accesible. Primer bloque implementa política configurable de nivel/coste/tope por región y no habilita una región inventada. El creador debe indicar siguiente región canónica y sus requisitos antes de crear contenido jugable.

## Decisión adicional necesaria
Entrenamiento libre: hoy aumenta nivel de entrenador al ganar. El creador debe decidir si seguirá dando XP a entrenador/equipo bajo el mismo tope regional o solo los combates de localización. Recomendación: experiencia solo en localizaciones para que el entrenamiento gratuito no sustituya la exploración; esto cambiaría la recompensa existente y no se aplica sin aprobación.

## División de implementación propuesta
19A: datos/configuración de XP por individuo y elegibilidad regional, migración persistente, recibo único de victoria, barras de nivel/XP y resumen; proteger encuentros legacy y snapshots. Escalado de estadísticas solo con fórmula aprobada.
19B: gasto compartido de puntos, libros por nivel, confirmaciones y acceso regional configurable. Mantener políticas antiguas para sesiones iniciadas y validar que no puedan duplicarse compras/recompensas.

Regresiones requeridas: entrenador10/Karmany inferior, miembro10 sin XP y compañeros sí, criaturas fuera del equipo sin XP, duplicados por instance_id, subida hasta el tope sin excedente, no reotorgar al recargar/capturar, escritura fallida sin gasto/XP, puntos de resonancias/desbloqueos/reset, migración de equipo/colección/niveles y sesiones de captura.
