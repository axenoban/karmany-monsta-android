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
Preview27,0.15.0/versionCode1027,código413ab07813724cf4bd68e562c6fb0fc81e3cbefc, documentación10e3886. Usuario confirmó «ok pruebas correctas» el14/10/2026. Integrado por fast-forward en dev desdea62ecb3 a10e3886; PR14 cerrada. CI38655224968:1174 Godot y3 Python, exportación/firma/auditoría correctas. main conserva su estado.

Historial: docs/BASELINE_VALIDADO.md. Movimiento reducido opcional/desactivado de inicio, normalización compatible, misma duración/audio y resultados. Audio22 efectos originales con volumen/silencio persistentes. Reglas y guardados de bloques anteriores aprobados.

## Bloque19: niveles, XP y Libro · implementación autorizada
Aprobación del creador14/10/2026: «es correcto, aplica esto a al proyecto». Leer docs/PROPUESTA_PROGRESION_19.md y docs/NIVELES_LIBRO_19.md. Rama feature/level-progression, base cb98974, versión0.16.0.

Reglas aprobadas e implementadas:25XP por victoria de localización al entrenador y a cada integrante del equipo, sin repartir;100×nivel actual para subir. Jade deja de darXP a cada individuo desde10, los inferiores siguen ganando y el excedente al llegar al límite se descarta. Entrenamiento libre/derrota/retirada sinXP. Capturas y nivel del entrenador anteriores conservados; XP parcial previa inexistente se inicia en0 y Karmany antiguos/nuevos en1. +5%Vida/Ataque/Defensa por nivel sobre base con redondeo; Velocidad y técnicas intactas.

Libro secuencial: Mejora1 Nv4/coste1punto; Mejora2 Nv8/coste2puntos, probabilidades ya aprobadas45/60/75%Común y rarezas de tabla original. Puntos compartidos con resonancias y gastos permanentes registrados en skill_tree.unlocks; redistribuir devuelve solo resonancias. Compras/reset normal fuera de encuentros activos. Encuentros nuevos congelan niveles y book_id; sesiones viejas mantienen política inicial y cifras hasta terminar.

Regiones configuradas en data/level_progression.json: Jade accesible Nv1/coste0/topeXP10. Regla de acceso/gasto preparada para futuras regiones configuradas; no se añadió una región ni un enemigo/encuentro sin canon aprobado. Entrenador sigue con el máximo actual10 hasta aprobar la siguiente región/progresión.

Persistencia: schema3 compatible con campos opcionales; campaign.progression contiene trainer_xp, units por instance_id y last_reward de victoria. Recibo, nivel/XP, puntos, ruta y recompensa se guardan juntos. Capturar no repiteXP; criaturas fuera del equipo no reciben. Escritura fallida no concedeXP ni consume puntos. Guardado JSON con máxima precisión de números; las pruebas comprueban los mismos resultados de las tiradas al recargar. Se normalizan perfiles de forma idéntica en memoria/disco para conservar enteros y migraciones.

Validación local:1348 comprobaciones Godot,174 nuevas de progresión, y3 Python correctas. Simulados combates a niveles1/5/10 contra cuatro rivales y revisadas pantallas normal/grande de Equipo, Libro, mapa, árbol, combate escalado y resumen deXP. CI38664822086 correcta:1348 Godot y3 Python, exportación/firma v2/v3/auditoría aprobadas. Código df4414419ec3012e514de5e5f59c9433c3d0fe88. APK0.16.0/versionCode1028: [Preview28](https://github.com/axenoban/karmany-monsta-android/releases/download/android-preview-28/karmany-monsta-preview.apk). [PR15](https://github.com/axenoban/karmany-monsta-android/pull/15). El commit posterior de documentación no cambia el APK. Pendiente validación física del creador. Prueba física docs/PRUEBA_ANDROID_19.md.

## Si las pruebas son correctas
Registrar aprobación e integrar esta rama por fast-forward en dev. Después, definir con el creador la siguiente región canónica: nombre/fuente, nivel de acceso, coste de puntos, tope deXP, especies/encuentros y niveles rivales. No inventar región, elevar el máximo del entrenador ni añadir rarezas jugables por disponer de probabilidades del Libro. Si se prioriza balance, medir duración de combates y ritmo deXP antes de proponer cambios numéricos para aprobación.

## Protocolo al terminar cada actualización
Actualizar bloque actual, estado probado y pendiente, rama y referencias verificadas, enlace de entrega cuando exista, riesgos reales y siguiente paso tras aprobación. Distinguir siempre CI/local de validación en dispositivo. Usar git log como referencia de commit cuando el documento forma parte del mismo commit, evitando autorreferencias imposibles.
