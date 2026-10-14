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

## Bloque 15: animaciones y continuidad (pendiente de validación física)
Rama: feature/combat-animation-continuity. Versión 0.12.0.
Autorizado: mejorar golpes/habilidades y documentar continuidad de manera permanente.
Implementación: anticipación y avance por especie, reacción del oponente, estelas e impacto, protección/curación diferenciadas; entrenadores permanecen quietos. Duración 0.66s, termina antes de respuesta rival 0.7s. Efectos solo visuales; no cambian daño, coste, enfriamiento ni guardado. No usa azar ni nuevas texturas.
Limitación: animación 2D de ilustraciones completas y efectos dibujados, no esqueletos ni fotogramas de anatomía nueva. No reproduce eventos antiguos al reabrir.
Pruebas locales: 870 comprobaciones Godot (74 nuevas) y 3 Python correctas; git diff --check correcto. CI del código 38d89626bf6276a8ecbece45eba2646ce82419a4: run38651071814 correcto, exportación, firma v2/v3 y auditoría aprobadas. APK entregado: [Preview23](https://github.com/axenoban/karmany-monsta-android/releases/download/android-preview-23/karmany-monsta-preview.apk), versión0.12.0/versionCode1023. [PR11](https://github.com/axenoban/karmany-monsta-android/pull/11). Validación física de la nueva animación pendiente. El commit posterior de documentación no cambia el APK. No se ha realizado revisión visual con renderizador de escritorio en este bloque. Prueba física: `docs/PRUEBA_ANDROID_15.md`.

## Bloque actual 16: vínculo animado
Rama: feature/book-binding-animation, basada en 1319101 (bloque15 aún no aprobado explícitamente). Versión0.13.0. dev permanece en Preview22. No interpretar la nueva solicitud como aprobación automática de Preview23.

Autorizado: libro en el centro; criatura entra completamente al vincularse o rebota al fallar; presentación cuidada. Libro original en assets/trial/binding_book.png, generación integrada y prompt en assets/trial/binding_art.json. Escenario real de la localización; luz, órbitas, estelas, absorción y rebote. Secuencia3.6s con omisión segura. Vista previa y resultado estático muestran libro central.

Arquitectura: binding_stage.gd solo presenta el resultado que App.trial_action ya guardó. trial_ui.gd impide doble toque y crea un CanvasLayer que desaparece con su página. Sin coroutines/timers globales, tiradas nuevas, cambios de probabilidad (45%), límite (3), colecciones o esquema de guardado. Volver/cerrar/omitir no vuelve a gastar ni reproduce la secuencia. Si el guardado falla no se anima y se muestra el error. main muestra versión desde build_info en vez de etiqueta antigua.

Pruebas: 1041 comprobaciones Godot (171 nuevas de vínculo) y3 Python correctas. Revisión gráfica de éxito/fallo y pantalla previa con texto normal/grande completada; corregido el recorte superior del Karmany en vista compacta; CI38652857621 correcta: 1041 comprobaciones Godot y3 Python; exportación, firma v2/v3 y auditoría aprobadas. APK0.13.0/versionCode1025: [Preview25](https://github.com/axenoban/karmany-monsta-android/releases/download/android-preview-25/karmany-monsta-preview.apk), código dd1fc0b530f4907f94dce1e017ace807dfba6d5e. [PR12](https://github.com/axenoban/karmany-monsta-android/pull/12). Preview24 fue intermedia: usar25. El commit posterior de documentación no modifica el APK. Prueba física en docs/PRUEBA_ANDROID_16.md. Riesgo pendiente: fluidez y legibilidad en dispositivo Android real.

## Si las pruebas son correctas
1. Verificar commit/APK/CI entregados y registrar la aprobación del bloque16. Confirmar que la validación cubre las animaciones de combate de bloque15 incluidas en esta versión.
2. Integrar por fast-forward en dev/karmany-core la cadena validada; cerrar PRs11 y del bloque16; main permanece publicable.
3. Siguiente propuesta: opción persistente de movimiento reducido aplicada a combate y vínculo, conservando indicadores y resultado; aún pendiente de autorización. El usuario puede priorizar otro bloque.
4. Antes del progreso del Libro u otro bloque grande, acordar las reglas faltantes con el creador.

## Protocolo al terminar cada actualización
Actualizar bloque actual, estado probado y pendiente, rama y referencias verificadas, enlace de entrega cuando exista, riesgos reales y siguiente paso tras aprobación. Distinguir siempre CI/local de validación en dispositivo. Usar git log como referencia de commit cuando el documento forma parte del mismo commit, evitando autorreferencias imposibles.
