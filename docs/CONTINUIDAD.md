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
Preview 22, versión 0.11.0, commit 39ef4b6dbdee1e82abca90ca1f5f9c3cf9b52393. Usuario confirmó «prueba correcta» el 14/10/2026. Integrado en dev/karmany-core. CI aprobada: 796 comprobaciones Godot y 3 Python, firma/auditoría APK. PR10 cerrada.
Leer `docs/BASELINE_VALIDADO.md` para historial y `docs/LOCALIZACIONES_ARTE_14.md` para presentación y activos.

## Bloque actual 15: animaciones y continuidad
Rama: feature/combat-animation-continuity. Versión 0.12.0.
Autorizado: mejorar golpes/habilidades y documentar continuidad de manera permanente.
Implementación: anticipación y avance por especie, reacción del oponente, estelas e impacto, protección/curación diferenciadas; entrenadores permanecen quietos. Duración 0.66s, termina antes de respuesta rival 0.7s. Efectos solo visuales; no cambian daño, coste, enfriamiento ni guardado. No usa azar ni nuevas texturas.
Limitación: animación 2D de ilustraciones completas y efectos dibujados, no esqueletos ni fotogramas de anatomía nueva. No reproduce eventos antiguos al reabrir.
Pruebas locales: 870 comprobaciones Godot (74 nuevas) y 3 Python correctas; git diff --check correcto. CI/exportación se consultan en el PR de esta rama; validación física de la nueva animación pendiente. No se ha realizado revisión visual con renderizador de escritorio en este bloque. Prueba física: `docs/PRUEBA_ANDROID_15.md`.

## Si las pruebas son correctas
1. Verificar rama/commit/CI realmente entregados; registrar aprobación en BASELINE_VALIDADO.
2. Integrar bloque15 en dev por fast-forward y cerrar su PR, manteniendo main.
3. Siguiente propuesta: accesibilidad de combate con opción de movimiento reducido (desactiva desplazamientos y reacción, conserva indicadores), persistente y sin alterar turnos; validar legibilidad móvil y reanudación. Es una propuesta pendiente de autorización, no reglas nuevas ya aprobadas.
4. Antes de introducir progreso del Libro u otro bloque grande, concretar con el creador las reglas que faltan.

## Protocolo al terminar cada actualización
Actualizar bloque actual, estado probado y pendiente, rama y referencias verificadas, enlace de entrega cuando exista, riesgos reales y siguiente paso tras aprobación. Distinguir siempre CI/local de validación en dispositivo. Usar git log como referencia de commit cuando el documento forma parte del mismo commit, evitando autorreferencias imposibles.
