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
- Libro: no inventar costes/desbloqueos de mejoras; requieren decisión del creador.

## Última base aprobada
Preview27,0.15.0/versionCode1027,código413ab07813724cf4bd68e562c6fb0fc81e3cbefc, documentación10e3886. Usuario confirmó «ok pruebas correctas» el14/10/2026. Integrado por fast-forward en dev desdea62ecb3 a10e3886; PR14 cerrada. CI38655224968:1174 Godot y3 Python, exportación/firma/auditoría correctas. main conserva su estado.

Historial: docs/BASELINE_VALIDADO.md. Movimiento reducido opcional/desactivado de inicio, normalización compatible, misma duración/audio y resultados. Audio22 efectos originales con volumen/silencio persistentes. Reglas y guardados de bloques anteriores aprobados.

## Bloque19 ampliado: niveles/experiencia/libros/regiones
Usuario el14/10/2026 amplió el alcance: nivel de entrenador para desbloquear libros/regiones, nivel individual Karmany, experiencia solo en equipo principal, tope de Valle Jade10 aplicado por individuo (los inferiores siguen ganando), puntos del árbol para desbloqueos y reconocer progreso previo.

Leer docs/PROPUESTA_PROGRESION_19.md antes de implementar. Sustituye el cuestionario anterior en cuanto a criterio por especies (descartado) y compra gratuita (descartada). Capturas/niveles previos deben reconocerse. Umbrales4/8 para libros siguen como propuesta hasta confirmación; costes, fórmulaXP, crecimiento de estadísticas y niveles iniciales de Karmany no están fijados.

Estado real: entrenador sube1nivel por victoria, máximo10; Karmany no tienen XP/niveles históricos. Puntos existentes se calculan desde nivel/hitos menos rangos aprendidos. Gastos permanentes requieren registro compartido que sobreviva redistribución. Solo Jade tiene ruta jugable; no inventar región siguiente.

## Decisiones pendientes antes de programar balance
Propuesta numérica completa en PROPUESTA_PROGRESION_19:25XP por victoria para cada elegible,100×nivel para subir; criaturas nivel1/XP0 y+5%Vida/Ataque/Defensa por nivel (Velocidad fija); libros nivel4/8 y costes1/2 puntos. Regiones configurables, Jade accesible, siguiente por definir. Resolver si entrenamiento libre daXP y política de redistribución para evitar bloqueo por puntos gastados. Todo ello pendiente de aprobación. No atribuir XP histórica ficticia.

## Después de responder
Registrar valores exactos y dividir bloque19A (XP/niveles/tope/migración/UI) y19B (libros/gasto/acceso regional). Crear feature/level-progression cuando reglas numéricas estén aprobadas. Proteger sesiones activas y validar transacciones únicas, escalado, migración, errores de guardado y puntos compartidos. No entregar un APK con balance supuesto.

## Protocolo al terminar cada actualización
Actualizar bloque actual, estado probado y pendiente, rama y referencias verificadas, enlace de entrega cuando exista, riesgos reales y siguiente paso tras aprobación. Distinguir siempre CI/local de validación en dispositivo. Usar git log como referencia de commit cuando el documento forma parte del mismo commit, evitando autorreferencias imposibles.
