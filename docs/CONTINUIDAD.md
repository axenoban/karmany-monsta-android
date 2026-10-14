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
Preview25, versión0.13.0/versionCode1025, código dd1fc0b530f4907f94dce1e017ace807dfba6d5e, documentación5c63dff. Usuario confirmó «prueba correcta» el14/10/2026; incluye combate animado (bloque15) y vínculo (bloque16). Integrado en dev/karmany-core por fast-forward desde39ef4b6, PRs11/12 cerradas. CI38652857621:1041 Godot y3 Python, exportación/firma/auditoría correctas. main conserva su estado.

Historial: docs/BASELINE_VALIDADO.md. Vínculo: scripts/binding_stage.gd y docs/PRUEBA_ANDROID_16.md; secuencia3.6s, resultado persistido antes de animación, omitir/cerrar sin nuevo intento. Combate: scripts/trial_stage.gd, duración0.66s antes de respuesta0.7s.

## Bloque actual17: efectos de sonido
Rama feature/game-sound-effects, basada en cierre aprobado9db69ac. Versión0.14.0.

22 clips originales sintetizados con semilla fija: assets/sfx/*.wav y manifest.json; reproducibles por ci/generate_sfx.py. Sin grabaciones externas ni música. Cubren toque/error, preparación/impacto, cuatro Insignias ofensivas y curación/protección de Tanugami, guardia, curación, potenciación, control, cambio, apertura/atracción/éxito/rebote/escape del Libro, victoria/derrota, entrada/exploración y recuperador. Cada efecto usa monoPCM22050Hz y pico máximo0.5 antes de mezcla.

Arquitectura: effect_audio.gd, voces limitadas por ámbito y propiedad de su escena; busSFX con limitador y margen de volumen; ajustes opcionales sound/effects_volume, valor inicial65%, migración compatible sin nuevo esquema ni pérdida de progreso. App aplica preferencias tras guardar. Golpe impacta a0.34s; Libro abre0s, atrae1s y resuelve2.05s; escape2.85s. No reproducir sonidos al consultar/reabrir acciones ya consumidas. Omitir/cerrar/suspender cancela la secuencia de sonido. Los sonidos de resultado se emiten tras guardado correcto.

Pruebas:1084 comprobaciones Godot (43 nuevas) y3 Python correctas. Prueba separada del mezclador real:44 comprobaciones, salida capturada no silenciosa y pico0.5845<1. Las pruebas headless de reglas verifican programación sin iniciar voces porque su controlador sin salida no mezcla; el humo de audio activa --verify-audio-mixer bajo renderizador de escritorio y Movie Maker. No se ignoran errores en logs. Se usa reproducción diferida propiedad del nodo y se liberan streams al parar. Validación pendiente: volumen percibido, timbres y latencia en Android. CI/APK se registrarán al entregar. Prueba física: docs/PRUEBA_ANDROID_17.md.

## Si las pruebas son correctas
Cerrar bloque17 e integrar por fast-forward solo tras aprobación. Siguiente propuesta: movimiento reducido en combate y vínculo, aún pendiente de autorización; o siguiente prioridad del creador. Acordar reglas antes de progreso del Libro.

## Protocolo al terminar cada actualización
Actualizar bloque actual, estado probado y pendiente, rama y referencias verificadas, enlace de entrega cuando exista, riesgos reales y siguiente paso tras aprobación. Distinguir siempre CI/local de validación en dispositivo. Usar git log como referencia de commit cuando el documento forma parte del mismo commit, evitando autorreferencias imposibles.
