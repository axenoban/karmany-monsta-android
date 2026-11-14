# Karmany Monsta Android · Plan director de experiencia (BORRADOR)
**Versión:** 0.1 · 14 de noviembre de 2026  
**Estado:** diagnóstico y consulta, **NO aprobado como implementación ni modificación canónica**.  
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

## 7. Ronda 2 — decisiones que faltan (pendientes)

- R2-01: ¿Conservar y modernizar la silueta de los personajes actuales o rediseñar la identidad visual?
- R2-02: ¿Animación por partes 2D, por fotogramas o técnica híbrida? Se debe evaluar una muestra técnica antes de producir todos los sprites.
- R2-03: ¿Dificultad basada en anticipar al rival, composición de equipo/afinidades documentadas o desafíos de preparación? No añadir mecánicas sin aprobación.
- R2-04: ¿Rutas opcionales con progreso principal fijo, o bifurcaciones que alteran el recorrido?
- R2-05: ¿Encuentros aleatorios por zona, elección visible o mezcla con encuentros ancla? Elegibilidad y especies pendientes de canon.
- R2-06: ¿Desarrollar la historia existente, rehacer la historia o limitar narrativa y favorecer ecología/descubrimiento?
- R2-07: ¿Qué información mínima debe mostrar permanentemente combate y exploración? Ayuda solo bajo demanda ya decidida.
- R2-08: ¿Qué pantallas considera el creador más débiles? Recoger capturas y notas concretas; auditar visualmente, no solo mediante código.

## 8. Puerta de cierre

El documento NO se considerará plan director definitivo hasta resolver las decisiones anteriores con el creador, auditar capturas reales de las pantallas y validar una muestra artística/jugable. El contenido canónico sigue sujeto al documento maestro y los datos aprobados. El plan se cerrará con criterios de aceptación, secuencia de integración y módulos afectados.

**Siguiente paso:** revisión conjunta con el creador de preguntas R2-01 a R2-08 y capturas de pantallas problemáticas.  
**Responsable:** CHAT para análisis/documentación; creador para decisiones de diseño.  
**Instrucción de continuidad:** En `axenoban/karmany-monsta-android`, lee `docs/PLAN_DIRECTOR_EXPERIENCIA_BORRADOR.md` de `feature/plan-director-experiencia-juego`, el maestro y PR21–25. Consulta las decisiones pendientes, revisa evidencias visuales y consolida un plan aprobado; no implementes nuevas reglas, canon, IA, sprites ni merges de ramas mientras el diseño siga abierto.
