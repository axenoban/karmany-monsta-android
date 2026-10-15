# Bloque19 · Niveles, XP, límite regional y Libro

Aprobado por el creador14/10/2026. Parámetros en data/level_progression.json, tablas de captura aprobadas en data/book_levels.json. No se modifica la naturaleza canónica de las especies ni sus técnicas.

## Modelo y migración
level_progression.gd mantiene trainer_xp y progreso individual por instance_id. Conserva nivel del entrenador y colección; incorpora XP0 y criaturas Nv1 sin simular experiencia histórica. El perfil sigue en schema3 con campos compatibles. SaveStore valida negativos, fracciones, IDs desconocidos y XP pendiente de resolver; la normalización ocurre tras validación y antes de guardar, sin tocar el perfil visible ante fallo. JSON se escribe con máxima precisión.

25XP por victoria en localización para cada elegible del equipo y entrenador. Requisito100×nivel actual. Jade tiene tope10 por individuo; si un compañero ya está en10, el resto inferior sigue ganando. Al alcanzar el límite se consume soloXP hasta10 y se descarta excedente; el recibo informa la cantidad aplicada. Todos los miembros del equipo del encuentro cuentan, incluida una reserva derrotada; colección fuera del equipo no cuenta. Entrenamiento no daXP. No se cambia stamina ni objetos.

La transición de batalla a captura guarda XP, progreso de ruta y recompensa en una transacción. El recibo por encuentro y la fase/revisión evitan duplicación. Captura, reabrir menús y recargar no conceden otra recompensa. Nuevas capturas empiezanNv1/XP0 y no reciben la victoria que las originó.

## Estadísticas y sesiones
combat_catalog.stats_at_level escala Vida/Ataque/Defensa sobre base por1+0.05×(nivel-1), roundi; Velocidad y técnicas/recargas conservadas. Los encuentros schema2 nuevos incluyen nivel por unidad y book_id, sin nueva versión de encuentro. Validación, daño, máximo de curación, barras y lectura detallada usan esos niveles congelados. Las unidades de sesiones viejas sin nivel equivalen al nivel1/base; mejorar el progreso no las reescribe a mitad de batalla.

## Gastos compartidos y Libro
skill_tree.unlocks conserva adquisiciones permanentes; spent_points suma sus costes y rangos de resonancias. Requisitos y orden se validan, sin compras repetidas ni saldos negativos. Redistribuir limpia rangos/equipadas y conserva unlocks. Compras de Libro y redistribución normal bloqueadas en batalla/reemplazo/captura; se confirman desde UI.

Libro inicial45%; Mejora1 nivel4/1punto60%; Mejora2 nivel8/2puntos75% paraComún. Acceso y probabilidades Raro/Épico siguen su tabla aprobada, sin nuevos rivales de esas rarezas. Política se fija al iniciar encuentro; sesiones antiguas conservan45% y sus intentos/tiradas al restaurar. UI usa la probabilidad real de la captura, no una etiqueta fija.

## Regiones e interfaz
progression_rules.gd resuelve nivel, coste, desbloqueo y tope por región configurada. Jade está abierta desdeNv1 y tiene tope10. No hay siguiente región jugable configurada; su identidad y contenido necesitan aprobación. Entrenador conserva máximo actual10.

Mapa muestra nivel/XP del entrenador y tope. Equipo/Colección muestran nivel, experiencia, barra en equipo y cifras escaladas; combate y detalles usan cifras del encuentro. Resumen de victoria compacto conserva acceso a vínculo/continuar. Libro muestra equipado/adquirido/disponible/bloqueado, requisitos, puntos y confirmación de compra. Redistribución accesible fuera del laboratorio con confirmación.

## Verificación
174 comprobaciones nuevas: migración, datos inválidos, XP y topes, duplicados, bajas/reservas, equipo/colección, filas de recompensa, fallos de escritura, doble acción, compras/orden/costes, redistribución, política histórica y real45/60/75, daño/curación y simulaciones. Regresiones previas mantienen todas sus aserciones salvo recompensa antigua de entrenamiento: se actualiza a victoria conservada sin nivel/XP, según la decisión explícita del creador.
