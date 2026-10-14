# Exploración cenital, stamina y combate · Preview 0.10.0

Baseline aprobado: Preview 18 (0.9.0), código 0b8d083, cierre f830174. El creador validó el recorrido y solicitó este bloque el 14 de octubre de 2026. Pendiente de validación física en feature/exploration-stamina-ui.

## Reglas decididas por el creador

- Stamina máxima 100. Localizaciones 1, 2 y 3: entrada 10; localización final: entrada 30.
- Recuperar un punto por minuto, incluyendo tiempo con el juego cerrado.
- Un recuperador otorga hasta 30, sin superar 100. A stamina completa no se permite consumirlo.
- Cada victoria en localizaciones tiene un 20% de entregar una unidad, incluidas repeticiones. Entrenamiento queda fuera de esta obtención.

Los valores están en data/exploration_rules.json. El recuperador es una etiqueta funcional de esta prueba; no añade un objeto narrativo ni una economía comercial. Las reglas anteriores del Libro, equipo, técnicas y recompensas del entrenador se conservan.

## Mapa y localizaciones

Se sustituye el catálogo visual de criaturas por un fondo cenital y puntos de acción. No aparecen retratos ni nombres de especies en el mapa, ni siquiera al completar el lugar. Los rótulos Lugar 1–4 son identificadores funcionales, no nueva geografía canónica. Se conserva el desbloqueo guiado aprobado.

Entrar paga y guarda la stamina en la misma transacción que crea el encuentro, sus tiradas y el estado de exploración. La pantalla de localización permite Buscar encuentro; la criatura se revela después de esa búsqueda. Retomar desde el mapa o reabrir el juego conserva el lugar pagado y no vuelve a cobrar. Salir sin combatir o abandonar no devuelve el cansancio de la entrada. No se añaden costes a ataques, cambios, captura, consulta de menús o Entrenamiento.

El mapa muestra stamina efectiva, tiempo para el siguiente punto, cantidad de recuperadores y botón para usarlos. Las opciones de equipo, colección, árbol, Libro e introducción quedan en Opciones del mapa. El fondo es un concepto visual decorativo; no introduce misiones, lugares con nombre ni reglas de desplazamiento libre.

## Tiempo, objetos y guardado

ExplorationEnergy es un modelo puro separado del combate. El estado campaign.exploration contiene stamina, ancla de tiempo en segundos, recuperadores, revisión, recibo de obtención y fase de búsqueda. El perfil mantiene schema 3 con migración validada del campo ausente.

La recuperación se calcula desde el reloj local al consultar, gastar o usar un objeto; no requiere procesos de fondo ni conexión. Se conserva la fracción de minuto mientras la stamina no está completa y no se acumula recuperación por encima de 100. Retroceder el reloj no concede puntos mientras no alcance de nuevo el ancla. La visualización se actualiza cada segundo con un Timer hijo de la página; no escribe el archivo cada segundo.

La tirada del objeto se fija al entrar (entero uniforme 0–9999; éxito si menor que 2000). Guardar antes del combate impide reroll por cerrar, reanudar o reintentar una escritura fallida. Victoria, recibo de ruta, progreso habitual e inventario se confirman juntos. El recibo resuelto evita duplicar el objeto. La obtención no depende del éxito de captura posterior.

Usar un recuperador valida revisión e inventario y guarda cantidad/stamina en una transacción. Una escritura fallida conserva ambos. Continuar después de ganar limpia el recibo junto al encuentro y conserva el inventario.

Las partidas anteriores reciben stamina completa sin cargos retroactivos. Un encuentro antiguo en curso conserva su fase y no obtiene una tirada de objeto inventada. El progreso del recorrido, colección y árbol se mantiene.

## Interfaz de combate

Barras visibles del aliado y rival con sus PS actuales/máximos. Se actualizan desde el estado confirmado al atacar, curar, recibir daño o cambiar de activo. No se calcula Vida independiente desde la animación.

Permanecen visibles las tres técnicas del Karmany, la última acción y los accesos Entrenador/Equipo. Entrenador abre las resonancias equipadas y sus motivos de bloqueo. Equipo abre el cambio confirmado; no elimina el reemplazo obligatorio tras derrota. Opciones reúne Estado y técnicas, Volver al mapa y Abandonar pelea. La retirada se confirma y sigue bloqueada durante respuesta pendiente. Volver al mapa conserva esa respuesta.

Los menús se cierran antes de abrir una confirmación para evitar ventanas modales exclusivas en conflicto. Revisión mediante imágenes desactivada; se validan nodos, callbacks y geometría normal/texto grande. Las regresiones anteriores se adaptan a la navegación por menús manteniendo sus aserciones de combate.

## Arte y alcance

Herramienta: image_gen integrada. Activo del proyecto: assets/trial/jade_overhead.png. Prompt final completo: assets/trial/exploration_art.json. Fondo nuevo, no edición destructiva de jade.png; generado, inspeccionado e integrado al proyecto. Los marcadores se dibujan en Godot.

Este bloque ya reúne exploración, recurso temporal, objeto e interfaz. La progresión de mejoras del Libro permanece para otra etapa: todavía requiere decidir condiciones de desbloqueo/costes. No se introduce a la vez una economía o trama sin reglas aprobadas.
