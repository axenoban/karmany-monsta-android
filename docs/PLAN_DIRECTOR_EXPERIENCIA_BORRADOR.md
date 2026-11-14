# Karmany Monsta Android · Plan director de experiencia (BORRADOR)
**Versión:** 0.7 · 14 de noviembre de 2026 (D-24: Libro consume acción del Karmany y abre resolución de victoria/XP)  
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
| D-19 | Navegación de combate (ronda 3) | **Panel sobre el combate** para Equipo, Entrenador y Detalles | La escena sigue de fondo mientras se consulta; las decisiones de juego conservan validaciones y efectos actuales |
| D-20 | Resultados (ronda 3) | **Resultados integrados con vínculo destacado** | Victoria/XP/recompensas en una superficie; Libro como segundo momento visual, sin alterar decisiones ni transacciones |

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

**Confirmado:** dirección de las rondas 1–2; redibujo conservando identidad; comparación de técnicas de animación; ayuda bajo demanda desde Inicio y Opciones; doble prioridad en navegación; **D-19: panel superpuesto al combate**; **D-20: resultados integrados con Libro destacado**.

**Aún requieren decisión/validación:**
1. **RESUELTO D-19:** Equipo, Entrenador y Detalles durante combate se consultarán en **panel superpuesto** (no navegación a pantalla completa). Pendiente validar dimensiones, desplazamiento, legibilidad y ubicación exacta mediante maqueta/prueba real.
2. **RESUELTO D-20 (dirección):** integrar victoria/XP/recompensas, seguido de un momento destacado para el Libro. Sigue por validar cuánto detalle de XP se muestra de entrada.
3. ¿Un shell B parcial aporta mejora respecto a A suficiente para justificar complejidad? La recomendación no es autorización.
4. Elegir personaje, fondos, escala y técnica final de animación por comparación; **sprites actuales no reemplazados**.
5. Contratos concretos de caminos opcionales, encuentros variables y dificultad; requerirían decisiones canónicas y pruebas; stamina permanece en experimentación.
6. Auditoría de capturas/vídeo en teléfono y feedback del creador sobre densidad de HUD, tamaño de Karmany y calidad de transiciones.

**No cerrar el Plan Director ni iniciar cambios ejecutables** hasta contar con diseño/prototipos o autorización específica. No tocar `main`, `dev/karmany-core`, PR21–25, arte, gameplay, validadores ni guardados durante este trabajo documental. Los criterios numéricos de tiempo/FPS dependerán de mediciones y hardware.

**SIGUIENTE PASO:** paneles contextuales ya elegidos por el creador; revisar maqueta y flujo especificado en las secciones 15–19, contrastarlo en capturas/dispositivo y decidir tratamiento de resultados; después comparar animaciones.  
**RESPONSABLE:** CHAT documenta/proyecta alternativas; creador aprueba arquitectura y cambios de UX; implementación solo en fase expresamente autorizada.
**INSTRUCCIÓN PARA CONTINUAR:** Lee `docs/PLAN_DIRECTOR_EXPERIENCIA_BORRADOR.md` en `feature/plan-director-experiencia-juego` y PR26; verifica GitHub real, documentación maestra y PR21–25. D-18 prioriza reducir pasos y cambios bruscos; D-19 fija Equipo/Entrenador/Detalles como panel sobre combate. Revisar especificación de la sección 15 y su validación antes de pedir autorización de implementación. No modificar sistemas ni publicar una APK.


## 15. Decisión aprobada D-19: consulta de combate en panel sobre la escena

**Fuente:** respuesta expresa del creador el 14/11/2026: «Para el Plan Director ... elijo la navegación de combate: Panel sobre el combate. Desarrolla una propuesta detallada de composición y flujo de pantallas; actualiza el borrador sin implementar todavía». El mensaje se repitió sin cambiar el sentido: se registra como **una sola decisión**.

**Aceptado en términos de diseño:** en el combate las consultas **Entrenador, Equipo y Detalles** deben abrir un panel superpuesto, manteniendo visible una parte del combate. No se requiere salir a otras rutas ni abrir tres ventanas nativas diferentes para estas operaciones. La vista del mundo y la identidad de criaturas conservan prioridad.

**No aprobado todavía:** proporciones definitivas del HUD, ubicación lateral/inferior, duración de transiciones, material gráfico, estructura de nodos, modalidad de las confirmaciones, rediseño de menús fuera del combate ni implementación.

### 15.1 Evidencia técnica actual y límites

- En \`scripts/trial_ui.gd::_battle()\` se muestran PS de ambos contendientes, \`Stage\`, texto de última acción, tres acciones principales y botones Entrenador/Detalles/Equipo. \`_trainer_menu()\` y \`_team_menu()\` usan ventanas \`AcceptDialog\`; \`_details()\` crea una ventana \`CombatDetails\` con pestañas.
- \`CombatDetails.setup()\` depende de \`combat_readout.gd\` y separa Activos, Equipo, Técnicas y Resonancias. Es una vista de solo lectura. Su contenido es candidato a reutilización, NO a duplicar la fórmula de estadísticas en UI.
- \`_support()\` también solicita elegir destinatario para ciertas Insignias. Su función real afecta al turno cuando el jugador **confirma la habilidad**, no al abrir el selector. No inventar un nuevo costo por usar el panel.
- \`_act()\` delega en \`App.trial_action()\`; la validez depende de \`encounter.revision\` y del estado actual. No ejecutar una acción con una revisión capturada antes de una respuesta rival o cambio de fase.
- \`main.gd::_back()\` cierra primero ventanas modales; \`NavigationHistory\` conserva rutas, no instancias de nodos. Los paneles en el mismo combate deberán cerrarse localmente, **antes** de consumir una entrada del historial. Conservar prioridad de confirmaciones/animaciones vigente.
- **Precisión de auditoría:** \`main.gd::_playable()\` oculta la cabecera global al pasar a \`TrialUI\`; por tanto **no se ha demostrado que existan dos cabeceras visibles simultáneamente durante el combate**. El trabajo busca consistencia y espacio aprovechado, no reparar un solapamiento inexistente.
- \`AftermathScreen\` y \`BindingStage\` son fases especiales con controles/animaciones propios: D-19 **no autoriza** comprimir, omitir ni modificar las decisiones de victoria, XP y vínculo.

### 15.2 Composición base de combate — wireframe textual para maqueta (NO dimensiones aprobadas)

\`\`\`text
┌────────────────────────── CABECERA DISCRETA ──────────────────────────┐
│ [Volver]  Ubicación / Combate · Turno actual              [Opciones] │
├────────────────────────────── HUD ────────────────────────────────────┤
│ [Karmany activo · Nivel · PS ●──────]  [Rival · Nivel · PS ●──────]  │
├────────────────────────── ESCENARIO DOMINANTE ────────────────────────┤
│                                                                      │
│      [Criatura aliada animada]         [Criatura rival animada]      │
│                   efectos / feedback breve de acción                │
│                                                                      │
├────────────────────────── ACCIONES PRINCIPALES ───────────────────────┤
│           [Golpe]           [Protección]           [Insignia]         │
├────────────────────────── CONSULTAS RÁPIDAS ─────────────────────────┤
│              [Entrenador]       [Equipo]       [Detalles]            │
└──────────────────────────────────────────────────────────────────────┘
\`\`\`

Las tres etiquetas de acción representan sus **definiciones reales** del catálogo; no autorizan renombrar técnicas individuales. El turno, nombres, PS y estado de acciones serán datos vivos, nunca valores incrustados en ilustraciones. La última acción se mostrará como una franja/caption temporal con acceso al historial informativo existente si lo hay; no inventar historial nuevo.

**Propuesta de equilibrio visual a probar:** el escenario debe conservar la mayor área utilizable. En 1280×720 horizontal, estudiar un panel lateral que ocupe aproximadamente **un tercio** y deje los contendientes reconocibles; en 960×540 o con texto grande, replegar en un panel inferior o más ancho con área de lectura desplazable. Estos números son **hipótesis de diseño**, no restricciones aprobadas. El criterio real es legibilidad/targets táctiles y animaciones a escala real.

### 15.3 Cuando se abre un panel

\`\`\`text
┌──────────────────────────── CONTEXTO COMBATE ────────────────────────┐
│ [Volver]       Turno / PS actuales                         [Opciones]│
│                                                                      │
│    ESCENARIO VISIBLE                ┌── PANEL CONTEXTUAL ────────────┐│
│    Aliado ↔ Rival                   │  Entrenador | Equipo | Detalles ││
│    (sin cambiar de ruta)            │  título · Cerrar              ││
│                                     │  CONTENIDO DESPLAZABLE        ││
│                                     │  acciones o lectura actual    ││
│                                     │  motivos de bloqueo          ││
│                                     └───────────────────────────────┘│
│  Acciones principales: protegidas mientras panel monopoliza foco    │
└──────────────────────────────────────────────────────────────────────┘
\`\`\`

El fondo visible es **referencia contextual, no una segunda superficie activa**. Mientras un panel interactivo está abierto, bloquear pulsaciones sobre botones subyacentes para impedir ataques accidentales. Los indicadores esenciales del turno siguen visibles o accesibles en el propio panel. No basar seguridad en oscurecer el escenario, ni esconder datos por transparencia extrema.

- **Panel lateral**: preferencia a comparar en horizontal amplio; apertura corta desde borde, sin desplazar los personajes bruscamente fuera del escenario.
- **Panel inferior**: variante responsiva para altura/ancho limitados; queda una porción de criaturas y PS visibles; contenido con scroll independiente y botones decisivos siempre visibles.
- **Un panel a la vez**: abrir Equipo mientras está Entrenador sustituye su contenido sin apilar ventanas. Cerrar devuelve foco a botón iniciador o al HUD sensato; al cambiar de fase, cerrar el panel.
- **No cerrar por tocar fuera** cuando exista selección o confirmación que pueda perder intención; utilizar Cerrar/Atrás. Tocar fuera puede descartar una consulta puramente informativa **solo si se valida con usuarios**.
- **Ayuda**: no aparece como barra permanente; sección desde Inicio y Opciones conforme a D-16. No obligar a abrir Ayuda para saber quién está activo, cuánto HP tiene o qué acción puede elegir.

### 15.4 Contrato de los tres paneles

| Panel | Consulta visible | Acciones permitidas con semántica actual | Acciones NO permitidas |
|---|---|---|---|
| **Entrenador** | Resonancias actualmente equipadas, efectos reales, recarga, disponibilidad y causa de bloqueo | Seleccionar una resonancia válida, ejecutándola mediante la acción del motor; cierre posterior y actualización de turno | Equipar/comprar resonancias en combate, saltar orden de turnos, usar más de una acción permitida |
| **Equipo** | Hasta tres individuos actuales, activo/reservas, PS por miembro, nivel, efectos de combate y disponibilidad | Elegir una reserva viva para cambio voluntario; mantener confirmación y acción consumida; ante caída del activo, usar flujo existente de **reemplazo obligatorio** sin ataque extra | Agregar/retirar miembros de colección durante combate, cambiar miembro caído, transferir curación/recargas |
| **Detalles** | Resumen real de Activos, Equipo, Técnicas y Resonancias, con estadísticas/recargas actuales obtenidas de \`CombatReadout\` | Solo leer/desplazar/cambiar pestaña; cerrar sin alterar partida | Ejecutar técnicas, comprar puntos, registrar turnos, persistir un estado de «visto» |

**Selector de objetivo de Insignia:** puede reutilizar el **mismo contenedor de panel** como subestado \`target_selection\` para acciones que ya requieren destinatario. Elegir destinatario sigue siendo paso previo a ejecutar \`App.trial_action\`. No cambiar el efecto ni el requisito del objetivo; permitir cancelar sin gasto. Esto es recomendación de UX y queda pendiente de confirmación en la prueba.

**Confirmaciones:** cambiar Karmany o abandonar combate conserva confirmaciones actuales cuando existan; estas se tratan como diálogos críticos separados y con prioridad sobre el panel. No usar el panel de Detalles para mutaciones.

### 15.5 Contrato de estados y eventos propuesto — interfaz, no cambios de reglas

Estados UI efímeros (no en \`profile.json\`): \`closed\`, \`trainer\`, \`team\`, \`details\`, \`target_selection\`. Un bloqueo crítico de captura/transición/recompensa/confirmación **prevalece** y puede cerrar o suspender la consulta; no se mantiene un overlay con acciones pendientes durante una cinemática.

| Evento | Antes | Después en UI | Efecto en motor |
|---|---|---|---|
| Pulsar Entrenador/Equipo/Detalles | \`closed\` | Panel correspondiente | **Ninguno** |
| Cambiar pestaña Detalles o desplazar | \`details\` | Misma consulta | **Ninguno** |
| Cambiar de pestaña rápida | Otro panel abierto | Nuevo contenido, sin apilar ventanas | **Ninguno** |
| Cerrar / botón Atrás Android | Panel abierto, sin confirmación superior | \`closed\`; foco al combate | **Ninguno** |
| Pulsar resonancia disponible | \`trainer\` | Validación del motor y resultado actual de acción | La **acción vigente** del entrenador, una vez |
| Elegir destinatario de Insignia | \`target_selection\` | Confirmar ejecución de habilidad | La **acción vigente** del Karmany, una vez |
| Cambiar voluntariamente de Karmany | \`team\` | Diálogo de confirmación existente; luego nuevo estado | Consumir acción y permitir respuesta rival conforme a modelo |
| Rival pasa a responder o revisión cambia | Cualquier panel | Refrescar lectura; deshabilitar acciones obsoletas; cerrar si escena crítica | **Ninguna acción adicional** |
| Animación crítica / fin de encuentro | Cualquier panel | Cierre de consulta, capa crítica visible | Flujo ya registrado por motor |
| Nueva partida, cambio QA/perfil, teardown | Cualquier panel | Descartar nodo UI/sus señales/foco | No reusar IDs/revisión anteriores |

El panel muestra un **snapshot fresco** del encuentro. Cada CTA de acción debe reconsultar \`App.profile.campaign.encounter\`, verificar \`encounter.id\`, \`revision\`, \`phase\`, \`App.ui_epoch\`, disponibilidad y transición pendiente **antes** de delegar una única acción; un clic sobre botón obsoleto se rechaza con explicación, no se interpreta como acción para otro turno. Evitar conexiones/closures hacia nodos liberados, procesos y temporizadores que sobrevivan al desmontaje.

### 15.6 Regreso, gestos y superposición segura

Orden de prioridad **de diseño** al pulsar Volver/Atrás, manteniendo las reglas actuales de escenarios especiales:

1. Si hay una **confirmación o diálogo crítico abierto**, resolver/cerrar ese diálogo conforme a su contrato, sin ejecutar la acción por cancelación.
2. Si hay una animación cinematográfica/transición con tratamiento de Atrás aprobado, respetar el método de finalizar/omitir ya existente; no duplicar callbacks.
3. Si hay **panel de consulta**, cerrarlo y permanecer exactamente en el mismo \`encounter.id\`, turno, fase y modo.
4. Si no hay panel ni diálogo, invocar \`NavigationHistory\` y la semántica contextual R1.1 existente.
5. Distinguir explícitamente **Volver**, **Ir al mapa** (conserva encuentro pendiente cuando el contrato lo permite) y **Abandonar pelea** (termina sin recompensa): no son sinónimos.

Al abrir/cerrar consultas no escribir guardados, no sumar historial de páginas, no ejecutar \`App.trial_action\`, no consumir \`stamina\`, no cambiar HP/XP, no lanzar efectos SFX de combate ni producir un segundo \`CombatTransitionScreen\`. Pueden sonar respuestas de UI si ya están admitidas por preferencias, sin fingir acciones de combate.

### 15.7 Flujo principal de combate y casos excepcionales (propuesta)

\`\`\`text
Mapa → Localización → Exploración → Encuentro → COMBATE
                                                 │
                                   ┌─────────────┼─────────────┐
                                   ▼             ▼             ▼
                              Entrenador        Equipo       Detalles
                                   │             │             │
                             consultar/usar  consultar/     solo leer
                              resonancia      cambiar         │
                                   │             │             │
                                   └─────────────┼─────────────┘
                                                 ▼
                                        MISMO COMBATE
                                     turno y estado real
                                                 │
                                 ┌───────────────┼───────────────┐
                                 ▼               ▼               ▼
                         Respuesta rival     Reemplazo         Victoria
                                 │           si cae activo        │
                                 └───────────────┤               ▼
                                                 │          XP → Libro
                                                 └───────────────┘
\`\`\`

**Caso 1 — Consultar sin actuar:** tocar Detalles → Equipo → cerrar → Golpe: sigue el mismo turno, no hay gasto intermedio.

**Caso 2 — Acción del entrenador:** abrir Entrenador, elegir resonancia disponible (opcional), cerrar/regresar a acciones del Karmany según modelo y después respuesta enemiga. No permitir ejecutar otra resonancia si el turno ya la consumió.

**Caso 3 — Cambio voluntario:** Equipo → reserva viva → confirmar → acción de cambio y respuesta rival, conservando estadísticas/efectos/recargas del miembro activo y del entrante. Cancelar confirma **cero** cambios.

**Caso 4 — Reemplazo por derrota:** cuando cae el activo y hay reserva, interfaz ofrece el reemplazo obligatorio actual. No exigir una selección de Equipo por la misma ruta del cambio voluntario ni cobrar respuesta rival gratuita.

**Caso 5 — Insignia dirigida:** Insignia → selector de destinatario (solo cuando lo exige el efecto real) → acción o cancelar. Un botón del panel no debe ejecutar la habilidad dos veces.

**Caso 6 — Respuesta rival pendiente:** los paneles informativos pueden abrirse si no interfieren con la animación, pero cualquier CTA obsoleto o acción prohibida queda deshabilitada. Si la respuesta llega mientras el panel se lee, refrescar lectura o cerrar con feedback; nunca dejar un turno antiguo seleccionable.

**Caso 7 — Victoria y vínculo:** cerrar consultas, ejecutar la secuencia vigente de resultado/XP/Libro, sin repetir recibos ni cambiar límites de intento. La futura compactación de resultados **no** está aprobada por D-19.

**Caso 8 — Pausa, reinicio y Atrás:** abrir panel, ir a segundo plano o cerrar app; al reabrir se restaura encuentro real según guardado, sin requerir restaurar el panel. Atrás Android cierra primero la consulta, no abandona combate por accidente.

## 16. Contrato técnico candidato y límites arquitectónicos (NO autorizado para implementación)

**Acoplamiento previsto sin romper R1.1:** un componente presentacional \`CombatContextPanel\` (nombre de trabajo) y un controlador local de \`TrialUI\` que gestione el subestado UI. Mantener \`App\` como fuente única de verdad y \`NavigationHistory\` para cambios **entre** páginas; no introducir los paneles en el historial de rutas. Mantener \`CombatReadout\` y demás modelos como fuente para valores y restricciones, sin cálculos independientes de daño, costo, cooldown, rareza o probabilidad.

- **Deuda técnica que evitar:** hacer persistentes todas las vistas de \`main.gd\`, crear tres diálogos vivos ocultos, mantener conexiones a \`TrialUI\` tras \`queue_free()\`, guardar \`Control\` en perfil, o crear un nuevo sistema de turnos para la UI.
- **Transición y movimiento reducido:** animación sutil de entrada/salida de panel, reversible e interrumpible; \`reduced_motion\` evita desplazamientos y no retrasa acceso. Duración y easing se decidirán mediante prueba.
- **Diseño Jade:** usar la dirección Jade Nocturno acordada y comparar las piezas propuestas de PR24; no convertir SVG todavía no aprobados en arte final. Paneles y botones deben tener estados presionado, seleccionado, foco, deshabilitado y mensajes de error claros.
- **Escalado y legibilidad:** diseño horizontal de referencia 1280×720 y 960×540, más teléfono real, texto grande. Contenido de Detalles puede crecer; scroll interno dentro de safe area, foco de teclado y blancos táctiles medidos en Android. Si un panel tapara absolutamente toda la escena para leer texto grande, registrar esa contradicción para decidir excepción.
- **Overlays críticos:** ventana de confirmación de cambio/abandono por encima del panel; durante transición de encuentro o vínculo prevalece la capa cinematográfica. El cierre no debe dejar un cuadro sin dueño.
- **Testing y protocolo:** validar primero una maqueta estática de composición; después, si el creador autoriza la implementación, una rama feature aislada con pruebas del motor y UI; PR y APK con número/commit/CI verificados, sin merge hasta aprobación física.

### 16.1 Superficies que cambiarían, si se autoriza

\`scripts/trial_ui.gd\` (entrada y presentación); \`scripts/combat_details.gd\` (separar datos de ventana, sin duplicar \`combat_readout.gd\`); nuevo control de panel; \`scripts/main.gd\` únicamente si se requiere la prioridad Atrás/UI compartida; \`scripts/context_help.gd\` y menús Inicio/Opciones en **otro bloque** para D-16. Evitar tocar \`tactical_encounter.gd\`, \`app.gd\`, \`save_store.gd\`, \`data/*.json\`, \`aftermath_flow.gd\` o \`binding_stage.gd\` sin necesidad técnica demostrable. Definir tests separados antes de cualquier edición.

## 17. Matriz de aceptación futura para D-19

| ID | Prueba requerida | Resultado esperado |
|---|---|---|
| UX-CB-01 | Abrir/cerrar cada uno de los tres paneles repetidamente | Misma escena y turno; ausencia de ventanas adicionales y movimientos abruptos |
| UX-CB-02 | Encadenar Entrenador → Equipo → Detalles → cerrar | Un solo panel visible; retorno directo al combate; sin entradas nuevas en \`NavigationHistory\` |
| UX-CB-03 | Ver Detalles y cancelar Equipo/Entrenador | \`campaign.encounter\`, XP, stamina, vínculo y guardados invariantes |
| UX-CB-04 | Resonancia opcional y luego habilidad Karmany | Solo las acciones permitidas; misma respuesta rival que antes |
| UX-CB-05 | Seleccionar cambio de equipo y cancelar/confirmar | Cancelar no hace nada; confirmar una vez consume acción, rival responde; relevo obligatorio distinto |
| UX-CB-06 | Insignia con selección de objetivo | Cerrar/cancelar no consume acción; selección válida dispara una sola transacción |
| UX-CB-07 | Cambiar \`revision\` mientras panel abierto o recibir respuesta rival | Botones obsoletos invalidados; ningún doble turno o nodo huérfano |
| UX-CB-08 | Abrir panel, pulsar Atrás Android, luego Volver | Primer Atrás cierra panel; siguiente ejecuta navegación contextual segura |
| UX-CB-09 | Animación crítica de ataque/victoria/vínculo y panel | Nunca solapamiento inseguro ni duplicación de efectos/XP/captura |
| UX-CB-10 | Texto grande y movimiento reducido en 1280×720, 960×540 y teléfono | Contenido desplazable, botones legibles y focus correcto; sin tapar permanentemente toda la escena |
| UX-CB-11 | 20 ciclos de apertura/cierre, pausa/reanudación y cambio QA | Sin crecimiento no acotado de nodos/señales/audio; guardado normal intacto y QA aislado |
| UX-CB-12 | Test usuario novato en un encuentro | Diferencia acción de consulta y acción de combate; sabe cómo cerrar panel sin salir de pelea |

**La evidencia exigida:** capturas/video de la escena con cada panel, métricas de toques y cambio de modo, logs de regresión y confirmación física en Android. El prototipo sin implementación no certifica ninguno de estos tests.

## 18. Paquetes de implementación futura (solo planificación)

**Bloque UX-C1 — HUD y consultas de combate**: aproximadamente 8–12 componentes comportamentales/visuales coherentes: shell de combate, cabecera/PS, escena, barra acciones, barra consultas, panel, encabezado/cierre, pestañas de Detalles, listado Equipo, lista Entrenador, bloqueo/foco y respuesta de estado. Separar activos gráficos de cambios lógicos cuando proceda. Estimar después de maqueta.

**Bloque UX-C2 — Continuidad entre exploración y combate:** transición corta, ficha local contextual, eliminación de pasos intermedios, Back y conservación de escenario en el flujo. Solo una vez revisado el contrato con la historia principal y la variante Jade1; no ampliar nuevas rutas aquí.

**Bloque UX-C3 — Resultados y vínculo:** D-20 aprueba integrar la **presentación** de victoria/XP/recompensas, manteniendo al Libro como momento destacado posterior. No fusionar transacciones, descartar elecciones ni omitir checkpoints.

**Bloque UX-C4 — Ayuda de consulta manual:** Inicio + Opciones, migración no destructiva de \`first_session\` cuando corresponda. Eliminar tutorial automático requiere pruebas de aprendizaje, no solo ocultar \`ContextHelp\`.

El orden de producción se ajustará a la validación previa del lenguaje visual y de animación (D-09/D-10) y a la reconciliación de PR21–25. Estos paquetes son **propuestas de trabajo**, no fases autorizadas.

## 19. Decisiones todavía abiertas después de D-19

- **Resueltos:** la consulta de Equipo/Entrenador/Detalles ocurre **encima del combate**, con escena visible; intención de reducir pasos y brusquedad; ayudas manuales en Inicio/Opciones; demás elecciones generales de rondas 1 y 2.
- **Para maqueta visual:** panel lateral frente a inferior según resolución; cantidad exacta de escenario visible; barra superior/inferior y manejo de texto grande.
- **Para futura autorización técnica:** A simplificada vs B parcial, transición específica y lifecycle; no exigir una escena completamente persistente por la sola preferencia de panel.
- **Resuelto D-20:** dirección visual de resultados integrados y Libro destacado. **Por decidir:** detalle XP, animación híbrida vs otras técnicas; rutas secundarias, encuentros variables, comportamiento rival, stamina, contenido narrativo y arte.
- **Límite:** ningún fragmento de esta v0.5 modifica reglas, datos, estado del repositorio integrado, gameplay ni UI; PR26 sigue documental y draft.

**SIGUIENTE PASO:** revisar las maquetas de panel de combate (D-19) y resultados integrados/Libro (D-20), contrastar capturas/vídeo y avanzar hacia la prueba de técnicas de animación.


## 20. Decisión D-20 — Victoria/XP/recompensas integradas y vínculo destacado

**Fuente explícita:** el creador elige «Resultados integrados con vínculo destacado» y solicita **analizar, documentar y actualizar PR26, sin implementar**.

**Dirección de producto confirmada:** tras una victoria, mostrar en una sola superficie el resultado, XP de cada integrante, niveles alcanzados y premios efectivamente otorgados. Acto seguido, el Libro conserva un momento **visualmente propio**, con probabilidad, objetivo elegible y elección expresa. Esta decisión es de UX y NO autoriza cambiar reglas, datos canónicos, guardados, estadísticas, probabilidades ni contenido.

### 20.1 Estado real inspeccionado y riesgos

1. El documento maestro Android señala que el último rival vencido origina una única victoria, XP y avance. En finales regionales se derrota a dos enemigos consecutivos, se elige **uno** para intentar vincular y hay hasta **tres intentos** guardados. La elección no consume intento.
2. \`App.trial_action()\` guarda en \`commit_profile()\` la victoria, recibo de XP, registro de ruta, posible premio de stamina y checkpoint al pasar de \`battle\` a \`capture\`. La UI solo presenta estos datos; jamás calcula ni concede otra vez.
3. \`AftermathFlow\` distingue pasos persistidos \`victory\`, \`experience\`, \`choose\`, \`duplicate\`, \`binding\`, y fases reales \`captured\`, \`escaped\`, \`defeat\`, \`retreated\`. \`Aftermath.step()\` y \`Aftermath.next()\` determinan el punto actual y su continuación. **Una sola pantalla visual no significa un solo checkpoint persistido.**
4. \`AftermathScreen\` presenta victoria por separado, transiciona automáticamente tras 1,25 segundos en condiciones normales, luego XP individual con \`ExperiencePanel\`, y después Libro, elección, duplicado o final. La cinemática de \`BindingStage\` dura actualmente 3,6 segundos; esos valores descriptivos no son límites propuestos.
5. \`ExperiencePanel\` y \`ExperienceSummary.frame()\` ya muestran distribución individual, varios niveles cruzados, cap regional y cambios de estadísticas. No resumirlo en una ficticia «XP total» idéntica para todos.
6. \`App.advance_aftermath(id, expected_step)\` valida y persiste el avance; \`App.finish_aftermath(id, revision)\` valida fase, ID y revisión; \`App.trial_action("capture")\` guarda intento y resultado **antes** de reproducir cinemática. Nunca reemplazar esto con navegación directa al mapa o escritura de \`campaign.aftermath\` desde una vista.
7. \`App.consume_experience()\` usa \`pending_experience_id\` efímero de presentación, distinto del recibo durable de \`Aftermath.receipt(campaign)\`. Al rediseñar, evitar consumir el indicador dos veces y detectar correctamente recibos existentes al restaurar una partida.

### 20.2 Composición propuesta A — resultados compactos en una sola superficie

\`\`\`text
┌──────────────────────────── VICTORIA ────────────────────────────────┐
│ [Fondo de la localización y criatura protagonista; nombres reales]  │
│                    Encuentro completado                              │
├───────────────────────── EXPERIENCIA ────────────────────────────────┤
│ [Entrenador]           +XP real   barra Nv. antes → después          │
│ [Miembro del equipo]   +XP real   barra Nv. antes → después          │
│ [...cada receptor que figura realmente en el recibo]                 │
│ Subida de nivel y estadísticas cuando corresponda                    │
│ [Ver detalles del progreso]  (control propuesto, no aprobado)        │
├────────────────────────── PREMIOS ────────────────────────────────────┤
│ Solo bonos/recompensas concedidos según recibo/estado guardado       │
├───────────────────────────────────────────────────────────────────────┤
│                       [Continuar al Libro]                           │
└───────────────────────────────────────────────────────────────────────┘
\`\`\`

No generar una pantalla de título «Victoria» que obligue a continuar hacia otra pantalla de XP. El reconocimiento y el progreso se presentan juntos, conservando una única identidad de lugar. La XP por integrante debe ser exacta, con visibilidad de niveles y topes; un nivel realmente alcanzado merece énfasis. Si no hay recibo de XP regional, omitir cifras inexistentes y avanzar según \`Aftermath.next()\`. El detalle expandible es **una opción por validar**, no una nueva regla.

### 20.3 Composición propuesta B — segundo momento de vínculo destacado

\`\`\`text
┌──────────────────────────── EL LIBRO ─────────────────────────────────┐
│ [Mismo ambiente]    [Libro protagonista]    [Karmany elegible]        │
│ Nombre y nivel real · probabilidad vigente · intentos restantes      │
│                                                                      │
│ Si hay dos rivales, elegir UNO antes del primer intento              │
│ Si la especie ya existe, decidir si vincular otro individuo          │
│                                                                      │
│         [Intentar vínculo]           [Dejarlo partir]                │
├───────────────────────────────────────────────────────────────────────┤
│  Al intentar: cinemática real / éxito / fallo / escape                │
└───────────────────────────────────────────────────────────────────────┘
\`\`\`

El Libro conserva escena propia y ritmo especial, pero no una navegación llena de pasos innecesarios. Se mantiene la selección irreversible de una criatura cuando el encuentro tiene dos rivales, el máximo de tres intentos, la probabilidad exacta según la mejora equipada y la posibilidad de renunciar voluntariamente conservando la victoria y XP. No inventar un nuevo método de captura, recurso, aumento de probabilidad o garantía por animación.

### 20.4 Estados, retorno y casos extremos

| Caso real | Composición visual | Invariante funcional |
|---|---|---|
| Victoria simple con XP | Resultado integrado y después Libro | Premio guardado previamente, una sola vez |
| Victoria sin recibo válido | Resumen sin XP inventada y decisión de Libro | No bloquear por indicador efímero ausente |
| Final regional con dos enemigos | En Libro aparece elección de uno | Solo una selección; sin dos capturas |
| Especie duplicada | Libro comunica posesión y consulta si se desea otra | No anunciar especie nueva |
| Fallo con intentos restantes | Libro se actualiza sin volver a mostrar XP | Contador persistido; sin nueva tirada automática |
| Tercer fallo | Escape y retorno | No existe cuarto intento |
| Vínculo logrado | Celebración de criatura realmente añadida | Colección y nivel reales, sin segundo commit desde UI |
| Renuncia voluntaria | Confirmación expresa antes de salir | Conserva victoria y XP; no abandona sin aviso |
| Derrota/retirada | Pantalla distinta de recuperación/retorno | Nunca mostrar Victoria, XP ni Libro |
| Partida cerrada durante resultados/Libro | Abrir vista del checkpoint efectivo | No repetir premios, elección ni intentos |
| Perfil histórico | Interpretar paso persistido vigente | Sin migrar guardado para cambio visual |

**Atrás Android:** priorizar diálogo crítico, cinematografía y estado activo. Estar en el Libro no equivale a renunciar al vínculo al pulsar Atrás: debe preservar o confirmar decisión. Si se interrumpe movimiento, no reejecutar \`App.advance_aftermath()\` ni \`trial_action()\`. La omisión de animación visual no omite la operación guardada.

### 20.5 Propuesta de flujo y contrato de integración seguro (NO autorizado)

\`\`\`text
COMBATE → último enemigo derrotado
     │ App ya guarda victoria + XP + premios + checkpoint
     ▼
[RESUMEN VISUAL INTEGRADO]
     │ Leer receipt y step. Avanzar por checkpoints persistidos válidos.
     ▼
[LIBRO DESTACADO]
     ├── rival doble: escoger uno y persistir selección
     ├── duplicado: decidir sobre otra instancia
     ├── intento: App.trial_action("capture") UNA sola vez
     │      ├── éxito: celebración → continuar
     │      ├── fallo: quedan intentos → actualizar Libro
     │      └── tercer fallo: escape → continuar
     └── renuncia: confirmar → conservar XP y salir
\`\`\`

**Riesgo técnico principal:** \`victory\` y \`experience\` son dos checkpoints persistidos aunque la UI nueva combine ambos en una superficie. Un adaptador debe avanzar mediante \`App.advance_aftermath()\` de forma **secuencial y guardada**, según el estado real, sin forzar directamente \`binding\`. No poner dos callbacks concurrentes para un solo botón; verificar \`encounter.id\`, \`revision\`, \`phase\`, paso efectivo y \`App.ui_epoch\`, y bloquear CTA repetidos/obsoletos. Si falla guardado, no afirmar visualmente que el paso se completó.

Reutilizar \`ExperiencePanel\` y muestreo multinivel, \`AftermathFlow\` como fuente de verdad y \`BindingStage\` como animación de Libro sin recalcular resultado. La construcción presentacional hipotética puede separar \`IntegratedResultsView\` y \`BindingFocusView\`, evitando nuevas variables persistidas. Coordinar con D-19 (paneles de combate) y D-18 (fluidez), sin mantener todos los controles activos invisibles ni dejar Tweens/Audio huérfanos.

### 20.6 Criterios de prueba futuros para D-20

| ID | Escenario | Resultado esperado |
|---|---|---|
| RES-01 | Victoria regional, primera y repetida | Una superficie de victoria/XP; bono único real |
| RES-02 | XP individual, subida multinivel, cap regional | Barras y cifras iguales al recibo persistido |
| RES-03 | Sin recibo o con perfil antiguo | No inventar XP ni bloquear checkpoint |
| RES-04 | Dos rivales y elección | Solo una criatura, elección persistida |
| RES-05 | Duplicado y 1–3 fallos | Aviso exacto, intentos correctos, sin cuarto intento |
| RES-06 | Éxito y salida sin vínculo | Una colección correcta, XP intacta |
| RES-07 | Derrota y retirada | Sin victoria ni XP ni Libro |
| RES-08 | Doble toque, pausa, reinicio, omisión de animación | Ninguna transacción duplicada ni callback vivo tras teardown |
| RES-09 | Atrás Android, fallo de guardado y texto grande | Mantiene checkpoint y explica error; lectura/acciones seguras |
| RES-10 | QA aislado, 1280×720, 960×540, movimiento reducido | Sin contaminación de partida, fuga de nodos o bloqueo visual |
| RES-11 | Prueba física: vídeo antes/después en móvil | Menos pantallas y pasos, Libro claramente destacado |

**Ritmo:** resultados ordinarios ágiles, subidas de nivel y primer vínculo con suficiente énfasis. Duraciones definitivas se deciden mediante comparación en teléfono; \`reduced_motion\` muestra el estado final inmediatamente sin retrasos artificiales.

## 21. Continuación — pendientes tras D-20

**D-20 resuelto a nivel de experiencia:** resultados integrados más vínculo destacado. La compactación de pantallas no significa compactación de transacciones.

**Todavía por decidir:** si los cambios estadísticos y niveles se ven siempre o bajo «Ver detalle» (como mínimo XP individual y nivel ganado serán visibles); selección de técnica de animación D-10 tras prototipos comparables; maquetas artísticas D-19+D-20 y requisitos de pantalla móvil; rutas opcionales y pools variables; dificultad y stamina. No abrir un bloque de jugabilidad por estas decisiones UX.

**Siguiente revisión sugerida:** definir la jerarquía de información del resumen XP y preparar un piloto comparativo de animación de un personaje existente. \`PR26\` se mantiene **draft documental**, no se integrará a dev ni producirá APK por esta modificación.


## 22. Revisión tras prueba física Preview73 — simplificación del combate y posibles reglas nuevas

**Origen:** observaciones expresas del creador tras revisar la APK Preview73 del PR27. La candidata \`feature/ux-combate-resultados-continuos@6b8d61426eb1179a2311c7243affaf3df6baae25\` pasó la CI y produjo la release \`android-preview-73\`, pero **NO recibió aprobación «prueba correcta»**. PR27 sigue draft; su CI no implica aprobación del nuevo diseño.

### 22.1 UX solicitada: combatir sin navegación administrativa visible (D-21)

**Dirección expresamente solicitada (diseño visual):** ocultar controles ajenos a la decisión táctica. En primer plano dejar **acciones del Karmany**, **Entrenador** y **Equipo**; si el vínculo durante el combate resulta aprobado, también el **Libro** como acción táctica disponible. El escenario y las criaturas son protagonistas. No mostrar ayuda, Ajustes, opciones generales ni accesos redundantes de salida en el HUD.

**Composición conceptual, pendiente de maqueta y aprobación de la operativa del menú:**
- **HUD mínimo:** PS, enemigo, turno, estado y notificación breve de acción; acciones tácticas reales. El botón Atrás Android/«Pausa» abre un menú superpuesto sin cambiar de ruta ni instancia del encuentro.
- **Menú de pausa (fuera del HUD de combate):** Reanudar, Opciones, Ayuda, Reiniciar y Salir. **Estos nombres son intención UX, no semántica aprobada**:
  - *Reanudar*: cerrar la capa y recuperar el mismo \`encounter.id\`, \`revision\`, PS y turno.
  - *Opciones/Ayuda*: configuraciones o explicación en segundo nivel, retornando siempre al mismo combate. D-16 mantiene la ayuda bajo demanda; no mostrar tarjeta E5 automática sobre combate sin resolver compatibilidad.
  - *Reiniciar*: **no definido**: podría reiniciar pelea actual, volver al checkpoint antes de pagar entrada o reiniciar toda la aventura. Todas esas variantes tienen consecuencias distintas sobre stamina, HP, random, rewards y guardados. No implementar un botón con semántica arbitraria.
  - *Salir*: **no definido**: volver a Inicio conservando encuentro, ir al mapa conservándolo o abandonar definitivamente la pelea. El motor distingue \`retreat\` de navegación sin abandono; no fusionarlos.
  - *Pausa real*: definir si se suspende \`response_timer\`, SFX, animaciones y taps durante el menú. La pausa debe mantener colas de respuesta y no conceder otra acción al reanudar, incluso después de ir a segundo plano.
- **Opciones ya visibles en Preview73:** \`TrialUI._build()\` crea «Volver», «Opciones» y \`ContextHelp\`; \`_battle()\` presenta acciones \`golpe/guardia/insignia\`, Entrenador/Detalles/Equipo. \`_options_menu()\` usa \`AcceptDialog\`. Esta dispersión explica la queja de espacio y navegación.
- **Decisión pendiente:** «Detalles» ya fue aceptado como panel sobre combate en D-19. La nueva preferencia «solo habilidades, Equipo y Entrenador» sugiere mover Detalles a Entrenador/Equipo o Pausa→Opciones. Confirmar destino antes de eliminarlo: sigue siendo necesario mostrar cooldowns y estados de técnicas sin obligar al jugador a abandonar combate.

### 22.2 Mecánica propuesta del Libro: vincular mientras el rival sigue vivo (D-22, CAMBIO CANÓNICO)

**Petición del creador:** permitir intentar vínculo en pleno combate; si el Karmany salvaje queda debilitado a 0 PS/derrotado, ya no puede capturarse.

**Choque con canon vigente:** \`DOCUMENTO_MAESTRO_ANDROID.md\` §5 y anexos; el motor \`TacticalEncounter.valid()\` exige \`enemy.hp == 0\` en \`capture/captured/escaped\`, y \`App.trial_action()\` concede victoria y XP al entrar a \`capture\` tras último rival derrotado. Finales regionales ofrecen elegir uno de **dos derrotados** para un vínculo posterior. La captura durante batalla no puede representarse simplemente moviendo el botón: modificaría invariantes, transacciones de campaña, checkpoints \`AftermathFlow\`, recompensas, economía de encuentro, balance, guardados históricos y regresiones.

**Consecuencias de diseño por resolver antes de código:**
1. ¿Intentar vínculo consume la acción del Karmany del turno compartido, una resonancia del entrenador o una acción independiente? ¿Ante fallo el rival contraataca?
2. ¿El intento de vínculo puede hacerse con el rival a cualquier PS mayor que cero? El Libro actual usa probabilidad por rareza/mejora; **no** introducir bonificación por PS restantes sin contrato nuevo.
3. ¿Éxito termina encuentro y acredita victoria, XP y progreso regional aunque el rival no haya sido derrotado? O ¿captura y victoria son resultados distintos? Sin respuesta, no se pueden mantener XP y ruta de forma coherente.
4. ¿Qué sucede después del tercer fallo cuando el rival permanece vivo? El contrato actual termina en escape; debe definirse si escapa, continúa el combate o se bloquea solo Libro.
5. En jefes/finales de dos enemigos consecutivos, ¿se intenta vínculo en el primer rival, solo contra el último, o después de decidir cuál? No es válida la selección histórica entre dos ya derrotados.
6. ¿Qué ocurre con Karmany salvajes no elegibles por Libro y con un rival derrotado antes de usar Libro? No provocar pantalla vacía ni encuentro perpetuo.
7. Migraciones: no reinterpretar capturas guardadas de Preview32/E2 ni borrar datos vigentes. Diseñar política de compatibilidad y fixtures antes de editar motor.

**Estado D-22:** solicitud de cambio de reglas recibida. **No aprobada como contrato implementable** porque faltan semánticas de turno, victoria/XP, finales dobles y fallos. No modificar \`tactical_encounter.gd\`, \`app.gd\`, \`capture_session.gd\`, \`book_capture_policy.gd\`, \`aftermath_flow.gd\`, \`data/\` ni probabilidades hasta resolverlas expresamente.

### 22.3 Roles propuestos: Karmany ofensivo y entrenador de soporte (D-23, CAMBIO CANÓNICO)

**Petición:** Karmany con dos habilidades básicas visibles —**Golpe** y **Ataque especial**—; efectos como curación o control proceden únicamente de resonancias del entrenador/árbol.

**Choque con canon vigente:** las fichas aprobadas de \`data/tactical_combat.json\` y el documento maestro §7 definen acciones \`golpe\`, \`guardia\` e \`insignia\`, con técnicas especiales de diversos tipos. Ejemplos reales: **Tanugami** cura y protege; **Kitsunibi** debilita; **Sakuromushi** ataca, releva al siguiente activo y le da bonificación temporal. Quitar apoyo/control a las Insignias o eliminar \`guardia\` cambia 13 especies y el contrato E1/E2 de Sakuromushi, así como pruebas y dificultad.

**Aspectos por decidir:**
- ¿Las Insignias actuales se convierten en «Ataque especial» **conservando efectos secundarios**, o se rediseñan como ataque de daño puro? La segunda opción requiere definir reemplazos canónicos por especie y reequilibrar, no es un cambio de etiquetas.
- ¿\`guardia\` deja de existir completamente, queda como acción común secundaria, o pasa a ser una resonancia de Ezel? No inventar resonancias ni puntos de árbol.
- ¿Qué hacer con la curación/protección/debilitamiento/relevo actualmente particulares de cada Karmany? Antes de eliminar mecánicas históricas estables, preservar una matriz de migración por especie aprobada.
- La división entre entrenador y Karmany ya existe como turnos compartidos con resonancia opcional antes de habilidad del Karmany. Si el nuevo Libro es una acción adicional, definir cómo interactúan los tres cupos para no regalar turnos extra.

**Estado D-23:** preferencia de diseño explícita, **aún no contrato canónico completo**. Prioridad a preservar balance/identidad de especie y tests hasta recibir reglas exactas. No degradar tests ni forzar conversiones genéricas.

### 22.4 Propuesta de fase y pruebas — sin implementación de reglas

**Bloque A (UX, tras definir pausa/Salir/Reiniciar):** HUD simplificado; un menú de pausa con foco, opciones/ayuda secundarias, flujo Atrás coherente y respeto a \`reduced_motion\`, texto grande y vista horizontal. Conservar los controles tácticos ya existentes durante la transición. Rama feature dependiente de PR27, sin integración directa en \`dev\`.

**Bloque B (reglas Libro):** contrato canónico nuevo para captura con rival vivo; simular encuentros individuales y finales de dos rivales, luego modificar conjuntamente motor/captura/guardado y reconstrucción UI, con regresiones de idempotencia de recompensas, doble toque, respuesta rival y legado.

**Bloque C (roles y técnicas):** matriz aprobada por especie y árbol de entrenador, revisión de efectos y recargas, migraciones si fueran necesarias, QA de diez o más encuentros y preservación de balance comprobable. No implementar como simples cambios de botones.

**Validación mínima cuando se autorice:** no hay controles secundarios permanentes; Pausa/Reanudar sin pérdida del encuentro ni acción; Atrás Android prioriza panel/pausa antes de abandonar; reinicio/salida no explotan stamina; Libro nunca captura criatura debilitada si esa regla se aprueba; tiradas y recompensas únicas; finales dobles válidos; Sakuromushi y técnicas de todas las especies alineadas con el contrato; partidas históricas recuperables; accesibilidad móvil y arte claro.

**D-24 RESUELTO:** el creador decidió que intentar vínculo **consume la acción del Karmany** y que, ante fallo, **puede responder el rival**. Esta definición es de reglas, no autoriza codificación hasta cerrar resultados de éxito, tercero fallido, finales dobles y migraciones. Siguiente bloqueo: definir si el vínculo exitoso cuenta como victoria con XP y progresión. En paralelo, definir «Reiniciar» y «Salir» antes de añadir esos botones.

**Nota de protección:** no marcar Preview73 como «prueba correcta» ni integrar PR27; el creador ha solicitado cambios adicionales. Esta v0.6 solo documenta hallazgos y conflictos, no implementa jugabilidad.


## 23. D-24 — Acción de Libro consume el turno del Karmany (APROBADA COMO DIRECCIÓN DE REGLAS)

**Fuente explícita (14/11/2026):** «Para el nuevo sistema de vínculo de Karmany Monsta Android elijo: A: consume la acción del Karmany y permite respuesta rival al fallar. Continúa definiendo las reglas pendientes sin implementarlas arbitrariamente».

**Decisiones verificables que sí quedan cerradas:**
1. El **Libro no es una acción extra**; intentar vínculo usa el cupo de **una acción del Karmany** en el turno compartido.
2. Una resonancia del entrenador, si está disponible, puede utilizarse **antes** del intento, siguiendo el flujo automático ya vigente; el Libro no gasta el cupo de resonancia por defecto.
3. Un intento de Libro **no puede convivir en el mismo turno** con Golpe, Insignia, Defensa/Guardia u otro ataque del Karmany. No se vuelve a habilitar el cupo si falla.
4. Si el vínculo **falla y sigue existiendo combate con enemigo vivo**, la respuesta enemiga automática sigue siendo posible. No se conceden intentos gratuitos ni ataques extra por fallo.
5. La intención D-22 se mantiene: **vincular es una decisión antes de derrotar al Karmany salvaje**, no después de ponerlo fuera de combate. La distinción entre «debilitado» como PS=0 y un posible umbral de PS bajo requiere aclaración antes de validar reglas exactas.
6. La decisión de interfaz es mostrar Libro como acción táctica durante el combate, no como una pantalla obligatoria posterior a la victoria. El antiguo diseño D-20 de Libro destacado después de vencer queda **subordinado/pendiente de rediseño** para este cambio de reglas; un Libro cinematográfico después de capturar puede conservarse como **celebración**, pero no como nueva oportunidad de intento.

**Importante:** aquí solo se aprueba **el gasto de cupo por intento y la respuesta rival ante fallo cuando corresponda**. No se han aprobado cambios de probabilidades, captura con PS bajo, agotamiento de intentos, premios por captura, nuevas técnicas ni persistencia.

### 23.1 Flujo objetivo parcial (NO contrato ejecutable todavía)

\`\`\`text
TURNO DE JUGADOR / rival vivo y elegible
    ├── Entrenador: resonancia opcional (si está disponible)
    │
    └── UNA elección del cupo Karmany:
        ├── Golpe o técnica actualmente permitida → efectos de combate
        ├── Cambio de Karmany → efecto de cambio vigente
        └── Libro / vínculo → gastar cupo y un intento registrado
             ├── fallo, enemigo sigue luchando → posible respuesta rival
             ├── éxito → RESULTADO POR DEFINIR (victoria/XP/cierre)
             └── tercer fallo → RESULTADO POR DEFINIR (escape/seguir)
\`\`\`

El concepto \`book_action\` es una etiqueta de diseño, **no una nueva acción del motor aprobada**, ni un cuarto propietario de turno. \`SharedCombatTurn\` distingue ya \`trainer\` y \`karmany\`; un intento debe ocupar exactamente \`karmany\`, sin llamar además a una técnica. En el motor actual \`TacticalEncounter.attempt_capture()\` solo funciona en fase \`capture\` posterior a enemigo HP=0, mientras \`TacticalEncounter.valid()\` prohíbe captura durante \`battle\`; \`CaptureSession.begin()\` exige un enemigo derrotado. Las tres invariantes y \`App.trial_action()\`/recompensas tendrían que rediseñarse **juntas** al implementar.

### 23.2 Consecuencias técnicas y riesgos identificados

| Dominio | Contrato actual verificado | Conflicto pendiente del nuevo Libro |
|---|---|---|
| Turno | \`SharedCombatTurn\` tiene cupos \`trainer\` y \`karmany\`; \`_finish_player()\` programa respuesta rival | Agotar cupo Karmany por captura fallida y permitir respuesta sin doble acción |
| Elegibilidad | \`capture\` tras PS rival 0 | Intento con enemigo vivo y estado de Libro definido; criterio exacto para no elegible |
| Resultado | Victoria/XP al último enemigo derrotado en \`App.trial_action()\` | Si se captura un enemigo vivo, ¿cuenta victoria y otorga XP? |
| Intentos | \`CaptureSession\` máximo 3; tercer fallo \`escaped\` después de victoria | ¿Tercer fallo hace escapar al salvaje inmediatamente o se continúa peleando sin Libro? |
| Final doble | Dos enemigos consecutivos; después de vencer al segundo se elige un derrotado | ¿En cuál de los dos se ofrece Libro? ¿Vincular antes altera el recorrido y selección única? |
| Persistencia | \`capture\`/checkpoint \`AftermathFlow\` guardado entre intentos | Se necesita guardar intentos durante \`battle\` sin corromper guardados E2/Preview32 |
| UI | PR27 integra victoria+XP y Libro posterior | El Libro será acción en combate; segundo momento podría ser presentación de resultado, no intento |

**No reinterpretar automáticamente el tercer intento como respuesta rival**, ni el éxito como victoria, ni la captura como terminación del combate; son decisiones de reglas aún pendientes.

### 23.3 Preguntas ordenadas para cerrar el contrato sin arbitrariedad

**Q1 — resultado de captura exitosa (primera decisión necesaria):**
- **A. Captura exitosa cuenta como victoria de ese encuentro**, acredita la XP/progreso y permite continuar; para finales dobles falta acordar tratamiento separado.
- **B. Captura exitosa añade el Karmany pero no cuenta como victoria/progreso de la etapa**; la ruta puede exigir volver a vencer otro encuentro, con riesgo de experiencia frustrante.
- **C. Victoria de captura y victoria de combate son estados diferenciados**; sus recompensas y avance necesitan una tabla canónica completa antes de programar.

**Q2 — después del tercer intento fallido:** ¿el Karmany escapa, termina el encuentro y no hay victoria, o permanece vivo/combatiendo y el Libro queda bloqueado? Debe reconciliarse con D-24, respuesta rival y guardado.

**Q3 — finales regionales de dos enemigos:** ¿solo se puede vincular a uno, y en qué momento, para que una captura temprana no evite/recompense indebidamente el segundo enemigo? No construir solución por inferencia.

**Q4 — criterio de elegibilidad y porcentaje:** confirmar que «debilitado/derrotado» significa **0 PS** y no un umbral positivo. Conservar porcentajes del Libro hasta aprobación distinta; no asumir que menos PS aumenta el éxito.

**Q5 — consecuencias de pausa:** si hay rival pendiente, definir Reanudar/Reiniciar/Salir sin cobrar stamina otra vez ni perder XP/turnos. D-21 no autoriza semántica por defecto.

**Q6 — dos habilidades de Karmany:** Golpe + Ataque especial; falta matriz aprobada por especie para reemplazar Guardia/Insignia y transferir soporte a entrenador. No tocar E1/E2/Sakuromushi.

### 23.4 Criterios de futura implementación (una vez aprobadas las respuestas)

- Un solo intento por cupo Karmany; segundo toque rechazado por \`encounter.id\`, \`revision\`, \`turn_id\` y selección objetivo.
- Resonancia opcional **primero** y Libro en lugar de técnica Karmany, sin permitir resonancia tardía.
- Si falla y se continúa combatiendo, respuesta rival exactamente una vez; pausa/reanudación no cancela ni duplica esa respuesta.
- PS 0 no presenta opción de Libro si así queda aprobado el criterio de debilitamiento.
- Guardado de intento en el mismo flujo transaccional; fallos de escritura no consumen intentos ni acciones en RAM.
- No conceder XP ni abrir siguiente localización sin regla de victoria expresamente aprobada.
- Cierre/apertura y perfil QA conservan rival, HP, intentos, turno y respuestas pendientes.
- Regresiones nuevas de finales dobles, victorias repetidas, migraciones y no duplicación de recompensas. No debilitar tests ya válidos: adaptar contratos solo con aprobación canónica explícita.

**Estado de ejecución:** SOLO Plan Director v0.7. No cambios en PR27/Preview73, \`dev/karmany-core\` ni \`main\`. No crear APK de reglas en este punto. Primero seleccionar Q1 y continuar secuencialmente por Q2–Q6.
