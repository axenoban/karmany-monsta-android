# Continuidad de Karmany Monsta

## Lectura inicial obligatoria
Leer este documento antes de cada proceso; `AGENTS.md` en la raíz establece esta instrucción para agentes compatibles. No depende del historial del chat. Un agente debe confirmar el estado real con git/CI y leer el código afectado; el documento no sustituye esa verificación.

## Proyecto y contrato
- Repositorio: axenoban/karmany-monsta-android. Godot 4.7.2, Android.
- main: publicación. dev/karmany-core: base validada. feature/*: mejoras pendientes.
- No force push, no pérdida de guardados, no cambios de reglas o canon sin aprobación.
- Cinco especies: Zephyr, Tanugami, Ushigane, Kitsunibi, Sakuromushi; personajes Ezel y Axe.
- Stamina 100; entradas 10/10/10/30; recuperación 1/minuto offline; objeto +30 limitado al máximo, 20% por victoria en localización, no entrenamiento.
- Cuatro lugares desbloqueados por victoria; captura opcional. Consultar ficha no gasta, retomar no cobra otra vez.
- Turno: resonancia opcional, habilidad/cambio, respuesta automática rival. Reemplazo por derrota sin ataque extra.
- Conservar anatomía y arte aprobado; los nombres de terreno son descriptivos, no canon nuevo.
- Libro: nivel4/coste1 y nivel8/coste2 aprobados para este bloque; no inventar mejoras adicionales.

## Última base aprobada
Preview29,0.17.0/versionCode1029, código a3d5dfffb93dd00242004295dd853f077875ec1a, documentación d6e960ab4bb480879ba2201f73113649f17a053c. Usuario confirmó «pruebas correctas, procede con la siguiente etapa» el14/10/2026 (America/La_Paz). Incluye progresión/Libro del bloque19 y resumen del bloque20. Integración por fast-forward en dev desde cb98974 a d6e960a verificada. CI38666473622 correcta:1390 Godot y3 Python, exportación/firma v2/v3/auditoría aprobadas. main conserva9ef7af778ee59a47f62bdfbfd5eb0786ce787213.

Historial: docs/BASELINE_VALIDADO.md. Movimiento reducido opcional/desactivado de inicio, normalización compatible, misma duración/audio y resultados. Audio22 efectos originales con volumen/silencio persistentes. Reglas y guardados de bloques anteriores aprobados.

## Bloque19: niveles, XP y Libro · implementación autorizada
Aprobación del creador14/10/2026: «es correcto, aplica esto a al proyecto». Leer docs/PROPUESTA_PROGRESION_19.md y docs/NIVELES_LIBRO_19.md. Rama feature/level-progression, base cb98974, versión0.16.0.

Reglas aprobadas e implementadas:25XP por victoria de localización al entrenador y a cada integrante del equipo, sin repartir;100×nivel actual para subir. Jade deja de darXP a cada individuo desde10, los inferiores siguen ganando y el excedente al llegar al límite se descarta. Entrenamiento libre/derrota/retirada sinXP. Capturas y nivel del entrenador anteriores conservados; XP parcial previa inexistente se inicia en0 y Karmany antiguos/nuevos en1. +5%Vida/Ataque/Defensa por nivel sobre base con redondeo; Velocidad y técnicas intactas.

Libro secuencial: Mejora1 Nv4/coste1punto; Mejora2 Nv8/coste2puntos, probabilidades ya aprobadas45/60/75%Común y rarezas de tabla original. Puntos compartidos con resonancias y gastos permanentes registrados en skill_tree.unlocks; redistribuir devuelve solo resonancias. Compras/reset normal fuera de encuentros activos. Encuentros nuevos congelan niveles y book_id; sesiones viejas mantienen política inicial y cifras hasta terminar.

Regiones configuradas en data/level_progression.json: Jade accesible Nv1/coste0/topeXP10. Regla de acceso/gasto preparada para futuras regiones configuradas; no se añadió una región ni un enemigo/encuentro sin canon aprobado. Entrenador sigue con el máximo actual10 hasta aprobar la siguiente región/progresión.

Persistencia: schema3 compatible con campos opcionales; campaign.progression contiene trainer_xp, units por instance_id y last_reward de victoria. Recibo, nivel/XP, puntos, ruta y recompensa se guardan juntos. Capturar no repiteXP; criaturas fuera del equipo no reciben. Escritura fallida no concedeXP ni consume puntos. Guardado JSON con máxima precisión de números; las pruebas comprueban los mismos resultados de las tiradas al recargar. Se normalizan perfiles de forma idéntica en memoria/disco para conservar enteros y migraciones.

Validación local:1348 comprobaciones Godot,174 nuevas de progresión, y3 Python correctas. Simulados combates a niveles1/5/10 contra cuatro rivales y revisadas pantallas normal/grande de Equipo, Libro, mapa, árbol, combate escalado y resumen deXP. CI38664822086 correcta:1348 Godot y3 Python, exportación/firma v2/v3/auditoría aprobadas. Código df4414419ec3012e514de5e5f59c9433c3d0fe88. APK0.16.0/versionCode1028: [Preview28](https://github.com/axenoban/karmany-monsta-android/releases/download/android-preview-28/karmany-monsta-preview.apk). [PR15](https://github.com/axenoban/karmany-monsta-android/pull/15). El commit posterior de documentación no cambia el APK. Validación confirmada por el creador sobre Preview29, que incluye este bloque. Prueba física docs/PRUEBA_ANDROID_19.md.

## Cierre y continuación
Aprobación e integración de bloques19/20 registradas. Ahora definir con el creador la siguiente región canónica: nombre/fuente, nivel de acceso, coste de puntos, tope deXP, especies/encuentros y niveles rivales. No inventar región, elevar el máximo del entrenador ni añadir rarezas jugables por disponer de probabilidades del Libro. Si se prioriza balance, medir duración de combates y ritmo deXP antes de proponer cambios numéricos para aprobación.

## Protocolo al terminar cada actualización
Actualizar bloque actual, estado probado y pendiente, rama y referencias verificadas, enlace de entrega cuando exista, riesgos reales y siguiente paso tras aprobación. Distinguir siempre CI/local de validación en dispositivo. Usar git log como referencia de commit cuando el documento forma parte del mismo commit, evitando autorreferencias imposibles.

## Bloque20: ventana de experiencia · solicitud actual
El creador pidió continuar y añadir una ventana con XP adquirida, barra que se llena y actualización de estadísticas al subir. Rama feature/experience-summary, parte de fcb5c28 (bloque19); versión0.17.0. Al implementarse no se supuso validación física de Preview28. Ahora el creador aprobó Preview29, que incorpora ambos bloques, y se integraron en dev por fast-forward; main no cambia.

Leer docs/PRUEBA_ANDROID_20.md y docs/NIVELES_LIBRO_19.md. experience_summary.gd presenta un recibo de solo lectura tras la victoria de localización: entrenador y equipo principal, retratos, XP aplicada, barra desde el valor anterior, pausa al completar, nivel nuevo y sobrante. Al subir muestra Vida/Ataque/Defensa antes→después con incremento y Velocidad sin cambios. Límite regional usa barra completa y etiqueta explícita. Sin nuevas reglas de XP, economía, especies o regiones.

El recibo incorpora before/after de nivel/XP y especie por integrante dentro de la misma transacción de victoria. Campos opcionales validados/normalizados; recibos de Preview28 siguen compatibles. Una marca temporal en App habilita la ventana solo después de guardar correctamente y se consume una sola vez. Recargar no vuelve a presentar una recompensa nueva; el resumen compacto sigue en la pantalla. La animación no escribe progreso y cerrarla antes de terminar conserva todo lo ganado.

Ventana modal con desplazamiento y Continuar siempre accesible. Atrás de Android cierra el resumen manteniendo el vínculo. Movimiento reducido muestra el resultado inmediatamente; modo normal anima2.4s y reutiliza un aviso sonoro existente al subir, respetando volumen/silencio. Audio y presentación pertenecen a la escena y se detienen al cerrarla. Sin XP/ventana en entrenamiento.

Validación local:1390 comprobaciones Godot (41 nuevas del resumen y una adicional del flujo Jade),3 Python; importación y git diff --check correctos. Revisión visual1280×720 con equipo de3, subida múltiple entre integrantes, límite regional, texto normal/grande, principio/final del desplazamiento. CI38666473622 completada correctamente:1390 Godot y3 Python; exportación, firma v2/v3 y auditoría de privacidad correctas. Código a3d5dfffb93dd00242004295dd853f077875ec1a. APK0.17.0/versionCode1029: [Preview29](https://github.com/axenoban/karmany-monsta-android/releases/download/android-preview-29/karmany-monsta-preview.apk). [PR16](https://github.com/axenoban/karmany-monsta-android/pull/16), borrador hacia dev, incluye el bloque19/PR15, también aprobado ahora. La documentación posterior no modifica el APK. Prueba confirmada por el creador el14/10/2026; ambos bloques integrados en dev.

Aprobación conjunta e integración de progresión/resumen completadas. Continuar definiendo la siguiente región con el creador (nombre/fuente, nivel de acceso, puntos, topeXP, especies/encuentros y niveles). No inventar contenido ni elevar el máximo actual10 sin esas decisiones.

## Bloque21: siguiente región · decisiones pendientes
Leer docs/PROPUESTA_REGION_21.md. Preparación basada en la Enciclopedia Oficial de Shisai, revisada directamente (páginas2 y8–9) el14/10/2026. Bosque del Velo es candidato recomendado por su conexión cartográfica con Valle Jade, no una región ya autorizada para implementar. Tres comunes propuestos: Suzumeko, Kodamashi y Mujina-Kage; fisiología canónica disponible, cifras/técnicas jugables no definidas.

Propuesta para decidir: acceso entrenador10/coste1punto/topeXP15 y100XP por victoria solo en Bosque (Jade mantiene25XP/tope10; requisito100×nivel intacto); preparar una propuesta experimental de estadísticas/técnicas para esas tres especies antes de programarla. Ni estos valores ni la selección están aprobados todavía. Falta fijar niveles rivales, nivel al vincular, número/orden de puntos y stamina. No ampliar level_cap del entrenador ni producir una región jugable hasta aprobar reglas completas. No importar mecánicas de las resonancias narrativas automáticamente.

Cierre actual: integración y revisión de historia/CI verificadas; actualización exclusivamente documental, sin nuevo APK ni necesidad de repetir pruebas de código. Siguiente acción: obtener decisiones de región/progresión/selección; después preparar tabla de combate y recorrido completos para aprobación. Tras esa aprobación, abrir feature/* e implementar el bloque regional con regresiones de guardados, puntos, XP, captura, navegación y combate.
