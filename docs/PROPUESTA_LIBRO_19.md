# Propuesta19 · Progresión del Libro (pendiente de aprobación)

## Fuente verificada
- data/book_levels.json y docs/DECISIONES_ENTRENADORES_03.md: probabilidades por intento aprobadas.
- Inicial: Común45%; Mejora1: Común60% y Raro30%; Mejora2: Común75%, Raro45%, Épico20%. Tres intentos sin cambios.
- Progreso actual: nivel entrenador hasta10; colección con capturas reales de Tanugami/Ushigane/Kitsunibi/Sakuromushi. Zephyr inicial se concede, no se captura.
- La pantalla del Libro solo consulta; captura y validadores usan actualmente la política inicial. Las sesiones guardan policy_id/chance/acciones/tiradas: no deben reinterpretarse con un Libro mejorado.

## Decisiones para el creador
1. Requisito de progresión (cifras experimentales propuestas, no canon):
   A. Mejora1 con2 especies capturadas distintas; Mejora2 con4. Recomendado para premiar exploración y colección; duplicados y Zephyr inicial no cuentan. Riesgo: el vínculo aleatorio puede retrasar el desbloqueo; repeticiones ya están disponibles.
   B. Mejora1 en nivel4 del entrenador; Mejora2 en nivel8. Reduce dependencia del azar, pero permite progresar repitiendo combates.
2. Adquisición:
   A. Reclamar gratis en pantalla del Libro al cumplir requisitos. Recomendado; confirmación explícita y sin nueva economía.
   B. Mejorar automáticamente y gratis al cumplir requisitos. Menos pasos, menor elección explícita.
   C. Gastar un recurso. Requiere definir recurso, obtención y costes antes de implementar; no usar puntos del árbol ni stamina sin aprobación.
3. Partidas existentes:
   A. Contar capturas/niveles ya guardados. Recomendado; respeta progreso.
   B. Contar solo avances posteriores, conservando colección y nivel previos. Exige contador/fecha inicial de la nueva progresión.

## Alcance técnico recomendado
- Mejoras secuenciales; aplicar fuera de encuentros activos. Un encuentro conserva su política desde su creación y no recibe una mejora a mitad de captura.
- Mostrar Libro actual, probabilidades reales, progreso/requisitos y acción de reclamar si corresponde; guardar adquisición una sola vez.
- Mantener tablas aprobadas; rarezas superiores necesitan sus propios encuentros y fichas en fases posteriores.
- Migrar perfiles sin pérdida. Respetar sesiones legacy/schema2, intentos ya usados, tiradas y resultados persistidos.
- Verificar normal/reducido, audio, captura, duplicados, retroactividad y fallos de escritura.

## Estado
Cuestionario preparado. Esperar respuestas1/2/3 antes de implementar balance o economía. Si se eligeC, preparar otra propuesta concreta de costes para aprobación.
