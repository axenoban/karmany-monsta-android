# ESTADO VIVO · Roadmap de Karmany Monsta (Chat + Work)

## Checkpoint operativo E5 · Work · 15/10/2026

- Base real verificada: dev `08ed2e70b35bfd1489fd9d88a5cdff52e9447dc2`; solo cambios documentales desde Preview38 `f0266ba`. Sin PR abiertos ni otra rama E5 al comenzar. main `9ef7af7` protegida.
- Rama única creada: `feature/e5-primera-sesion`. Work escritor exclusivo; Chat revisión sin escrituras. Contrato `E5_PRIMERA_SESION.md` respetado, E6 no iniciada.
- Implementadas ayudas inline E5-01…12, campo opcional `first_session` solo al iniciar partida nueva/instalación sin perfil, Ayuda manual, textos reales y resumen permanente derrota/XP. Motores, datos regionales, migraciones y reglas intactos.
- Primera suite completa local correcta: 26 suites históricas + E5, 3 Python; import Godot 4.7.2 sin errores. Ampliación E5: 601 checks, incluyendo 69 Preview32, 10 E2 y 7 perfiles cargados por fuente Preview38 aprobada. Revisión visual, CI/exportación y APK todavía pendientes en este checkpoint.
- Se corrigió incompatibilidad con el test de defaults de instalación preservando el contrato de SaveStore y moviendo la activación E5 a App; no se cambió ni debilitó el test histórico.
- SHA de este avance: commit que contiene esta sección, consultar git log. Sin integración a dev/main ni validación física E5.

**SIGUIENTE PASO:** terminar revisión visual, CI y exportación de candidata E5.
**RESPONSABLE:** WORK.
**INSTRUCCIÓN PARA CONTINUAR:** verificar HEAD de feature/e5-primera-sesion y dev; completar pruebas, revisión visual y CI/APK de E5, publicar PR contra dev y entregar validación física pendiente, sin integrar ni iniciar E6.

Lo que sigue conserva los checkpoints documentales anteriores.

## Estado vigente MÁS RECIENTE · E5 autorizada y transferida a Work (15/10/2026)

**Autorización humana:** creador aprueba de forma expresa la especificación E5, sus 12 intervenciones, microcopias y criterios de aceptación y las cuatro opciones: tarjetas contextuales pequeñas descartables; una vez solo en partida nueva sin forzar partidas antiguas; opción **Ayuda** para repetir; resumen breve siempre en derrota/progreso y explicación detallada cuando corresponda.

**Contrato de implementación obligatorio:** [E5_PRIMERA_SESION.md](E5_PRIMERA_SESION.md). Aprobado para programar; **ningún código E5 implementado ni validado físicamente** en este checkpoint.

- **Responsable escritor del siguiente bloque: WORK** (no Chat). Rama aún no creada: `feature/e5-primera-sesion`, partiendo de HEAD actualizado de `dev/karmany-core`. Base documental examinada al comenzar E5: `76a7347f60605cc28259b0a087f4654b69a89164`; Work debe verificar su sucesor documental real.
- **Baseline funcional protegido:** Preview38, código `f0266badaa7851da3de2bcc08a65752b6409360b`. PR18 merged; PR17 incorporado por ascendencia. Sin PR funcional E5 ni APK E5 al aprobar.
- **CI:** [38824304295](https://github.com/axenoban/karmany-monsta-android/actions/runs/38824304295) es la CI de Preview38, NO prueba nueva de E5. Estas ediciones son solo documentos.
- **No modificación funcional:** R0, E1–E4, E7 recuperada, 2 regiones/12 puntos, 13 combatientes, guardados, XP, stamina, reglas, arte y motor E2 siguen estables. `main` no se toca.
- **Puerta E5:** Work entrega feature + PR + CI completa + APK candidata; revisión independiente y prueba Android del creador. Integrar en dev únicamente tras «prueba correcta» del APK/SHA.

**SIGUIENTE PASO:** implementar E5 aprobada en una rama feature exclusiva y presentar APK revisable.
**RESPONSABLE:** WORK.
**INSTRUCCIÓN PARA CONTINUAR:** verificar `dev/karmany-core`, leer `AGENTS.md`, este tablero, `ROADMAP_CHAT_WORK.md`, `CONTINUIDAD.md` y `E5_PRIMERA_SESION.md`; trabajar solo el contrato E5, conservar Preview38 y sus migraciones, ejecutar regresiones/CI, entregar PR + APK para validación humana, sin integrar ni tocar `main`.

El apartado siguiente **«Estado vigente · cierre aprobado de R0»** y sus instrucciones de solicitar diseño a Chat quedan como registro histórico previo a esta aprobación; no son la instrucción operativa actual.


## Estado vigente · cierre aprobado de R0 (15/10/2026, America/La_Paz)

La **Preview 38 / v0.21.0-unification**, código `f0266badaa7851da3de2bcc08a65752b6409360b`, ha sido **probada físicamente y aprobada por el creador**: «Confirmo que probé físicamente la Preview 38 (v0.21.0-unification) y la considero correcta y aceptable. Apruebo esta versión».

Referencia adicional: [validación registrada por Chat en PR #18](https://github.com/axenoban/karmany-monsta-android/pull/18#issuecomment-6204818029). Es aprobación general de la versión; no se atribuyen pruebas específicas no detalladas por el usuario.

- **Unificación completada y aprobada.** Valle Jade y Bosque del Velo (6 + 6 etapas), contenido recuperado de Preview32 y mejoras E1/E2 constituyen el baseline estable.
- **Integración realizada y verificada:** fast-forward de `dev/karmany-core` desde `2ea590cff0b0e1cb1c6b33318bf156901efb681e` a `525acef829ba934ddce3bb84ed08edc194c2640e`. El commit de cierre posterior solo documenta esta verificación; código de juego aprobado `f0266ba`.

- Código aprobado idéntico: desde `f0266ba` hasta `892a109` solo cambiaron cuatro archivos en `docs/`; este cierre solo modifica instrucciones/documentación.
- [CI 38824304295 correcta](https://github.com/axenoban/karmany-monsta-android/actions/runs/38824304295): 4.409 checks Godot en 26 suites, 3 Python, exportación, firma v2/v3 y auditoría. No se atribuye una ejecución nueva a este cierre documental.
- [APK aprobada Preview 38](https://github.com/axenoban/karmany-monsta-android/releases/download/android-preview-38/karmany-monsta-preview.apk), SHA-256 `16a66fc970346981eb628f7ac4a04a7633eac8ff08b93a735d723c7bb37c08ac`; evidencia en `docs/recovery/CANDIDATA_38_VERIFICACION.json`.
- **main se conserva en `9ef7af778ee59a47f62bdfbfd5eb0786ce787213`**. No se eliminan ramas/releases ni se reescribe historia. PR #17 está absorbido por la ascendencia del PR #18; no se vuelve a fusionar.
- **Siguiente etapa pendiente: E5, diseño/especificación a cargo de Chat.** Work no inicia E5 ni crea nuevas funcionalidades hasta disponer de criterios y decisiones aprobados.

## Regla permanente de cierre y traspaso

**Cada entrega de Chat o Work, incluso una revisión, corrección, bloqueo o cierre documental, debe terminar indicando el siguiente paso concreto, un responsable único (CHAT o WORK) y una instrucción lista para copiar al agente correspondiente.** No basta «continúa el roadmap». Esta regla es obligatoria por instrucción del creador del 15/10/2026.

Formato mínimo:

```text
HECHO:
RAMA/COMMIT/PR:
CI:
APK:
PRUEBAS / RESULTADO:
RIESGOS / VALIDACIÓN PENDIENTE:
SIGUIENTE PASO: [acción concreta]
RESPONSABLE: CHAT o WORK
INSTRUCCIÓN PARA CONTINUAR:
[texto completo copiable, con repositorio, etapa, baseline que debe verificarse,
alcance, límites, entregables y condición para pasar al siguiente agente]
```

Si el paso está bloqueado, identificar la causa y el agente que debe resolverla. No autorizar implícitamente otra fase mediante el cierre de la anterior.

**Control de planificación:** 2026-10-15, zona America/La_Paz. **Versión del estado:** 1.0.  
**Regla:** este archivo es el tablero operativo que ambos agentes deben consultar y actualizar. La planificación completa y los prompts están en [ROADMAP_CHAT_WORK.md](ROADMAP_CHAT_WORK.md). El historial técnico está en [CONTINUIDAD.md](CONTINUIDAD.md). Se debe comprobar el GitHub real antes de confiar en cualquier SHA anotado.

## 0. No regresión · R0 cerrada

La divergencia documentada en [la auditoría](AUDITORIA_DOS_LINEAS_2026-10-15.md) fue resuelta en Preview38. La aprobación física y el cierre sustituyen los bloqueos de rescate históricos. Mantener las dos regiones/12 etapas, 13 criaturas de combate, 21 fichas, gráficos, flujos, relevo E1, motor E2 y compatibilidad de partidas. No reconstruir Bosque ni repetir E2/E3. **No comenzar implementación E5 en este cierre.**

## 1. Estado histórico al crear este tablero (superado por el cierre vigente)

| Elemento | Situación |
|---|---|
| Repositorio | `axenoban/karmany-monsta-android` |
| Rama publicable | `main`; no contiene todavía un juego comercial |
| Base funcional aprobada | `dev/karmany-core` — código Preview 29, v0.17.0; HEAD inicial `4d1817a843718d08a5527a0e235c0af3cba62edd` |
| CI de última base jugable validada | [Preview 29](https://github.com/axenoban/karmany-monsta-android/releases/tag/android-preview-29); éxito documentado en `docs/BASELINE_VALIDADO.md` |
| Rama funcional no validada | `feature/e1-jade-relay` — `1719c6821319279f191734a0d4fbf836e9de428e` en el corte |
| PR funcional | [PR #17, borrador](https://github.com/axenoban/karmany-monsta-android/pull/17) contra `dev/karmany-core` |
| APK E1 para prueba | [Preview 34, v0.18.0 experimental](https://github.com/axenoban/karmany-monsta-android/releases/tag/android-preview-34) |
| CI E1 | [Ejecución exitosa](https://github.com/axenoban/karmany-monsta-android/actions/runs/38777146974); **no sustituye prueba física** |
| Propuesta regional de origen | `feature/region-pacing-design`, `docs/PROPUESTA_REGION_21.md` y `docs/COMBATE_REGION_21_PROPUESTA.md` |
| **Fase de implementación actual** | **R0: recuperar y reconciliar Preview32 (dos regiones), E1 Chat y E2 Work local**; E1 no validada aún |
| **Dueño del código activo** | **Work en `feature/unificacion-jade-bosque`, traspaso explícito del creador15/10/2026** |
| **Área permitida a Work ahora** | **Recuperar E2 (fuente de Work) y construir rama de convergencia**, sin escribir sobre E1 ni dev |
| **Siguiente objetivo habilitado** | **Rescate fuente E2 + conservación Preview32; convergencia 2 regiones sin retroceso** |

### Observación histórica de Preview34 (superada por la aprobación general de Preview38)
Tras la entrega de Preview 34, el creador comentó que veía una potenciación pero no percibía el cambio de Karmany. En otra respuesta se explicó que **solo la Insignia de Sakuromushi** produce el relevo automático, y se preguntó qué versión utilizó. No hay confirmación posterior de versión, reproducción ni «prueba correcta». **Estado exacto: comentario de validación abierto, diagnóstico pendiente.** No marcarlo como fallo técnico demostrado, pero tampoco como resuelto. El código/CI cambian el activo; se requiere confirmar el comportamiento visible en Android.

### E1: decisiones aprobadas pero todavía no integradas a la APK estable
- Seis etapas Valle Jade: Tanugami Nv1, Ushigane Nv3, Kitsunibi Nv5, Sakuromushi Nv7, Sakuraneko Nv8 y final Inubari + Ushigane Nv10 **secuenciales**, no simultáneos.
- XP primera victoria: **400 / 500 / 600 / 650 / 700 / 750**; repetición **100 / 125 / 160 / 200 / 240 / 300**. Topes individuales y partidas antiguas intactas; cálculo de bonos atómico y no repetible.
- Stamina: **10** en cada una de cinco etapas normales, **30** en final; recuperación y consumibles vigentes.
- Final: dos rivales por relevo sin curación gratis ni nuevo ataque del rival, recompensa una vez, seleccionar **un** rival vencido para vínculo con los tres intentos existentes.
- Captura de Karmany nuevo al nivel del encuentro, sin alterar capturas previas; salvaguardar XP, puntos, progreso y encuentros activos.
- Sakuraneko experimental Nv1: Vida72/Ataque20/Defensa7, cura10 y protección20%, recarga3. Inubari experimental Nv1: Vida84/Ataque18/Defensa11, golpe110%+protección30%, recarga2. Balance de juego, **no cifras del canon enciclopédico**.
- Ajuste E1 a Sakuromushi: ataque leve + relevo automático antes del contraataque + potenciación por varias rondas. **Valores de prueba 70% daño, +20% durante dos rondas, recarga2**; falta validación humana, no generalizar a otras especies automáticamente.
- Documento de implementación: `docs/E1_JADE_RELEVO_2026-10-15.md` **en la rama E1**. Ni seis etapas completas ni nuevo motor regional forman parte de Preview 34.

## 2. Etapas y responsables vigentes

| Etapa | Estado actual | Siguiente responsable / condición |
|---|---|---|
| R0 · Unificación | Completada y aprobada físicamente en Preview38 | Cierre/integración de PR18 por Work; mantener baseline |
| E0 · Coordinación | Vigente | Ambos cumplen los documentos y el traspaso obligatorio |
| E1 · Jade / relevo | Incorporada y aprobada dentro de Preview38 | No fusionar PR17 otra vez |
| E2 · Motor regional | Incorporada y aprobada dentro de Preview38 | Preservar contratos y migraciones |
| E3 · Jade de seis etapas | Completada dentro de R0 | Preservar contenido validado |
| E4 · Continuidad visual | Completada dentro de R0 | Preservar flujos validados |
| **E5 · Primera sesión autónoma** | **Diseño, microcopias y criterios aprobados el 15/10; implementación no iniciada** | **Work escritor exclusivo; PR/CI/APK y prueba física pendientes** |
| E6 · Alfa / playtest | Pendiente, después de E5 | Chat prepara QA; Work corrige cuando corresponda |
| E7 · Bosque del Velo | Sus seis etapas ya recuperadas y aprobadas en R0 | No reconstruir ni añadir región nueva |
| E8–E10 | Pendientes | Según feedback y autorizaciones futuras |

**SIGUIENTE PASO:** preparar únicamente el contrato de implementación E5.
**RESPONSABLE:** CHAT.
**INSTRUCCIÓN PARA CONTINUAR:**

```text
Continúa Karmany Monsta Android en axenoban/karmany-monsta-android. Verifica el HEAD real de dev/karmany-core y lee AGENTS.md, docs/ROADMAP_ESTADO.md, docs/ROADMAP_CHAT_WORK.md y docs/CONTINUIDAD.md. La Preview 38 (v0.21.0-unification, código f0266ba) está aprobada físicamente y la unificación está cerrada. Prepara únicamente el diseño y la especificación de E5: primera sesión autónoma, tutorial contextual y claridad de derrota/progresión. Define alcance, exclusiones, microcopias, criterios de aceptación, regresiones de guardado/UI y un bloque acotado con instrucción lista para Work. No programes ni modifiques reglas, balance, canon o sistemas estables. Distingue decisiones pendientes y espera su aprobación antes de autorizar implementación. Termina con SIGUIENTE PASO, RESPONSABLE (CHAT O WORK) e INSTRUCCIÓN PARA CONTINUAR.
```

## 3. Contrato de continuidad («continúa»)

Al recibir «continúa con Karmany Monsta», «sigue», «prueba correcta», «haz la siguiente etapa» o equivalente:

1. **Leer en GitHub**, en este orden: `AGENTS.md`, `docs/ROADMAP_ESTADO.md`, `docs/ROADMAP_CHAT_WORK.md`, `docs/CONTINUIDAD.md`, y especificaciones de la rama activa.
2. **Verificar estado REAL** de `dev/karmany-core`, rama funcional, HEAD, PR, checks, última APK, logs, archivos modificados. Si este estado quedó desactualizado por una integración ya hecha, actualizarlo primero con pruebas.
3. Detectar la **etapa pendiente más temprana**, su dueño escritor y su puerta de validación. **No interpretar «continúa» como «prueba correcta».**
4. Si eres **Chat**, puedes auditar/planificar/probar; solo editar código si eres dueño escritor de ese bloque o el creador te transfiere el control. Si eres **Work**, ejecutar únicamente el bloque cuya escritura está libre y asignada a Work; de lo contrario revisar e informar qué bloqueo falta, sin empezar trabajo solapado.
5. Si hay otra rama funcional en curso que modifica archivos del bloque, no hacer un segundo desarrollo paralelo. Compartir diagnóstico y acordar un traspaso expreso, actualizando esta ficha.
6. Al terminar una entrega, añadir informe verificable al **mismo branch** y actualizar el estado, aunque esté bloqueada. Entregar pruebas concretas y siguiente dueño. Las instrucciones del creador pueden cambiar prioridades; registrar ese cambio.

### Reglas de exclusividad y ramas
- **Base aprobada:** `dev/karmany-core`. **Publicación:** `main`. **Pendiente:** `feature/*`.
- Un bloque funcional, un escritor; cada uno puede **leer** en paralelo, pero no editar el mismo motor/archivo/registro mientras otro es dueño.
- Propuesta/datos de balance NO es implementación ni prueba; CI verde NO es prueba humana.
- Trabajo incompleto permanece en `feature/*`; `dev` no incorpora código experimental sin «prueba correcta» sobre un APK/SHA identificable.
- La documentación de coordinación puede evolucionar en `dev` **sin alterar código**, siempre dejando la rama activa sincronizada antes de intentar fast-forward. No force push ni reescribir historia.
- El dueño que integra es quien cierra el bloque tras aprobación, con validación de rama/HEAD, tests/CI y registros. Si la rama se bifurca por una actualización documental, **fusionar `dev` hacia `feature` explícitamente** y, cuando sea seguro, avanzar `dev` por fast-forward; no forzar un falso avance lineal.
- No borrar fallos ni cambiar reglas para ocultar una regresión. No tocar guardados existentes sin migraciones.

## 4. Protocolo de actualización obligatorio

**En toda entrega de código o traspaso:**
1. Confirmar **fase, dueño, branch, HEAD base y HEAD feature** actuales.
2. Cambiar aquí estado: `diseño` / `implementando` / `CI` / `APK lista` / `prueba humana pendiente` / `corrección requerida` / `aprobado` / `integrado`. No inventar fechas/SHAs.
3. Registrar **qué quedó hecho**, evidencia CI (enlace+resultado), release APK, aprobación textual y fallas abiertas. No promocionar a `dev` si una puerta está pendiente.
4. Ajustar el **siguiente responsable y su primera tarea**, liberando o reservando archivos y evitando duplicaciones.
5. Añadir historial corto abajo y actualizar `docs/CONTINUIDAD.md`. Si una regla nueva necesita aprobación, dejarla **pendiente**; no incorporarla silenciosamente.
6. Solo tras éxito físico declarado, verificar el estado real de GitHub y **integrar por fast-forward seguro** (o documentar impedimento), actualizar tablero en `dev` y cerrar PR según corresponda.

### Plantilla de checkpoint para pegar y mantener

```text
FECHA LOCAL:
ETAPA:
DUEÑO ESCRITOR:
BASE dev/karmany-core @:
RAMA feature/* @:
ESTADO:
ALCANCE REALMENTE IMPLEMENTADO:
ARCHIVOS COMPARTIDOS / BLOQUEADOS:
REGLAS APROBADAS Y FUENTE:
CI / TESTS (ENLACE, RESULTADO):
APK / SHA:
VALIDACIÓN HUMANA:
FALLOS / LIMITACIONES ABIERTAS:
INTEGRADO EN dev: sí/no; nuevo SHA:
SIGUIENTE RESPONSABLE + PRIMER PASO:
```

## 5. Registro histórico de checkpoints (conservar procedencia; manda el estado vigente de arriba)

- **2026-10-14** — Preview29/v0.17.0, progresión y resumen XP aprobados e integrados en dev; evidencia histórica en CONTINUIDAD y BASELINE_VALIDADO.
- **2026-10-15** — Dirección de Jade E1 aprobada por el creador; variación de Insignia de Sakuromushi para evitar usar dos turnos, con bono que dure varias rondas.
- **2026-10-15** — Chat implementó ensayo E1 en `feature/e1-jade-relay`; PR17; CI [éxito](https://github.com/axenoban/karmany-monsta-android/actions/runs/38777146974); Preview34/v0.18.0 publicada. **No integrada / prueba física pendiente.**
- **2026-10-15** — El creador indicó no haber visto el relevo, únicamente bonus; se solicitó confirmar Preview34. **No consta aprobación ni reproducción definitiva de fallo.**
- **2026-10-15** — Roadmap integral Chat/Work importado al repositorio con lectura obligatoria por `AGENTS.md`, tablero presente; implementación de juego sin cambios.

**Próxima acción concreta (reemplaza la anterior):** **Work** debe rescatar E2 desde el bundle local de Work, obtener el APK Preview32 del Library/rescate, reconstruir su segunda región y conservar sus elementos únicos en rama de convergencia; **Chat** audita diferencias y validación sin reprogramar los mismos scripts. No integrar E1/E2 en dev ni declarar versión superior hasta prueba Android de compatibilidad con partidas Preview32. La observación visual de Sakuromushi sigue pendiente y se comprobará en esa candidata.

- **2026-10-15 (auditoría posterior)** — Recuperados y comparados los APK Preview30/31/32 y el bundle Work E2; confirmada bifurcación real que eliminó contenido de Bosque en las APK de E1/E2. Iniciado plan R0 de rescate y unificación antes de ampliar más el juego. Fuente en AUDITORIA_DOS_LINEAS_2026-10-15.md.

## Checkpoint R0 · Work (15/10/2026)
- Estado: implementando recuperación en feature/unificacion-jade-bosque; único escritor Work, Chat revisa sin editar.
- GitHub verificado: dev 2ea590c, main 9ef7af7, E1 00b2769; PR17 permanece abierto. Código E1 1719c68 con CI38777146974 correcta.
- E2 recuperada desde bundle válido a feature/e2-regional-engine-recovered @ dc4a20a (código42fed0c), integrada con historial completo en esta feature. Único conflicto documental conservado íntegro.
- APK Preview32 SHA256 3a65d6f760bd881e0fb176220e1c2ae59c25b1e09327d4fa2ed71c36f453f06a y ZIP E2 9ecf0f8064ea71293d4d47d44e1edffced47bd97aaa9a6e76169f6d0c60383af verificados.
- Pendiente: recuperación editable Preview32, paridad12 etapas, migraciones y CI de unificación. Sin APK candidata; prueba humana pendiente; no integrado en dev.

## Checkpoint de implementación R1/R2 · 15/10/2026
Work es el único escritor autorizado; rama feature/unificacion-jade-bosque. Se recuperaron39scripts editables de Preview32 y97recursos; las doce imágenes regionales están comoPNG. Se integraron las dos regiones/12etapas,13criaturas de combate/21fichas, finales, UX de derrota/XP/vínculo de Preview32 con contrato/recompensas/persistencia E2 y relevo E1. No se inventaron cifras de Bosque: proceden de losJSON de laAPK.

Migración Preview32 probada con69guardados generados por su motor original, incluido combate abierto, respuesta pendiente, derrota, reemplazo yXPparcial;1846checks de unificación correctos. Respaldo .pre-unification conserva los bytes originales antes de escribir. Certificado Preview32/E2/keystore del repositorio idéntico. E2 publicada como importación fuente 1f65222 en feature/e2-regional-engine-recovered, con bundle original incluido; diff de fuente igual, salvo el bundle adicional.

Las22suites históricas pasan localmente; se añaden pruebas de UI regional y24simulaciones de balance sin cambiar cifras. Importación y3pruebasPython correctas. Compilación/CI y revisión gráfica remotas todavía pendientes en este checkpoint. No hay aprobación física ni integración en dev/main. Detalle de procedencia, comparación y prueba Android: docs/UNIFICACION_JADE_BOSQUE.md. Próximo paso de Work: terminar CI/exportación/firma y entregar laAPK candidata; Chat revisa en solo lectura.

## Checkpoint CI y revisión visual · 15/10/2026
Rama remota feature/unificacion-jade-bosque @55dc205, PR18 borrador contra dev; árbol remoto idéntico al árbol local probado (ad5bd6b). CI38823615057 iniciada, todavía no se afirma éxito en este checkpoint. Se renderizaron22pantallas localmente; se corrigió el fondo secundario de la vista del Libro y se fortaleció el rechazo de formas de guardado malformadas. Estos cambios requieren nueva CI; no son aprobación de la APK. Se añadieron generadores de los69fixtures originales en ci/recovery. Work conserva escritura, Chat revisa. dev/main intactas.

## Checkpoint técnico verde · candidata37 / cierre de identificación
CI38823832205 sobre código0e79ce486ed7c49521c15428aa40df8b1e8eb720 terminó correctamente:4279checksGodot únicos,3Python,22pantallas renderizadas, exportaciónAndroid, firma v2/v3 y auditoría. Se descargó y verificó Preview37/v0.21.0-unification, SHA256b0b3a3c774cf5ed44df67455ab74d40ba5a61355eb8ae9cb145920ff4b88c4b6; dosJSON regionales de6puntos presentes y tests/docs/ci excluidos delAPK. main9ef7af7 y dev2ea590c se mantienen intactos.

Verificación adicional: diez guardados generados ejecutando la fuente E2 original dc4a20a pasan130checks de conservación/recarga, incluidos contrato, ambos relevos y captura parcial; fixtures y generador quedan preservados y añadidos a CI. Se corrigió la etiqueta diagnóstica de build_info heredada como «E2 motor regional» para identificar correctamente la unificación; requiere una nueva compilación que será la candidata definitiva de esta entrega. No cambian reglas ni motor. Pendiente CI del último metadato/test, APK final y prueba física del creador. Work conserva escritura; Chat solo revisa.

## Entrega candidata38 · cierre técnico de R0, pendiente validación humana
- Código APK: f0266badaa7851da3de2bcc08a65752b6409360b. Documentación posterior no modifica laAPK.
- CI: https://github.com/axenoban/karmany-monsta-android/actions/runs/38824304295 — correcta, incluida exportación, firma v2/v3 y publicación de preview.
- APK: https://github.com/axenoban/karmany-monsta-android/releases/download/android-preview-38/karmany-monsta-preview.apk — 83365989bytes; SHA25616a66fc970346981eb628f7ac4a04a7633eac8ff08b93a735d723c7bb37c08ac.
- Verificados tras descargar: versión0.21.0-unification, build38, identificación R0 correcta, seis etapas de cada región y13especies, paquete com.axenoban.karmanymonsta.preview y certificado idéntico a Preview32/E2; no contiene tests/docs/ci.
- Prueba física: pendiente. No se interpreta CI verde como aprobación de E1 ni de la unificación. dev2ea590c y main9ef7af7 intactos.
- Siguiente acción: el creador instala Preview38 encima de su partida, sigue la prueba de docs/UNIFICACION_JADE_BOSQUE.md e informa resultado. Chat audita PR18 en solo lectura. Work corrige cualquier reproducción en esta rama; no inicia nuevo contenido ni integra hasta aprobación física explícita.

## Cierre aprobado de unificación · 15/10/2026

Se registra la aprobación textual del creador y el comentario de Chat en PR18. Work verificó: f0266ba aprobado; 892a109 solo documentación posterior; dev2ea590c y E1/PR17 (00b2769) son antecesores del cierre. Integración por fast-forward, sin modificar código de juego, datos, guardados, arte, tests, configuración Android ni main. La operación y el nuevo HEAD deben verificarse en GitHub; el SHA de este cierre se obtiene del commit que contiene esta sección. E5 queda pendiente de especificación por Chat, sin implementación ni diseño nuevo en este bloque.

## Verificación final de integración · 15/10/2026

- Fast-forward confirmado: dev y feature idénticos en `525acef829ba934ddce3bb84ed08edc194c2640e`, cero archivos diferentes.
- GitHub: PR #18 **closed / merged=true**. PR #17 **closed / merged=true** automáticamente al incluir su historia en dev; no se llamó a ninguna operación de merge para PR #17.
- Ascendencia de E1 confirmada: `00b2769` es merge-base de E1 contra dev, behind=0. Todo el bloque aprobado `f0266ba` sigue incluido; diferencias posteriores limitadas a AGENTS/documentación.
- main verificada sin cambios en `9ef7af778ee59a47f62bdfbfd5eb0786ce787213`.
- No se han ejecutado tests ni compilación nuevos para cambios exclusivamente documentales; se conserva la CI exitosa y APK Preview38 aprobadas.
- La nueva regla de cierre/traspaso está en AGENTS y ROADMAP_ESTADO y aplica a todas las entregas de Chat y Work.
- **SIGUIENTE PASO:** especificar E5 sin iniciar su implementación.
- **RESPONSABLE:** CHAT.
- **INSTRUCCIÓN PARA CONTINUAR:**

```text
Continúa Karmany Monsta Android en axenoban/karmany-monsta-android. Verifica el HEAD real de dev/karmany-core y lee AGENTS.md, docs/ROADMAP_ESTADO.md, docs/ROADMAP_CHAT_WORK.md y docs/CONTINUIDAD.md. La Preview 38 (v0.21.0-unification, código f0266ba) está aprobada físicamente y la unificación está cerrada. Prepara únicamente el diseño y la especificación de E5: primera sesión autónoma, tutorial contextual y claridad de derrota/progresión. Define alcance, exclusiones, microcopias, criterios de aceptación, regresiones de guardado/UI y un bloque acotado con instrucción lista para Work. No programes ni modifiques reglas, balance, canon o sistemas estables. Distingue decisiones pendientes y espera su aprobación antes de autorizar implementación. Termina con SIGUIENTE PASO, RESPONSABLE (CHAT O WORK) e INSTRUCCIÓN PARA CONTINUAR.
```
