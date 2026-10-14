# Localizaciones y dirección artística · Preview 0.11.0

Baseline: Preview 19 aprobada el 14 octubre 2026. Rama feature/location-art-direction; pendiente de prueba física.

## Comportamiento

Seleccionar un marcador abre una ficha de consulta. Los lugares bloqueados o sin stamina siguen siendo consultables, pero Entrar conserva las validaciones de progreso, encuentro activo y stamina. El botón revalida el estado real y utiliza App.start_route: no hay una nueva ruta de gasto. Consultar/cerrar no modifica guardado, secuencia ni tiradas. Retomar un encuentro pagado no cobra, incluyendo reanudación tras cierre.

LocationVisuals separa presentación de reglas. Lugar 1–4 conserva sus identificadores y especies; las etiquetas claro, arboleda, orilla y sendero describen el terreno ilustrado, sin añadir geografía canónica ni historia. El fondo se obtiene del origen de ruta asociado al ID del encuentro, nunca de la especie rival; cambiar de Karmany o entrar en Entrenamiento no altera ni hereda accidentalmente ese origen.

Exploración, combate y captura muestran el mismo fondo del lugar. El mapa se ajusta sin deformarse y sus marcadores comparten la transformación del terreno; el combate conserva proporción mediante recorte centrado. Se corrige la orientación del rival para que mire al aliado.

## Arte original

12 activos nuevos creados con la herramienta integrada image_gen: mapa, cuatro fondos, cinco Karmany y dos personajes. Las referencias del creador aportan dirección general: contornos definidos, formas legibles, expresividad, cel shading, color y aventura. Los sujetos proceden del catálogo y las fichas/prompt aprobados del proyecto. No se distribuyen las referencias externas. Los activos previos se conservan para trazabilidad; los consumidores usan las versiones v2.

Prompts finales y rutas: assets/trial/art_direction_v2.json. Activos finales: assets/trial/*_v2.png y assets/trial/jade_point_1.png hasta jade_point_4.png. PNG de criaturas/personajes con alpha original preservado. No se altera el balance, técnicas, contenido del Libro o reglas de captura.

AdventureTheme centraliza los estilos de botones, paneles y barras. Texto, cifras y controles se dibujan en Godot para mantener accesibilidad y coherencia con el estado real; no se hornean en las imágenes.

## Validación

790 comprobaciones Godot y 3 pruebas Python correctas. Importación sin errores. 45 comprobaciones nuevas de fichas, consulta sin gasto, bloqueos, pago/reanudación, correspondencia fondo/origen, fallback de Entrenamiento y consumo de arte v2. Se mantienen las regresiones del Libro, árbol, colección, captura, reemplazo y turnos automáticos.

Prueba física: docs/PRUEBA_ANDROID_14.md. Capturas de revisión de escritorio excluidas del APK; no activar captura en Android.

Revisión visual de 14 pantallas locales: mapa, ficha e introducción normal/grande, exploración y combate de los cuatro lugares. Corregido el recorte inicial del botón Entrar; se fija un mínimo de contenido y se comprueba su visibilidad con texto normal/grande. Las técnicas se distinguen por color y el acceso Opciones ocupa solo su ancho necesario.
