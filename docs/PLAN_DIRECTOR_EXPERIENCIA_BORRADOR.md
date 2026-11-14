# Karmany Monsta Android · Plan director de experiencia (BORRADOR)
**Versión:** 0.3 · 14 de noviembre de 2026 (rondas 1 y 2; diagnóstico de navegación y composición, decisión de ronda 3 sobre fricción)  
**Estado:** dirección de producto parcialmente definida y diagnósticos técnicos verificados; **NO aprobado como implementación ni modificación canónica**.  
**Objeto:** definir la experiencia objetivo antes de continuar desarrollando gameplay, interfaces o animaciones. Las propuestas de esta versión NO constituyen reglas nuevas.

## 1. Referencias y estado real

- Fuente base: `DOCUMENTO_MAESTRO_ANDROID.md`, corte 12/11/2026. El baseline jugable integrado es `dev/karmany-core@29be7ba3d30ea72e860f62ec4f0c8aa766e6d1b4`, Preview42; `main@9ef7af7` es anterior.
- La cadena pendiente PR21→PR22→PR23 no está integrada en dev. PR24 propone un kit vectorial de Jade Nocturno sin aprobación final. PR25 es un prototipo de interfaz por puntos táctiles, derivado de PR23, con CI verde/Preview53; tampoco está integrado ni aprobado físicamente.
- Inspección técnica de `feature/jade-interactive-location-prototype`: `scripts/main.gd`, `trial_ui.gd`, `trial_stage.gd`, `context_help.gd`, `first_session.gd`, `tactical_encounter.gd`, `jade_route.gd`, `location_hotspots.gd`, `r1_prologue.gd`, `aftermath_screen.gd`, `experience_summary.gd`, `binding_stage.gd`, tests y datos. Manual visual revisado en `docs/diseno/jade-nocturno/README.md` de PR24.
- Este análisis se basa en **código y documentos**, no constituye evaluación visual detallada de fotogramas en un dispositivo ni estudio con jugadores reales. La queja del creador sobre calidad visual es testimonio de uso, no una medición técnica.
- No modificar `data/*.json`, código, balances, arte, guardados ni el baseline por efecto de este borrador.

## 2. Decisiones expresas de producto — ronda 1

| ID | Área | Decisión del creador | Condición |
|---|---|---|---|
| D-01 | Identidad | **Colección y progresión** | Prioridad principal |
| D-02 | Exploración | **Escenarios con decisiones y rutas** | Las decisiones deben tener consecuencias, no solo pulsaciones |
| D-03 | Combate | **Mantener turnos y mejorar UX** | No implica aprobar nuevas habilidades, balance o IA |
| D-04 | Encuentros | **Variables** | No aprobar todavía listas/pesos/especies por zona |
| D-05 | Stamina | **Experimentar antes de decidir** | Sin cambio a reglas actuales |
| D-06 | Ayudas | **Solo bajo demanda** | Nueva dirección UX; código histórico E5 no cambiado |
| D-07 | Motivación | **Equilibrada** | Colección/progresión conserva prioridad |
| D-08 | Prioridad de revisión | **Arte y animaciones** | No implica que el kit propuesto de PR24 esté aprobado |

**Problemas reportados:** animaciones de baja calidad, reconsiderar sprites de personajes, poca percepción de canon, jugabilidad plana y poca exigencia de concentración.

## 3. Diagnóstico técnico y conflictos

### C-01 · Exploración sin consecuencias
El bucle sigue `región → localización → scouting → combate → XP/vínculo`. La primera localización en PR25 incorpora Entorno/Camino/Buscar, pero Entorno y Camino únicamente muestran texto; no hay bifurcación jugable. `JadeRoute.unlocked()` requiere completar puntos anteriores en orden. **Decisión pendiente:** ruta principal lineal con exploración opcional o rutas principales alternativas. No confundir ramificación visual con cambios de estado diseñados.

### C-02 · Encuentros variables frente al contrato regional congelado
Los 12 puntos están configurados con especies/niveles/recompensas determinados. `JadeRoute.valid()` comprueba que el primer rival coincide con la especie del punto. Introducir variabilidad requiere diseño explícito de elegibilidad por región, persistencia de la tirada, representación de progresión y guardados heredados. No se permite seleccionar criaturas al azar sin fuentes canónicas.

### C-03 · Dificultad vs solo mejorar UX
`TacticalEncounter.end_round()` elige generalmente Insignia si está lista, de otro modo Golpe, con excepciones (cura y relevo). No se evidencia una selección rival táctica sensible al equipo o a la situación completa. `regional_balance_tests.gd` prueba terminación/validez con una estrategia fija, no profundidad táctica ni diversión. Primero obtener datos de derrotas, victorias, duración, decisiones realmente necesarias, y luego aprobar IA/reglas/balance. La interfaz puede clarificar consecuencias sin aumentar dificultad de forma artificial.

### C-04 · Calidad de animación vs arquitectura artística
`TrialStage` dibuja PNG individuales con desplazamiento, escala/rotación y efectos generados por código; la animación de acción principal dura 0,66 s. No se ha encontrado un pipeline general de fotogramas de poses por personaje en ese componente. Existe captura de Libro y transiciones especiales con su propio movimiento. El kit de 401 SVG de PR24 corresponde a componentes UI, no a un sistema completo de personajes animados. **Pendiente:** metodología de arte/rigging, volumen de fotogramas, personajes piloto, resolución y control de calidad.

### C-05 · Canon documentado vs canon percibido
La documentación sí fija Shisai, Ezel, Axe, Zephyr, regiones, especies, ecología, Libro y restricciones. El prólogo vigente contiene cinco viñetas y la campaña muestra sobre todo una secuencia de encuentros: **la expresión narrativa en juego es limitada**. Hay que esclarecer si el creador pide ampliar canon, contar mejor el existente o redefinirlo; no inventar historia, nuevos personajes o misiones.

### C-06 · Ayudas bajo demanda vs sistema E5
`ContextHelp` añade un botón `Ayuda` en diversas pantallas y despliega temas automáticamente cuando están pendientes; `FirstSession.automatic()` persiste temas vistos. La decisión D-06 sustituye la dirección UX, pero requiere especificación y tests que conserven guardados y eviten accesos difíciles a información crucial. Propuesta: icono discreto dentro de Opciones, sin tarjetas automáticas en pantalla de juego (por validar).

### C-07 · Stamina vs colección/reintentos
Actualmente hay 100 puntos, regeneración de 1/minuto, costes regionales 10 o 30, y recuperadores. El sistema restringe repetición/captura, que ahora es el eje del juego. Probar alternativas en entorno aislado antes de sustituir reglas productivas.

### C-08 · Prioridad artística vs dependencias abiertas
PR23 es una primera adaptación Jade Nocturno pendiente de revisión física; PR24 añade propuestas vectoriales que no están integradas; PR25 cambia una sola escena, sin convertir las interacciones en decisiones. Rediseñar todos los sprites antes de cerrar estilo/animación/rendimiento obligaría a retrabajo. Definir vertical slice visual primero.

## 4. Revisión de superficies actuales

| Superficie | Estado observado en código | Hipótesis de mejora — NO aprobada |
|---|---|---|
| Inicio | Menú, Ezel/Zephyr y ajustes | Identidad visual fuerte, continuar protagonista, menos contexto técnico |
| Prólogo | Cinco líneas ilustradas, transiciones de opacidad | Mayor expresión de personajes y motivo para avanzar; no inventar trama |
| Shisai/regiones | Dos tarjetas, progreso y requisitos | Mostrar objetivos y sensación de territorio, no solo menús |
| Mapa regional | Seis puntos secuenciales por región | Elegir rutas/zonas con acciones significativas si se aprueban |
| Ficha de localización | Imagen, descripción, coste, entrada | Información puntual clara, evitar modal extenso |
| Exploración | Buscar único; Jade1 prototipo añade dos inspecciones textuales | Decisiones, descubrimiento y eventos con consecuencias reales |
| Combate | Dos barras, última acción, tres técnicas, Entrenador/Detalles/Equipo | Liberar escenario, iconografía, anticipación/feedback y claridad de estrategia |
| Ayudas | Botón y tarjeta contextual automática | Acceso manual en Opciones; eliminar espacio reservado persistente |
| Victoria/XP | Varias vistas, animación de barra, continuación | Dar importancia a lo excepcional y acortar repetición |
| Libro/vínculo | Tres intentos, porcentajes, secuencia animada | Mejor tensión visual sin tocar probabilidades |
| Equipo | Activo/reserva e individuos con niveles | Identidad de cada miembro y comparación/selección ágil |
| Colección | Fichas de individuos capturados | Motivos útiles para capturar, gestionar y probar equipos |
| Bestiario | 21 fichas, revelación según vínculo; 13 especies de combate | Descubrimiento y ecología visible, sin fingir que las 21 son jugables |
| Perfil Ezel | Nivel/XP/resonancias/equipo | Jerarquía informativa y personaje protagonista |
| Árbol | Mapa navegable de resonancias y puntos | Beneficios/condiciones evidentes antes de invertir puntos |
| Libro de mejoras | Probabilidades y mejoras por niveles | Presentación resumida sin confundir coste con resultado |
| Ajustes | Audio, vibración, movimiento reducido, texto grande | Sección diferenciada de ayuda y accesibilidad |
| Diagnóstico/QA | Laboratorio separado y guardado aislado | Mantener como herramienta de desarrollo, fuera del flujo del jugador |

## 5. Criterios de aceptación para una futura experiencia

No fijar objetivos numéricos sin pruebas. Medir al menos:
- **Arte:** coherencia de siluetas, tamaño de sprites, expresiones y legibilidad en teléfono; poses clave de una criatura y un entrenador; coste y rendimiento en Godot 4.7.2.
- **Juego:** tiempo hasta una decisión significativa, diversidad de estrategias ganadoras, frecuencia de derrotas y sus causas, interés en volver a explorar, utilidad de nuevos Karmany.
- **UX:** área de escenario libre frente a interfaz, número de toques para acciones principales, ausencia de ayudas automáticas, acceso manual comprensible, texto grande y navegación Android.
- **Robustez:** todos los perfiles/recibos históricos y 12 etapas conservados; ninguna pérdida de captura/encuentro en pausa, cierre o versión nueva.

## 6. Posible orden de trabajo — PROPUESTA, no autorizado

1. **Dirección creativa y prototipo visual:** decidir diseño de Ezel/Zephyr y técnica de animación; probar dos personajes y una escena en Godot, sin reemplazar assets históricos hasta validar.
2. **HUD y ayuda:** definir jerarquía del combate, retirar tarjetas automáticas manteniendo información opcional; maqueta y accesibilidad.
3. **Combate táctico evaluado:** playtest y simulaciones de decisiones; especificar IA/encuentros difíciles solo tras aprobar reglas.
4. **Exploración con rutas y encuentros variables:** definir estructura de decisiones y pools canónicos elegibles, preservando progreso.
5. **Colección como motor:** definir objetivos, recompensas no inventadas y utilidad de equipos.
6. **Experimento stamina:** comparaciones de ritmo y retorno en QA aislado; aprobar o descartar opciones.

Los bloques de ejecución se redefinirán en unidades medianas tras las decisiones. No mover PR21–25, main o dev durante la definición.

## 7. Decisiones expresas del creador — ronda 2 (14/11/2026)

| ID | Área | Decisión vigente | Implicación y límite |
|---|---|---|---|
| D-09 | Sprites | **Conservar identidad y redibujar con mayor calidad** | No cambiar siluetas, especies ni personalidad por iniciativa del equipo; propuestas para comparar antes de reemplazar |
| D-10 | Animación | **Comparar prototipos antes de decidir** | Ninguna técnica de rigging, secuencias ni presupuesto de fotogramas ha sido aprobada |
| D-11 | Dificultad | **Combinar estrategia y preparación** | Diseñar juego táctico legible y composiciones de equipo importantes; IA, estadística y nuevas reglas siguen pendientes |
| D-12 | Rutas | **Historia principal lineal y caminos secundarios** | Mantener identidad de hitos principales; rutas opcionales aún sin reglas, eventos, recompensas ni modelo persistente |
| D-13 | Encuentros | **Combinación** | Anclas principales + encuentros variables y pistas/búsqueda dirigidas por zona, con elegibilidad y probabilidades aún por acordar |
| D-14 | Canon | **Combinar historia y narrativa ambiental** | Priorizar fuentes aprobadas; no agregar escenas, diálogos, hechos del mundo o personajes sin revisión canónica |
| D-15 | Colección | **Combinar desarrollo, estrategia y descubrimiento** | No equivale a aprobar evoluciones, habilidades, rarezas, fusiones ni nuevos sistemas |
| D-16 | Ayuda | **Sección de ayuda en menú principal y Opciones** | Sin botón persistente ni ventanas automáticas de explicación dentro de gameplay; preservar acceso a información necesaria |
| D-17 | Continuidad UX | **Mayor fluidez entre diferentes vistas** | Auditar transiciones, continuidad visual, cantidad de pasos y regreso sin pérdida de contexto |
| D-18 | Prioridad de navegación (ronda 3 parcial) | **Ambas: demasiadas pantallas/ventanas y cambios visuales bruscos** | Atacar simultáneamente la fragmentación de tareas y la discontinuidad visual; no se reduce a añadir Tween |

La ronda 2 no aprobó ningún cambio de código, cambios de reglas o sustitución del arte. No confundir dirección de diseño con especificación implementable.

## 8. Auditoría de continuidad entre vistas (código candidato inspeccionado)

### Estado observado verificable

- `scripts/main.gd::_show(next_page)` elimina el nodo `Page` previo, lo encola para liberación y construye otro `MarginContainer`, `ScrollContainer` y contenido. El estado de navegación se gestiona aparte con `NavigationHistory`.
- `scripts/main.gd::_playable()` reemplaza el área de lectura por una instancia nueva de `TrialUI`. `TrialUI::_build()` vuelve a componer cabecera, HUD, escena y botones según su `mode`.
- `scripts/main.gd::_back()` respeta modales y animaciones antes de historial; `navigation_history.gd` limita entradas y evita ciertos duplicados. **No confundir ausencia de transición visual suave con navegación semántica defectuosa**.
- `TrialUI._location_details()` abre una ventana con imagen y texto antes de entrar; `_options_menu()`, `_trainer_menu()` y `_team_menu()` abren modales adicionales. Estos pasos son puntos concretos a medir para determinar cuánta fricción percibe el jugador.
- `TrialUI` crea cabecera de escena y `main.gd` también mantiene una cabecera general para pantallas jugables. Su jerarquía y ocupación deben medirse en capturas; no afirmar solapamientos sin prueba visual.
- `ContextHelp` y `FirstSession` todavía insertan controles/tarjetas contextuales. La nueva D-16 sustituye esa intención UX, pero todavía no se ha codificado.
- Ya existen animaciones de combate, resumen, captura y prólogo; **no existe una capa central de transición visual compartida entre todas las pantallas** visible en los archivos inspeccionados.
- Se guardan datos y encuentros al margen de la interfaz; esto ofrece un punto seguro para diseñar vistas más persistentes. **No se dispone de mediciones de FPS, memoria ni latencia de cambio de vista**: la reconstrucción es un riesgo de fluidez percibida, no prueba de bajo rendimiento.

### Flujos que requieren observación en dispositivo

| Flujo | Fricción a comprobar | Objetivo UX (propuesta) |
|---|---|---|
| Inicio → continuar → regiones/mapa | Pantallas redundantes antes de volver a la aventura | Llegar al último contexto útil sin perder orientación |
| Región → punto → ficha → exploración | Ventana intermedia y pasos hasta la primera decisión significativa | Menos interrupciones; ficha contextual liviana |
| Exploración → encuentro → combate | Cambio brusco de modo, nueva instancia de pantalla | Continuidad del escenario cuando corresponda; entrada a combate clara |
| Combate → entrenador/equipo/detalles → combate | Modales y posible pérdida de vista de referencia | Consulta rápida, regreso al mismo turno y acción inequívoca |
| Combate → victoria → XP → vínculo → mapa | Secuencia segmentada y repetida en recorridos frecuentes | Destacar nuevas criaturas/subidas de nivel; acortar resultados rutinarios |
| Mapa → equipo/colección/bestiario → Atrás | Reconstrucción de vistas, retorno contextual | Regresar al origen real conservando foco/selección cuando sea relevante |
| Progreso → árbol/Libro → retorno | Texto largo, decisiones permanentes y selección | Mostrar efecto de la decisión antes de confirmarla |
| Menú principal/Opciones → Ayuda → anterior | Nueva sección solicitada sin interposición en gameplay | Consulta manual en dos accesos, retorno exacto sin forzar tutoriales |

### Tres alternativas arquitectónicas (NO aprobadas)

| Alternativa | Concepto | Ventaja | Coste/riesgo |
|---|---|---|---|
| **A · Transiciones ligeras** | Mantener `_show()` y añadir transiciones controladas, evitando parpadeos y reorganizando modales | Bajo riesgo para pruebas/guardados, compatible con ramas actuales | No elimina reconstrucciones ni todas las interrupciones |
| **B · Shell visual persistente** | Mantener capa de fondo, cabeceras e información esencial; sustituir solo el panel central con un controlador de navegación | Mejor continuidad de escenario y jerarquía, base para animaciones entre estados | Riesgo medio: lifecycle, foco, historial, teardown y regresiones |
| **C · Escenas jugables persistentes completas** | Conservar nodos de mapa/exploración/batalla y alternar visibilidad | Menos recreación visual, facilita persistencia de microestado UI | Riesgo alto de nodos vivos, señales, timers, audio, consumo Android y estados desincronizados |

**Recomendación técnica revisada tras D-18:** conservar semántica de `NavigationHistory` y transacciones de `App`. **A por sí sola no satisface D-18** porque suaviza transiciones pero mantiene demasiadas vistas. Diseñar reducción de interrupciones y un **shell B parcial como objetivo candidato**, usando una demostración pequeña A para medir el coste/beneficio de la transición. Decidir arquitectura después de comparar las dos en un flujo real. No adoptar C por defecto. La transición deberá ser interrumpible/cancelable, respetar movimiento reducido, accesibilidad, gesto Atrás y reanudación segura. Los guardados actuales no deben adquirir datos puramente visuales.

### Contrato de fluidez: criterios de medición sin cifras inventadas

1. Cronometrar en dispositivo la respuesta a pulsación, primera imagen útil y tiempo a control operable de cada transición. Registrar dispositivo, resolución, build, FPS, caídas y memoria cuando se ejecuten tests.
2. Comprobar visualmente si la pantalla conserva fondo, sentido de lugar, posición de selección y orientación. No confundir una animación larga con fluidez.
3. Medir cantidad de toques y ventanas de ida/vuelta en los flujos anteriores; un jugador debe poder retroceder sin reabrir pasos innecesarios.
4. Asegurar que no existen toques dobles, entradas de acciones durante transiciones bloqueadas, señales hacia nodos destruidos, timers/coroutines huérfanos, audio retenido ni incremento gradual de memoria al navegar repetidamente.
5. Comprobar `reduced_motion`: movimientos desactivados sin retrasar acciones ni duplicar transacciones; texto grande y áreas táctiles funcionales en 1280×720, 960×540 y teléfono real.
6. Compatibilidad con PR21 NAV/QA, guardados históricos, captura, stamina, XP y el mismo `encounter.id`/turno al volver del Libro/Equipo/Detalles.
7. No establecer presupuestos de milisegundos o FPS como aprobados sin medir primero el hardware objetivo y obtener decisión del creador.

## 9. Lineamientos de producción artística y animación (evaluación)

- **Identidad congelada por defecto:** las especies, nombres y siluetas históricas del proyecto son referencias, no pretexto para reemplazar canon. Se permite proponer mejor anatomía, separación fondo/personaje, iluminación, expresiones y lectura móvil.
- **Comparación controlada:** crear muestras del mismo Karmany y Ezel con (A) transformaciones 2D refinadas, (B) rigging 2D por partes y (C) animación híbrida con poses especiales. Mantener idénticos personaje, fondo, escala y acciones para comparar la técnica y no confundirla con la calidad de la ilustración.
- **Contenido mínimo a comparar:** reposo, anticipación, acción, impacto/reacción y retorno. Definir duración/frames, tamaño de descarga, consumo, tiempo de producción, mantenibilidad, soporte movimiento reducido y legibilidad antes de generalizar.
- **Puerta:** seleccionar técnica con el creador tras mirar las tres muestras en Godot/Android; solamente después producir lotes medianos de sprites. La calidad del kit UI de PR24 debe evaluarse independientemente de la animación del Karmany.
- **Riesgo:** redibujar por completo todas las criaturas antes de fijar el pipeline visual generaría retrabajo y assets poco reutilizables.

## 10. Propuesta de experiencia coherente (NO es canon ni regla aprobada)

**Ciclo objetivo de producto:** preparación de equipo → selección de ruta principal y posibles rutas opcionales → observación/elección de escenario → descubrimiento o búsqueda de Karmany elegibles → combate táctico legible → vínculo/XP y cambios en el equipo → nueva decisión de recorrido. Esta secuencia **ilustra relaciones entre sistemas**, no eventos, probabilidades ni objetos nuevos.

Compatibilidades a resolver:
- **Historia lineal y rutas secundarias:** el progreso principal debe seguir siendo recuperable y coherente con las 12 etapas actuales; el efecto concreto de los caminos opcionales necesita un contrato de producto y de guardados propio.
- **Encuentros variables con captura:** mantener distinción entre un encuentro principal que acredita progreso y encuentros opcionales que ofrecen variedad; definir catálogo elegible/descubrimiento, límites de repetición y tasas antes de modificar el RNG.
- **Desafío táctico con preparación:** mostrar información que permita decidir, evitar dificultad por opacidad o simple inflación de daño. El patrón rival actual es simple, pero cambiar IA exige definir comportamientos y pruebas de balance canónicas.
- **Colección como centro:** cada Karmany debe tener relevancia comprensible en equipo/exploración, sin inventar evoluciones, poderes o rarezas.
- **Narrativa explícita y ambiental:** reutilizar el canon existente y planificar escenas/descubrimientos mediante un guion pendiente de aprobación. El borrador no declara nueva historia.

## 11. Decisión registrada de ronda 3: reducir pantallas Y suavizar transiciones

**Respuesta explícita del creador:** «Ambas: demasiados cambios de pantalla y transiciones poco fluidas». La molestia no puede resolverse solamente con efectos visuales. Tiene dos causas de UX que deben tratarse juntas:

1. **Fragmentación del recorrido:** abrir nuevas pantallas, modales, confirmaciones o menús para consultar datos o ejecutar acciones frecuentes. Suprimir pasos *visuales* innecesarios no autoriza suprimir confirmaciones con consecuencias, mostrar datos incorrectos ni cobrar recursos de otra manera.
2. **Discontinuidad perceptual:** cambio inmediato de marco, cabecera, fondo, distribución y posiciones entre modos. Una animación cosmética de salida/entrada, por sí sola, no mantiene el contexto si además reorganiza todo el HUD.

**Evidencia inspeccionada:** `main.gd::_show()` recrea la interfaz; `_playable()` reemplaza el contenedor para `TrialUI`; `TrialUI::_build()` crea composición nueva al cambiar de modo; `_location_details()` y `_popup()` generan ventanas para acciones intermedias. `NavigationHistory` está diseñado para regresar por rutas y ya evita parte de los problemas históricos. **No hay medición física actual del tiempo de carga, latencia táctil o FPS**; la prioridad UX proviene de observación del creador. La investigación de rendimiento requerirá instrumentación y prueba real.

### Decisión D-18: alcance y exclusiones

- **Objetivo confirmado:** más continuidad y menos fragmentación de tareas frecuentes.
- **No aprobado todavía:** sustituir `main.gd` por una escena raíz persistente, eliminar el esquema actual, hacer cambios a botones en PR23/24, alterar rutas, capturas o las reglas del Libro.
- **No interpretar como permiso para eliminar:** confirmación de nueva partida, gasto de stamina antes de entrar, abandono del encuentro, consumo de puntos, omisión de vínculo, avisos de guardado fallido o equivalentes críticos.
- **No esconder información de combate necesaria** detrás de la ayuda opcional. La ayuda principal y la ayuda dentro de Opciones se consultan por voluntad propia, pero PS, turno, costes y estados relevantes deben seguir siendo comprensibles sin abrirla.

## 12. Composición objetivo — hipótesis para comparar, no UI aprobada

Definir cuatro **contextos visibles** para una secuencia habitual, no cuatro estructuras obligatorias ni un árbol de escenas nuevo:

1. **Mapa y preparación:** escenario/territorio como protagonista, selección de localización y datos esenciales en un panel compacto. Equipo, colección o Bestiario consultables sin perder orientación; no exigir ida y vuelta a Inicio para acceder a ellos.
2. **Exploración:** ilustración del entorno permanece protagonista; decisiones y feedback contextuales se revelan junto a la escena, no mediante pantalla textual independiente cada vez. Entrar, salir o descubrir conservan su semántica.
3. **Combate:** escena ocupa superficie dominante, con PS y turno visibles; acciones principales agrupadas, secundarias accesibles en panel contextual. Consultar equipo, entrenador o detalles debería ser *una consulta reversible*, sin iniciar un turno ni perder el combate. Conservar tiempo de lectura libre y texto grande.
4. **Resolución:** victoria, XP y Libro pertenecen a un **flujo coherente**; la información y las opciones pueden presentarse en capas sobre el mismo contexto, sin imponer que todas las etapas se fusionen. El vínculo sigue siendo una decisión independiente con su resultado y persistencia actuales.

**Capas candidatas para una maqueta B parcial (no contrato de nodos):**
- *Capa 0 — ambiente*: escenario o fondo coherente con el contexto; evitar duplicaciones durante transiciones.
- *Capa 1 — foco jugable*: mapa, criaturas o escena de acción, con continuidad perceptual.
- *Capa 2 — HUD mínimo*: datos persistentes esenciales, barra de acciones principal, regreso y acceso Opciones en ubicaciones estables.
- *Capa 3 — panel contextual*: ficha de punto, consulta Equipo/Entrenador/Detalles, ayuda voluntaria; solo un panel dominante y cierres inequívocos.
- *Capa 4 — bloqueo excepcional*: confirmaciones destructivas, errores críticos y animaciones especiales que deban tomar el foco.

No mantener todo el equipo, mapa y combate como nodos activos invisibles por defecto. Preferir construcción bajo demanda, con shell estable *solo si* la prueba técnica demuestra utilidad y teardown fiable.

### Flujos antes → propuesta de composición

| Flujo | Estado actual observado | Propuesta UX a evaluar | Restricción |
|---|---|---|---|
| Inicio → Continuar | Navegación a modos o mapa según progreso | Recuperar inmediatamente el último contexto jugable real; evitar pantalla puente informativa | Mismo encuentro/partida, sin nueva entrada |
| Región → punto → ficha → entrar | `_location_details()` abre `AcceptDialog` antes del comienzo | Selección en mapa con ficha/panel contextual y CTA de entrada; conservar confirmación de coste evidente | Mismos desbloqueos y cobros; un solo CTA ejecuta entrada |
| Exploración → inspección → descubrir | Nueva composición de exploración y luego de combate | Mantener referencia visual a la localización y transición corta de escenario a combate | La inspección no modifica estado; buscar no cobra de nuevo |
| Combate → Entrenador/Equipo/Detalles | Ventanas `AcceptDialog` con listas | Panel contextual o cajón reversible, dejando visible el estado del combate cuando sea legible | Ver no ejecuta acciones ni afecta turno; cambiar Karmany conserva coste de acción |
| Combate → Opciones → volver al mapa | Modal con rutas explícitas | Opción accesible sin duplicación de encabezados/menús; retorno inequívoco | «Volver» distinto de «Abandonar» y «Ir al mapa» |
| Victoria → XP → vínculo | `AftermathScreen` tiene fases diferenciadas, recompensa y captura | Pantalla de resultados cohesionada con progresión destacada, elección del Libro clara y transiciones compactas | No omitir XP ni desactivar vínculo automáticamente; resultado guardado exactamente una vez |
| Mapa → Equipo/Colección → Atrás | `NavigationHistory` conserva contexto, pero se reconstruye la UI | Conservar la región/fondo y la selección cuando sea relevante; panel breve para consulta, vista completa para gestión extensa | Atrás Android coincide con botón, sin referencias a nodos liberados |
| Inicio/Opciones → Ayuda | E5 actual la inyecta por contexto y puede mostrarse automáticamente | Sección consultable solo desde Inicio y Opciones, con navegación de retorno al origen | Preservar las explicaciones documentadas; sin forzar tutorial ni escribir estados espurios |

### Jerarquía visual recomendada (antes de diseñar assets)

- **Un único punto focal** por vista: mapa en exploración, Karmany en combate, criatura al consultar colección, resultado al recibir XP/vínculo.
- **Dos niveles de acción:** controles frecuentes en primera capa; configuración/explicaciones y consultas extensas en segunda capa. Los controles secundarios no deben ocupar el tamaño del escenario.
- **Posiciones coherentes:** ubicación reconocible de «Volver», «Opciones», PS/turno y acción primaria; no duplicar cabeceras ni botones equivalentes sin propósito.
- **Transiciones breves y semánticas:** cambio entre modos con persistencia de fondo cuando es la misma localización; entrar a región, combate, victoria o Libro puede usar énfasis distinto. Evitar movimientos largos por defecto.
- **Respuesta inmediata:** feedback visual a la pulsación aunque la nueva pantalla tarde en poblarse; no declarar duraciones aceptables sin pruebas.
- **Ajustes de accesibilidad:** texto grande, lector/etiquetas aplicables, gesto Atrás y movimiento reducido; alternativa instantánea sin penalización, botones táctiles separados, interfaz bajo orientaciones admitidas por la aplicación.
- **Controles de diagnóstico/versión:** nunca reservar espacio prominente en la experiencia normal. Conservarlos para QA y diagnóstico cuando correspondan, sin ocultar alertas relevantes.
- **Integración artística:** los marcos/íconos de PR24 se evalúan en estas composiciones antes de producir o incorporar lotes; el diseño debe funcionar aun sin ornamentación extra.

## 13. Arquitectura y orden de validación propuestos (pendientes de autorización)

**Recomendación de diseño:** orientar el producto hacia una composición **B parcial** (base visual coherente + contenidos contextuales), porque D-18 exige reducir *a la vez* pantallas y discontinuidad. Probar primero un pequeño cambio A para observar transición visual en el flujo. Una arquitectura B completa o C no queda aprobada.

**Paquete experimental mínimo, a diseñar antes de programar:** `mapa Jade → seleccionar jade_point_1 → entrar → inspeccionar/descubrir → combate → consultar Equipo/Detalles → regresar al mismo turno → resultado → mapa`. Usar solo datos/recursos existentes; no alterar gameplay, comportamiento enemigo, canon ni recompensas.

**Comparación de dos prototipos futuros (requerirán aprobación previa):**
- **P-A — composición actual simplificada:** eliminar pantallas intermedias superfluas y añadir una transición visual ligera sin cambiar el montaje general. Sirve como control de coste/beneficio; preserva `_show()`.
- **P-B — shell parcialmente persistente:** sostener fondo/HUD de contexto mientras cambian paneles; preservar instancias solo donde el ciclo de vida esté controlado. Sirve para validar si el coste de arquitectura aporta una ganancia UX real.
- Ambos deberán mostrar la misma información funcional, el mismo texto relevante, las mismas acciones y restricciones, sin cambiar estadísticas ni progresión. No mezclar prototipo de flujo con redibujo de sprites: compararlos separadamente para atribuir las mejoras.

**Matriz de verificación requerida:**
1. Completar un recorrido habitual con menos interrupciones perceptibles y sin sacrificar comprensión ni decisiones importantes. Registrar toques, modales y pasos antes/después.
2. Medir latencia toque→feedback→vista operable, FPS y memoria en dispositivo objetivo; no comparar exclusivamente una captura fija.
3. Ejecutar 20 ciclos de navegación, cierre de paneles, acceso a equipo, cambios de orientación/áreas seguras admitidas y vuelta desde combate sin acumulación de nodos, timers, audio ni señales. Probar cierre/reapertura.
4. Verificar `campaign.encounter`, XP, stamina, vínculo, equipo, Libro y guardado exactos antes/después de consultas; ningún duplicado de recompensa ni acción accidental.
5. Mantener regresiones NAV-01 y E5/R1 (excepto cambios UX expresamente aprobados tras el Plan Director), laboratorio QA aislado y pruebas renderizadas normal/texto grande.
6. Probar `reduced_motion` y prioridades de cierre de modales, animaciones, diálogo y Atrás Android. El estado nunca queda inaccesible al interrumpir transición.

**Dependencias reales:** PR21 y PR22 anteceden al PR23 y al prototipo PR25; PR24 es una propuesta visual paralela. Este documento se basa en `dev/karmany-core` pero analiza los candidatos sin incluir sus cambios. Antes de implementar habrá que reconciliar commits y alcance sin merges ciegos ni ediciones sobre sistemas aprobados innecesarias.

## 14. Decisiones pendientes y puerta de cierre

**Confirmado:** dirección de las rondas 1–2; redibujo conservando identidad; comparación de técnicas de animación; ayuda bajo demanda desde Inicio y Opciones; doble prioridad en navegación (reducir pasos y brusquedad).

**Aún requieren decisión/validación:**
1. ¿Presentar Equipo/Entrenador/Detalles como panel sobre escena o navegación completa en determinadas operaciones? Un prototipo con teléfono y texto grande debe validar la alternativa.
2. ¿Compactar automáticamente resultados rutinarios o permitir modo resumen/expandido? La elección de vincular debe permanecer explícita.
3. ¿Un shell B parcial aporta mejora respecto a A suficiente para justificar complejidad? La recomendación no es autorización.
4. Elegir personaje, fondos, escala y técnica final de animación por comparación; **sprites actuales no reemplazados**.
5. Contratos concretos de caminos opcionales, encuentros variables y dificultad; requerirían decisiones canónicas y pruebas; stamina permanece en experimentación.
6. Auditoría de capturas/vídeo en teléfono y feedback del creador sobre densidad de HUD, tamaño de Karmany y calidad de transiciones.

**No cerrar el Plan Director ni iniciar cambios ejecutables** hasta contar con diseño/prototipos o autorización específica. No tocar `main`, `dev/karmany-core`, PR21–25, arte, gameplay, validadores ni guardados durante este trabajo documental. Los criterios numéricos de tiempo/FPS dependerán de mediciones y hardware.

**SIGUIENTE PASO:** revisión con el creador de paneles contextuales y resumen de resultados; luego ilustrar comparativamente los dos patrones de flujo sobre una misma escena (maqueta no ejecutable) y plan de validación de animaciones.  
**RESPONSABLE:** CHAT documenta/proyecta alternativas; creador aprueba arquitectura y cambios de UX; implementación solo en fase expresamente autorizada.
**INSTRUCCIÓN PARA CONTINUAR:** Lee `docs/PLAN_DIRECTOR_EXPERIENCIA_BORRADOR.md` en `feature/plan-director-experiencia-juego` y PR26; verifica GitHub real, documentación maestra y PR21–25. D-18 indica reducir fricción de pantallas y cambios bruscos de forma conjunta. No modificar sistemas ni publicar una APK hasta autorización.
