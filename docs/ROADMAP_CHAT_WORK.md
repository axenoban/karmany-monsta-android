# KARMANY MONSTA · ANDROID
## Roadmap coordinado de Chat + Work
**Versión de planificación:** 1.1 · **Documento original del 15 de octubre de 2026, incorporado íntegro y actualizado operativamente**  
**Objetivo inmediato:** una alfa cerrada realmente jugable y evaluable por jugadores externos.  
**Objetivo posterior:** beta sólida y, mediante una decisión posterior, versión comercial publicable.

> **Regla principal:** ambos agentes pueden leer e investigar en paralelo; solo uno debe escribir o integrar un bloque funcional sobre el baseline común. Chat reduce trabajo preparatorio y de revisión; Work ejecuta implementaciones acotadas, exportación y regresiones.

## 1. Fotografía histórica del punto de partida

- **Repositorio:** `axenoban/karmany-monsta-android` (Godot 4.7.2, GDScript, 2D, Android).
- **Baseline jugable validado:** `dev/karmany-core` — HEAD `4d1817a84371` al hacer este diagnóstico; **Preview 29, v0.17.0**, código funcional `a3d5dfffb93d`. No fijar estos SHA como eternos: volver a leer GitHub antes de cada bloque.
- **`main`:** `9ef7af778ee5`; contiene solo inicialización. **No es una versión publicable.**
- **Rama de propuesta:** `feature/region-pacing-design` — `5d508937e2eb`; propone seis etapas en Jade y Bosque, XP revisada, rivales por relevo y cifras experimentales. **No equivale a una APK implementada.**
- **Ya funciona:** mapa cenital de cuatro encuentros de Jade, stamina, equipo de tres, cinco especies de combate, turnos, resonancias, Libro/vínculo, árbol, niveles/XP, animaciones básicas, sonidos, ajustes, guardado y recuperación.
- **Evidencia:** la CI de la Preview 29 aprobó 1.390 verificaciones Godot, tres Python, exportación, firma y auditoría. El usuario validó esa preview en dispositivo; **no hay validación equivalente de las propuestas regionales ni del último diseño de transiciones.**
- **Barrera conocida:** curva actual de Jade (25 XP por victoria, 100 × nivel) exige 180 victorias teóricas del nivel 1 al 10. La propuesta reduce el grindeo mediante bonos por primera victoria, pero los cambios siguen fuera del juego.

**Aviso: este apartado documenta la situación inicial, no el estado vivo. Antes de actuar leer [ROADMAP_ESTADO.md](ROADMAP_ESTADO.md), consultar PR/CI/ramas reales y respetar los bloqueos activos.**

**Fuentes operativas obligatorias:** `AGENTS.md`, `docs/CONTINUIDAD.md`, `docs/BASELINE_VALIDADO.md`, `docs/PROPUESTA_REGION_21.md` y `docs/COMBATE_REGION_21_PROPUESTA.md` (estos últimos, desde la rama de propuesta). Ver además `docs/PRUEBA_ANDROID_20.md` y `data/level_progression.json`.

## 2. Qué significa «listo para testers»

**Meta A · Alfa cerrada / primera prueba con jugadores.** Una persona ajena al desarrollo puede instalar la APK, comenzar, aprender los controles, explorar seis ubicaciones diferenciadas de Valle Jade, disputar una final de dos rivales consecutivos, ganar XP razonablemente, mejorar equipo/Libro, intentar vínculos, perder y recuperarse, guardar, salir y regresar sin ayuda del creador. El combate, la experiencia y el vínculo mantienen una presentación coherente. No requiere Bosque del Velo para esta primera prueba.

**Meta B · Beta de contenido.** Bosque del Velo plenamente jugable (previa aprobación de cifras y arte), dos regiones enlazadas, dificultad regional, más variedad de especies, corrección del feedback de la alfa, mejores objetivos de sesión y rendimiento probado en distintos equipos.

**Meta C · Candidata comercial.** Contenido suficiente para el alcance aprobado, presentación consistente, experiencia de juego equilibrada, compatibilidad Android, documentación legal/comercial y distribución/firma apropiada. La historia extensa, monetización y nuevas regiones **no se inventan ni se convierten en requisitos implícitos.**

**Fuera del objetivo de alfa:** multijugador, servidores, tienda, anuncios, economía no aprobada, nuevas rarezas jugables, evolución, cientos de especies o una campaña narrativa completa. Se decidirán más adelante solo si aportan valor demostrable.

## 3. División de responsabilidades: dónde ahorrar cupo

| Actividad | Dueño predeterminado | Modelo inicial sugerido | Regla de salida |
|---|---|---|---|
| Auditar canon, analizar reglas y balance, formular opciones | **Chat** | GPT-6 Medium/High | Decisiones explícitas; sin escribir valores experimentales como canon |
| Redactar guiones de prueba, textos aprobados y criterios de aceptación | **Chat** | GPT-6 Medium | Documento o comentario de PR, no alterar scripts activos |
| Revisar PR, detectar riesgos y evaluar CI/logs | **Chat** | GPT-6 High en casos difíciles | Dictamen y lista priorizada; no integrar sin aprobación |
| Programar componentes/regiones/UI y tests automatizados | **Work** | **Sol, esfuerzo Medio** | Rama feature, tests, commit, enlace de APK si procede |
| Migraciones delicadas, turnos de enemigos y fallos persistentes | **Work** | Sol Alto; escalar a **Astra Bajo/Medio** si aporta valor | Demostrar preservación del baseline y no duplicación de recompensas |
| Corregir un fallo simple, aislado y de bajo riesgo | Chat o Work, **uno solo** | Chat Medium o Sol Bajo | Rama exclusiva, test focalizado, verificación |
| Compilar, firmar, publicar preview y revisar dispositivos | **Work + jugador humano** | Sol Medio; Astra solo para bloqueos complejos | CI verde + APK instalable + validación física explícita |

**Política de modelos:** Sol es la opción normal de ejecución. Astra se reserva para dificultades que Sol no resuelva bien en una pasada o para cambios de estado/arquitectura muy sensibles. No gastar Astra en documentación, consultas rutinarias o tareas pequeñas. Un mayor esfuerzo no arregla instrucciones ambiguas ni acceso faltante. Si está disponible GPT-6.1 Sol, comparar primero su resultado con Sol habitual. El selector y el cupo reales se consultan en **Configuración → Uso**; Work y Codex comparten cupo, independiente del de Chat. No hay un coste fijo por etapa ni garantía de mensajes.

## 4. Protocolo para que ambos NO se estorben

1. **Una fase funcional activa y un responsable de escritura.** Solo una rama `feature/*` tiene permiso operativo para modificar código de producción durante ese bloque. Chat puede hacer análisis/revisión y preparar archivos locales sin entrar en esa rama.
2. **Lecturas paralelas sí; escrituras concurrentes solo si los archivos son totalmente disjuntos.** Incluso en ese caso, **no** editar simultáneamente `docs/CONTINUIDAD.md`, `AGENTS.md`, manifiestos compartidos, versionado o datos de reglas. Chat puede trabajar con reportes externos o en `docs/reviews/*` en otra rama, integrados después.
3. **Antes de escribir:** verificar ramas/HEAD, commits, diff `dev..feature`, PR abiertos, CI y archivos afectados. Confirmar que nadie está implementando el mismo bloque; si HEAD cambió, rehacer plan antes de editar.
4. **Criterio único de integración:** commit/PR en `feature/*` → CI y revisión → APK si hay cambio visible → prueba local del creador → declaración «prueba correcta» → integración a `dev/karmany-core` por fast-forward si la historia lo permite. Nunca forzar ni reescribir historia. `main` solo para lanzamientos aprobados.
5. **Cada entrega obliga a un registro:** `docs/CONTINUIDAD.md` actualizado por el agente escritor, SHA, rama, alcance, CI, APK/release y prueba pendiente. Separar «test automático verde» de «prueba física correcta».
6. **Una sola operación de integración a la vez.** Chat no debe hacer merge mientras Work desarrolla otra rama sobre el mismo baseline; primero sincronizar y revisar. No usar un PR cerrado como prueba de que su contenido esté en `main`.
7. **Si hay choque:** detener cambios, comparar ramas y archivos, decidir dueño, incorporar solo commits verificados. Nunca resolverlo descartando guardados, silenciando asserts o aumentando watchdogs.

**Contrato de cada bloque (8–15 componentes cuando tenga sentido):** 1 objetivo, 1 rama, archivos permitidos, archivos protegidos, criterios comprobables, pruebas automáticas, prueba Android y siguiente paso. Si el bloque excede una revisión razonable, partirlo por frontera funcional, no por cada botón.

## 5. Mapa general de etapas

| Etapa | Resultado | Chat | Work | Salida / puerta |
|---|---|---|---|---|
| **E0** · Coordinación | Baseline y reglas de trabajo unificados | Principal | Solo verificación opcional | Sin cambiar funcionalidad |
| **E1** · Decisiones mínimas | Paquete aprobado para expandir Jade | Principal | No programar reglas | **Aprobación del creador** |
| **E2** · Motor regional | Rutas, XP por etapa, reservas rivales, migraciones | Especificación y auditoría | Principal · Sol/Astra selectivo | Tests + integridad de guardados |
| **E3** · Jade completo | Seis etapas, dos especies nuevas, final por relevos | Canon, arte y test | Principal · Sol | Primera campaña corta jugable |
| **E4** · Continuidad visual | Combate/derrota/XP/vínculo en un escenario coherente | Flujo UX y revisión | Principal · Sol | Sin saltos de tamaño/fondo |
| **E5** · Entrada de jugador | Tutorial contextual, señales claras, recuperación de derrotas | Textos/test de comprensión | Principal · Sol | Partida sin explicación externa |
| **E6** · Alfa cerrada | APK estable + rondas reales de playtest | Principal para QA | Correcciones acotadas | **HITO A: jugadores externos** |
| **E7** · Bosque del Velo | Segunda región y progreso 10–15 | Canon y balance | Principal · Sol/Astra selectivo | Dos regiones completas |
| **E8** · Profundidad y pulido | Variedad y retención sustentadas en feedback | Evaluación y prioridades | Principal · Sol | Sin añadir mecánicas sin aprobar |
| **E9** · Beta | Pruebas ampliadas, regresión, compatibilidad | Plan/triage | Principal | **HITO B: beta** |
| **E10** · Publicación | Preparación comercial técnica y editorial | Revisión de alcance | Work para build/release | **HITO C: go/no-go** |

## 6. Detalle ejecutivo de cada etapa

### E0 · Sincronización y gobierno del repositorio
**Chat:** confirmar lista de decisiones y separar validado/propuesto; preparar matriz de pruebas/archivos. **Work:** solo si falta alguna comprobación automática, inspeccionar CI y detectar riesgos, sin reescribir documentos históricos. **Hecho cuando:** el HEAD de `dev`, rama activa, encargado del próximo bloque y la prueba siguiente están escritos en un ticket o plan. **Prioridad:** obligatoria antes de cualquier otra fase.

### E1 · Aprobar lo mínimo para Jade y validar el relevo experimental
**Chat:** presentar en una sola tabla revisable: cifras experimentales de **Sakuraneko e Inubari**, XP primera victoria/repetición por etapa, stamina 10/10/10/10/10/30, captura al nivel del encuentro, vínculo elegido en final, y política de migración/bonos para partidas anteriores. La dirección de seis etapas, enemigos crecientes, combate final de dos relevos y curva progresiva **ya fue aceptada**: no pedirla otra vez. **Work:** no implementar cifras ni modificar canon hasta aprobación explícita. **Decisiones aprobadas el 15/10/2026:** Jade de seis etapas, XP, stamina, dos especies experimentales, vínculo final, nivel de captura y política de conservación de partidas. **Aún pendiente:** prueba humana satisfactoria de la Insignia de Sakuromushi en Preview34; el comentario sobre ver solo el bonus no equivale a aprobación ni a fallo reproducido. Consultar `docs/E1_JADE_RELEVO_2026-10-15.md` en la rama `feature/e1-jade-relay`, más `ROADMAP_ESTADO.md` para la situación viva. E1 no se integra a dev por CI verde solamente. El Bosque puede esperar.

### E2 · Preparar el motor para más de cuatro lugares
**Work:** generalizar rutas por región y encuentros, niveles rivales fijos por etapa, recompensa normal+bono único, resolución de equipo enemigo secuencial, una recompensa por victoria final, persistencia segura, capturas al nivel encontrado y ventana de XP capaz de mostrar múltiples subidas. Proteger encuentros abiertos, guardados antiguos, Libro, habilidades y stamina. **Chat:** revisar riesgos y casos borde antes y después del PR. **Hecho cuando:** CI confirma que nadie cobra dos veces, no hay ataque extra al relevo, los datos antiguos abren y las cuatro etapas antiguas siguen reconocidas. **No** hacer todavía Bosque.

### E3 · Completar Valle Jade
**Work:** añadir puntos 5 y 6 sin cambiar los cuatro ID existentes; integrar fichas, sprites y animaciones aprobados de Sakuraneko e Inubari; seis fondos/puntos legibles; rivales a niveles por etapa; final de dos enemigos consecutivos; curvas y costes aprobados; vínculo posterior y rutas de victoria/derrota. **Chat:** revisar correspondencia con enciclopedia e instrucciones artísticas, proponer test de balance con equipos iniciales y mixtos. **Hecho cuando:** una partida nueva recorre Jade completo, y una partida antigua continúa sin reiniciarse.

### E4 · Experiencia visual continua
**Work:** mantener fondo de combate ocupando de forma coherente la pantalla en daño, derrota, XP, selección de reserva y vínculo; usar controles flotantes compactos e iconos reconocibles con texto accesible; no reducir el escenario súbitamente ni sustituirlo por paneles gigantes. Diferenciar visualmente derrota aliada, salvaje y rival; conservar modo de movimiento reducido, accesibilidad y estado. No rehacer mecánicas en esta fase. **Chat:** diseño de recorrido en 6–8 pantallas/estados y criterios de interacción. **Hecho cuando:** el tester entiende qué pasó y qué puede hacer sin saltos visuales ni botones fuera de pantalla.

### E5 · Primera sesión autónoma
**Work:** agregar tutorial contextual **solo** con mecánicas aprobadas; destacar stamina antes de gastar, vida actual, turno, habilidad insignia, resonancia opcional, captura y regreso al mapa. Incorporar señales de error y recuperación de una derrota; revisar volver atrás, interrupciones, texto grande, audio y reanudar. **Chat:** microcopias, checklist de comprensión, prueba con alguien que nunca haya jugado. **Hecho cuando:** una persona inicia y termina al menos una etapa sin asistencia verbal.

### E6 · Congelar y probar la alfa
**Chat:** organizar 5–10 testers voluntarios, con dispositivos diversos, cuestionario corto y registro de errores priorizados P0/P1/P2. **Work:** exclusivamente correcciones reproducibles, mejora focalizada del rendimiento, pipeline/release y regresiones. Congelar nuevas reglas y contenido. **Criterios sugeridos para considerar exitosa la ronda:** 0 bloqueos P0, ninguna pérdida de partida reproducible, tutorial comprensible, ruta de Jade completada por varios testers y problemas P1 identificados con reproducción. **Hecho cuando:** APK de alfa, notas de versión, SHA y resultados de la ronda quedan archivados. No confundir «publicamos APK» con «aprobó la alfa».

### E7 · Segunda región: Bosque del Velo
**Chat:** validar las **seis** especies propuestas y sus cifras experimentales, fondos, niveles 10–15, acceso, costes, recompensas y diferencias con Jade. **Work:** reutilizar motor, no duplicarlo; seis etapas diferenciadas, conexión entre mapas, desbloqueo y final por relevos; regresiones completas de topes, guardados, compras y capturas. **Hecho cuando:** una partida puede pasar de Jade al Bosque con progreso coherente. **No** diseñar la tercera región todavía.

### E8 · Profundidad jugable sustentada en pruebas
**Chat:** medir quejas y oportunidades reales: variedad de decisiones, duración de combate, motivación para capturar, ritmo de progresión y claridad de objetivos; priorizar una mejora de valor demostrado. **Work:** implementar solo mejoras aprobadas, por módulos separados: IA rival más interesante, eventos aprobados, microescenas narrativas existentes, ambientación musical, comparador de criaturas o herramientas de equipo. **Hecho cuando:** una nueva prueba muestra que el cambio resuelve un problema concreto, no solo añade menús.

### E9 · Beta ampliada y estabilidad
**Chat:** preparar plan para 15–30 participantes si hay disponibilidad y recoger resultados voluntarios, sin habilitar telemetría intrusiva. **Work:** optimización en equipos de menor rendimiento, rotación/tamaños Android, accesibilidad, consumo de batería, compatibilidad de partidas, cierres abruptos, reanudación y limpieza de deuda técnica; CI completa y release candidata. **Hecho cuando:** los P0/P1 están resueltos y existe un listado explícito de P2 diferidos.

### E10 · Preparación publicable (solo después de decidir alcance)
**Chat:** plan editorial/comercial, identidad, materiales, privacidad, clasificación por edades y política de distribución aplicable; validar con fuentes oficiales vigentes. **Work:** configuración de firma final separada de previews, AAB/APK según canal, versionado, diagnóstico seguro y builds reproducibles. **Hecho cuando:** el creador aprueba el alcance comercial, pasa la validación reglamentaria y publica una candidata sin alterar el baseline estable. `main` recibe únicamente la versión aprobada.

## 7. Prompts reutilizables para Chat y Work

**Norma:** cada prompt se ejecuta en su conversación respectiva. Sustituir `E[N]` y los nombres concretos. No pegarle a Work toda la conversación histórica; GitHub es la referencia actual. Los prompts específicos de más abajo complementan estos contratos, no los sustituyen.

### Prompt CH-0 · Arquitecto/analista antes de un bloque (Chat)

```text
Proyecto: axenoban/karmany-monsta-android.
Eres arquitecto y revisor de Karmany Monsta, no el escritor activo del bloque.
Verifica ahora GitHub: ramas, HEAD de dev/karmany-core, rama feature activa,
commits/PR/CI, docs/ROADMAP_ESTADO.md y docs/CONTINUIDAD.md. No presupongas que el historial del chat
es más reciente que el código. Analiza E[N] del roadmap y entrega:
1) decisiones aprobadas vs. pendientes (sin inventar canon ni balance);
2) contrato del bloque: alcance, archivos candidatos, riesgos y exclusiones;
3) criterios de aceptación y pruebas Android/guardado/regresión;
4) prompt final acotado para Work (8–15 componentes si resulta razonable).
No edites scripts ni CONTINUIDAD.md si Work posee una rama activa.
```

### Prompt WK-0 · Ejecución estándar de fase (Work · Sol Medio)

```text
Trabaja en axenoban/karmany-monsta-android. Ejecuta SOLO la etapa E[N]
del roadmap aprobada. Antes de tocar archivos, lee AGENTS.md, docs/ROADMAP_CHAT_WORK.md,
docs/ROADMAP_ESTADO.md, docs/CONTINUIDAD.md y el documento específico del bloque y confirma el
estado REAL: main, dev/karmany-core, rama feature, HEAD, historia, PR y CI.
Si hay otra rama funcional activa que toque tus archivos, DETENTE y reporta
el conflicto. Crea o reutiliza una única feature/* desde la base validada.
Respeta lo aprobado; no inventes técnicas, cifras, especies ni narrativa.
Conserva guardados antiguos, encuentros activos y pruebas ya aprobadas.
Implementa un bloque medianamente cohesivo, con tests de casos límite,
corre primer error real, importación/CI y APK cuando corresponda.
No hagas force push, merge ciego ni cambios en main. Actualiza
CONTINUIDAD.md y ROADMAP_ESTADO.md con SHA, pruebas y validación pendiente; entrega:
HECHO / COMMIT-RAMA / CI / APK / PRUEBA LOCAL / RESULTADO ESPERADO /
RIESGOS / SIGUIENTE PASO. NO integres a dev sin «prueba correcta».
```

### Prompt CH-1 · Revisión independiente tras la implementación (Chat)

```text
Audita el PR y la rama feature/* de E[N] contra la base real en GitHub.
No hagas commits. Compara requisitos aprobados, diff, pruebas, CI,
compatibilidad de partida, rendimiento y UX. Separa defectos probados,
riesgos plausibles y preferencias. Da un dictamen APTO / APTO CON
CONDICIONES / NO APTO y un test físico de máximo 10 pasos.
No atribuyas resultados físicos a pruebas automatizadas.
```

### Prompt WK-1 · Corrección y cierre tras prueba local (Work · Sol Medio)

```text
El creador informa [RESULTADO DE PRUEBA] sobre E[N] en [APK/SHA].
Verifica primero que la rama y el SHA siguen siendo los mismos.
Si falló, reproduce y arregla la primera causa real sin debilitar tests.
Si dice «prueba correcta», cierra documentación/test, comprueba CI,
integra por fast-forward a dev/karmany-core SOLO si es seguro, verifica
el nuevo HEAD, cierra PR, actualiza ROADMAP_ESTADO.md y prepara el siguiente bloque lógico sin
implementar reglas aún pendientes de aprobación. No cambies main.
```

### Prompt CH-2 · Test con jugadores (Chat)

```text
Diseña una sesión de prueba de Karmany Monsta para alguien sin experiencia
previa, basada solo en la APK y reglas verificadas. Entrega instrucciones
de instalación, seis tareas, cuestionario de máximo diez preguntas,
plantilla de reporte reproducible (dispositivo, versión, pasos, esperado,
real) y clasificación P0/P1/P2. Evita conclusiones no basadas en datos.
No agregues nuevas reglas al cuestionario ni al repositorio.
```

## 8. Instrucción EXACTA para arrancar cada etapa

| Inicio | Qué enviar a Chat | Qué enviar a Work |
|---|---|---|
| **E0** | «Ejecuta CH-0 para E0: sincroniza baseline, crea contrato y detecta escritor activo». | No necesario, salvo verificación de CI. |
| **E1** | «Verifica Preview34 en `feature/e1-jade-relay`; diagnostica por qué el usuario vio un bonus pero no el relevo, sin suponer bug ni validación». | «Solo si se asigna: reproduce y corrige E1 en esa rama; no iniciar E2 mientras se pruebe E1». |
| **E2** | «Con decisiones E1 aprobadas, diseña pruebas de migración, bonos únicos y relevos enemigos; no cambies código». | «Ejecuta WK-0 para E2. Implementa motor regional reusable, no contenidos de Bosque». |
| **E3** | «Verifica canon y arte de Jade, propone 10 pruebas de recorrido/nivel/captura». | «Ejecuta WK-0 para E3. Añade sexta etapa, dos nuevas especies y final; respeta IDs 1–4». |
| **E4** | «Especifica flujo visual continuo batalla→derrota→XP→vínculo y accesibilidad; no edites UI». | «Ejecuta WK-0 para E4. Implementa fondo continuo y controles flotantes, sin tocar balance». |
| **E5** | «Redacta microtutorial y test de comprensión usando solo reglas aprobadas». | «Ejecuta WK-0 para E5. Integra tutorial contextual y reanudación, sin narrativa nueva». |
| **E6** | «Ejecuta CH-2 para E6 y prioriza resultados de testers». | «Corrige exclusivamente incidencias P0/P1 reproducibles de la alfa; CI y nueva APK». |
| **E7** | «Prepara aprobación de seis especies/reglas del Bosque; compara contra simulaciones existentes». | «Con paquete E7 aprobado, ejecuta WK-0; expande motor existente al Bosque». |
| **E8** | «Agrupa feedback por problema y selecciona una mejora medible; pide autorización si cambia reglas». | «Implementa SOLO mejora E8 aprobada, con pruebas y sin ampliar alcance». |
| **E9** | «Produce matriz de beta y auditoría de incidencias abiertas». | «Optimiza, corrige y prepara build beta sin añadir contenido». |
| **E10** | «Prepara checklist comercial/legal vigente y dictamen go/no-go». | «Prepara release comercial solo con aprobación expresa del creador». |

## 9. Cómo se mide y se cierra una entrega

**Prueba técnica:** importación limpia de Godot, suite existente completa + pruebas nuevas focalizadas, cero errores nuevos de parser/runtime, CI verde, exportación/firma/auditoría y comparación con baseline. En particular: guardado/reanudación, migraciones, cierre de APK, pulsar Atrás, rotación/resolución, doble toque, derrotas, reemplazos, recompensas únicas y límite de nivel.

**Prueba de experiencia:** combate legible en pantalla pequeña; controles accionables; mensajes de causa/consecuencia; ningún salto visual que haga parecer otra pantalla; accesibilidad de texto y movimiento reducido; sin repeticiones de XP/captura al reabrir.

**Prueba humana:** el creador instala la APK sobre su partida anterior y confirma los pasos de la fase; después testers externos sin guía verbal. Guardar evidencia, no borrar problemas por una única prueba exitosa.

**Prioridades:** P0 = cierre/crash, pérdida de guardado, imposibilidad de completar partida o duplicación explotable. P1 = fallo reproducible grave de jugabilidad/interfaz. P2 = pulido o molestia no bloqueante. Un lanzamiento de alfa requiere cero P0 conocidos y tratamiento explícito de P1; los P2 pueden quedar registrados.

## 10. Primer movimiento recomendado (actualización 15/10/2026)

**Primero cerrar E1 con prueba real.** La configuración y reglas de Jade ya fueron aprobadas, y Chat implementó el ensayo de relevo de Sakuromushi en `feature/e1-jade-relay` (Preview 34, v0.18.0, CI verde). Sin embargo el creador comentó que percibía solo el bonus y no el cambio; no hay confirmación inequívoca de la versión instalada ni aprobación de esa experiencia. **No marcar «E1 validada» ni integrar a dev.**

**Siguiente acción:** Chat comprueba versión, equipo, selección de Sakuromushi y estado del Karmany activo; identifica si es una diferencia de APK, expectativa de UX o defecto real. Si hay bug, Work o Chat como único dueño asignado corrige y prueba E1; si se valida, cerrar el PR por fast-forward seguro y actualizar ROADMAP_ESTADO.md. Solo entonces Work inicia E2 (motor regional) y luego E3 (Jade completo). Nunca crear Bosque antes de superar alfa E6.

**Regla de ahorro:** especificar en Chat, escribir en Work únicamente un bloque acotado, revisar en Chat, corregir en la rama propietaria, validar en Android, actualizar el estado y seguir.

## 11. Bitácora mínima para pasar el control de Chat a Work

Copiar esta ficha al final de cada bloque. Es el mecanismo de coordinación más importante: **si falta dueño, rama o SHA, no se inicia otra edición**.

```text
FASE: E[N] — [nombre]
RESPONSABLE QUE ESCRIBE: Chat / Work / ninguno
BASE VALIDADA: dev/karmany-core @ [SHA revisado ahora]
RAMA DE TRABAJO: feature/[nombre] @ [SHA si existe]
ESTADO: propuesta / implementando / CI / probando APK / aprobado / integrado
ARCHIVOS RESERVADOS: [lista]; nadie más los edita hasta cierre
REGLAS AUTORIZADAS: [referencia de aprobación concreta]
PRUEBAS: [test ejecutado + resultado]; CI [URL / no ejecutada]
APK: [release y versión / todavía no existe]
PRUEBA HUMANA: pendiente / fallo documentado / «prueba correcta»
SIGUIENTE ACCIÓN: [un único responsable + objetivo concreto]
```

**Si Work se queda sin cupo a mitad de una fase:** no abrir inmediatamente otra implementación con Chat sobre archivos tocados. Primero solicitar a Work o recuperar desde GitHub el SHA del último commit, archivos modificados, pruebas realizadas y tarea pendiente. Chat puede continuar con la inspección del PR, preparación de tests y diagnóstico; retomar implementación requiere un traspaso expreso del rol de escritor y comprobar el nuevo HEAD. Una tarea incompleta no se considera integrada.

**Si Chat detecta un bug mientras Work implementa:** enviarlo como reporte reproducible (pasos, resultado, esperado, componente y gravedad). Work decide la corrección dentro de su rama si está en alcance; si no, crear un pendiente para el siguiente bloque. Chat no corrige ese mismo archivo en paralelo.

**Si una etapa demanda demasiado cupo:** dividirla por frontera comprobable (por ejemplo, E2A motor y guardado, E2B relevo rival y recompensa) y entregar una prueba útil entre ambas. No rebajar validación, alterar políticas del Libro ni improvisar estadísticas para avanzar más rápido.

---

**Referencias de consulta:**  
- GitHub: https://github.com/axenoban/karmany-monsta-android  
- Propuesta regional: `feature/region-pacing-design/docs/PROPUESTA_REGION_21.md`  
- Propuesta experimental: `feature/region-pacing-design/docs/COMBATE_REGION_21_PROPUESTA.md`  
- Registro validado: `dev/karmany-core/docs/BASELINE_VALIDADO.md`  
- OpenAI (uso/modelos Work y Codex): https://help.openai.com/es-419/articles/20001516-managing-usage-with-gpt-6-astra-in-work-and-codex  

**Estado de este documento:** roadmap de coordinación; no cambia reglas, código ni permisos de escritura del repositorio hasta su adopción explícita.

## 12. Lectura y escritura automática del estado al continuar

La lista E0–E10 de este documento define **qué** hacer. `docs/ROADMAP_ESTADO.md` define **en qué punto real está el proyecto**, quién escribe, cuáles son las ramas bloqueadas y qué falta por validar. No tomar «último mensaje de Chat» ni «última ejecución de Work» como estado oficial sin revisar GitHub. Cuando el creador diga «continúa», el agente debe decidir si le toca **ejecutar**, **revisar** o **ceder al otro agente**, usando las responsabilidades activas. Si el usuario asigna explícitamente el control, registrar el traspaso antes de escribir. No inferir que «continúa» es una aprobación.

**Obligación al finalizar cada intervención con cambios:** en la misma rama del bloque, escribir un estado con responsable, fase, SHA y fecha, commit/PR/CI, pruebas físicas pendientes y siguiente responsable. Tras «prueba correcta» en APK identificada, ejecutar pruebas finales, integrar en `dev/karmany-core` cuando sea seguro, verificar y actualizar el registro histórico del estado; no marcar aprobado si falla. Los cambios de estado durante un feature se registran en esa rama; en `dev` constan solo fases aprobadas e integración pendiente. Esto no sustituye `docs/CONTINUIDAD.md`.
