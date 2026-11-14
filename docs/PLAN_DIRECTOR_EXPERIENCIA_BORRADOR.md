# Karmany Monsta Android · Plan director de experiencia (BORRADOR)
**Versión:** 0.2 · 14 de noviembre de 2026 (rondas 1 y 2; auditoría de fluidez)  
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

**Recomendación técnica provisional:** conservar semántica de `NavigationHistory` y transacciones de `App`; demostrar la alternativa **A** sobre un flujo real (mapa → localización → combate) y, con evidencia de fricción residual, evaluar un **shell B** parcial. No adoptar C por defecto. La transición deberá ser interrumpible/cancelable, respetar movimiento reducido, accesibilidad, gesto Atrás y reanudación segura. Los guardados actuales no deben adquirir datos puramente visuales.

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

## 11. Opciones todavía no resueltas (ronda 3 focalizada)

1. **Transiciones:** elegir A ligera como primer experimento, B shell persistente como objetivo, u otra opción. Una propuesta arquitectónica no equivale a autorización para programarla.
2. **Diseño de escena:** escoger cuánto tiempo debe permanecer la ilustración del mundo a la vista cuando se navega a equipo, ayuda o resultados; valorar continuidad contra legibilidad.
3. **Resultados:** decidir si la secuencia victoria → XP → Libro debe conservar todos los pasos o compactarse en resultados habituales, manteniendo momentos especiales.
4. **Rutas opcionales:** especificar qué decisiones significativas debe ofrecer una ruta secundaria, sin escribir aún misiones/recompensas ficticias.
5. **Comparación artística:** elegir la criatura piloto y el tipo de escena para evaluar técnicas, sin presuponer que un nuevo sprite está aprobado.
6. **Prioridad:** ¿probar primero transición/fluidez o nueva muestra de sprite/animación? La prioridad declarada de arte se respeta, pero puede incluir primero un prototipo de transición breve para evaluar el contexto real.

## 12. Puerta de cierre y orden de trabajo revisado

**Se han cerrado las elecciones generales de las rondas 1 y 2**, salvo la técnica de animación que explícitamente requiere comparación. El Plan Director **no queda listo para aprobación de implementación**, porque faltan:
- una revisión visual real de pantallas y animaciones en teléfono/capturas,
- la selección de técnica mediante comparativas controladas,
- reglas concretas de rutas secundarias y encuentros variables, IA y ritmo de stamina,
- decisión sobre la experiencia de transición y aceptación de la arquitectura,
- criterios cuantificados a partir de una sesión de pruebas en dispositivo real.

Orden recomendado para decidir, no implementar: (1) fluidez y composición de una secuencia completa; (2) muestras de sprite/animación comparables; (3) UI compacta/ayuda manual; (4) dificultad/comportamiento rival/colección; (5) rutas, encuentros variables y compatibilidad; (6) experimento de stamina. Después crear contratos técnicos en bloques medianos, con PRs separados y pruebas.

La propuesta de fases de la sección 6 queda **histórica y subordinada** a este orden. No mover PR21–25, ni modificar `main`/`dev/karmany-core` por el hecho de crear este documento.

**SIGUIENTE PASO:** creador responde la ronda 3 y aporta cuando le sea posible capturas o vídeo de un cambio de vista y de un ataque. Chat registra decisiones y compara alternativas sin modificar gameplay.  
**RESPONSABLE:** CHAT (análisis y documento); creador (selección de rumbo/validación visual).  
**INSTRUCCIÓN PARA CONTINUAR:** Revisa `feature/plan-director-experiencia-juego/docs/PLAN_DIRECTOR_EXPERIENCIA_BORRADOR.md` y PR26 en GitHub; comprueba HEAD/PR21–25, lee maestro y el contrato R1.1. Continúa con la ronda 3, audita imágenes o vídeos suministrados y, tras decisiones explícitas, genera especificación implementable aislada. No cambiar código, canon, guardado, estadísticas, sprites ni PR pendientes; mantener la rama solo documental hasta nueva autorización.