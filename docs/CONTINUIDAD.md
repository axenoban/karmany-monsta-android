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

## Bloque19: progresión del Libro · decisión pendiente
Leer docs/PROPUESTA_LIBRO_19.md y data/book_levels.json antes de implementar. Usuario pidió siguiente paso; el cuestionario concreta decisiones de diseño faltantes. No convertir recomendaciones en aprobación por silencio.

Tabla ya aprobada: Inicial45%Común; Mejora1 60%Común/30%Raro; Mejora2 75%Común/45%Raro/20%Épico. Máximo3 intentos. No hay costes o desbloqueos aprobados todavía.

Cuestionario pendiente de respuesta:1A especies capturadas distintas2/4 (recomendación experimental) frente a1B nivel entrenador4/8;2A reclamar gratis manualmente al cumplir requisito (recomendado),2B automático gratis o2C economía nueva que requerirá propuesta de recurso/costes;3A contar capturas previas reales (recomendado) frente a3B empezar contador nuevo sin borrar colección. InicialZephyr y duplicados no cuentan como especies capturadas distintas en1A. Aplicar mejoras solo fuera de encuentros activos para conservar probabilidades/tiradas de sesiones existentes: recomendación técnica del bloque, incluida en propuesta para aprobación.

## Después de responder
Registrar decisiones exactas antes de editar reglas. Si el usuario aprueba una combinación completa, trabajar en feature/book-progression, implementar progreso persistente, requisitos/confirmación, política elegida para encuentros nuevos, probabilidades reales en UI y migración de sesiones históricas. Probar doble toque, escritura fallida, conservación de intentos/tiradas/progreso y capturas únicas. Ante coste/recurso o umbral sin definir, preguntar antes de inventarlo. Este bloque no autoriza generar encuentros/especies raros o épicos adicionales.

## Protocolo al terminar cada actualización
Actualizar bloque actual, estado probado y pendiente, rama y referencias verificadas, enlace de entrega cuando exista, riesgos reales y siguiente paso tras aprobación. Distinguir siempre CI/local de validación en dispositivo. Usar git log como referencia de commit cuando el documento forma parte del mismo commit, evitando autorreferencias imposibles.
