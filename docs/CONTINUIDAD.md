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
Preview26,versión0.14.0/versionCode1026, código27e066ea00adbcf625f61f584003e4c42e8cc1b3, documentaciónbb406ce. Aprobada por el creador «pruebas correctas» el14/10/2026. Integrada por fast-forward en dev desde9db69ac abb406ce; PR13 cerrada. CI38654312252:1084 Godot y3 Python, firma/auditoría correctas; humo separado del mezclador real44. main conserva su estado.

Historial: docs/BASELINE_VALIDADO.md. Audio: scripts/effect_audio.gd y docs/PRUEBA_ANDROID_17.md;22 efectos originales, voces acotadas, busSFX, ajustes persistentes. Pruebas headless sin salida y humo real --verify-audio-mixer bajo renderizador/Movie Maker. Combate0.66s y respuesta0.7s. Vínculo3.6s con resultado persistido antes de presentación y omisión segura.

## Bloque actual18: movimiento reducido
Rama feature/reduced-motion, base aprobadaa62ecb3. Versión0.15.0.

Ajuste opcional reduced_motion, desactivado inicialmente y agregado a perfiles antiguos sin cambiar esquema. Se activa desde Ajustes. motion_preferences.gd concentra lectura, supresión de desplazamientos y pose de vínculo. Combate mantiene posiciones de actores, suprime retroceso/rotación y sustituye efectos móviles por señales fijas con entrada/salida de opacidad. Vínculo mantiene libro y criatura quietos, sin trayectorias/órbitas/estelas/temblor; éxito desvanece la criatura en0.30s desde2.05s, fallo la mantiene visible, texto y señal final distinguen desenlace. Sonidos y duración3.6s intactos, omisión segura. Modo normal conserva la presentación aprobada.

90 comprobaciones nuevas correctas de persistencia, migración, movimiento/poses, sonido, captura real en ambos modos y guardado fallido. Regresiones locales completas:1174 Godot y3 Python correctas. Revisadas pantallas de combate/vínculo reducido y Ajustes normal/grande; volumen accesible desplazando Ajustes si el texto es grande. CI/APK pendientes de registrar. Prueba física: docs/PRUEBA_ANDROID_18.md.

## Si las pruebas son correctas
Tras validación: cerrar bloque18 e integrar por fast-forward. Siguiente etapa propuesta: cuestionario de progresión del Libro, con alternativas sobre desbloqueos y costes tomadas del documento maestro; esperar decisiones antes de implementar economía o contenido nuevo.

## Protocolo al terminar cada actualización
Actualizar bloque actual, estado probado y pendiente, rama y referencias verificadas, enlace de entrega cuando exista, riesgos reales y siguiente paso tras aprobación. Distinguir siempre CI/local de validación en dispositivo. Usar git log como referencia de commit cuando el documento forma parte del mismo commit, evitando autorreferencias imposibles.
