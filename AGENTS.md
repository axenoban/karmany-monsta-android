# Instrucciones de desarrollo de Karmany Monsta

## 15/11/2026 · Kit de combate: candidata para prueba física

Autorización vigente: «Ok implementa el kit para una prueba física». Rama `feature/combat-visual-kit-physical`, basada en dev `b885e6ce7f3d09a99cdbabef4c39465164d81b8a` (Preview104). Aplicar el kit entregado a controles de combate existentes; no integrar a dev/main hasta validación física. PR24 y PR32/Preview108 permanecen independientes. No autoriza multijugador, reglas, balance, E6 ni R2–R4.

Implementación y protocolo: `docs/COMBAT_VISUAL_KIT_CANDIDATA.md`. Godot 4.7.2: 159 verificaciones del kit y 675 de regresión local sin fallos. Pendiente CI completa/exportación y prueba en teléfono. Continuar publicando candidata, comprobar APK y esperar validación; no declarar prueba física realizada.


## 15/11/2026 · CIERRE CONFIRMADO · Preview104 incorporada a dev

**ESTADO REAL:** `dev/karmany-core` avanzado de `a0e108c1ca8e908942492f18caa2ac2eab3fbb88` a `3a5f53384c9dd958ca786e27ed89adf7c7b993f2` mediante fast-forward no forzado. Commit de dos padres: dev previo + código Preview104 `4a96bf3e18ce58cd5b6b8786b23fd598ded00f6e`. [PR31](https://github.com/axenoban/karmany-monsta-android/pull/31) cerrado/merged=true. [CI de integración 43662842572](https://github.com/axenoban/karmany-monsta-android/actions/runs/43662842572) **completed/success** (regresiones y exportación Android). `main` permanece en `9ef7af778ee59a47f62bdfbfd5eb0786ce787213`.

**AUTORIZACIÓN:** el creador dijo «ok integra esta version , valido esta opcion por el momento», referida a Preview104 como conjunto. **No inventar** dispositivos, pasos físicos o aceptación individual de etapas antiguas. El árbol jugable del commit de integración coincide con Preview104; los únicos cambios respecto al código de la APK fueron `AGENTS.md`, `docs/ROADMAP_ESTADO.md`, `docs/CONTINUIDAD.md` y un documento de integración nuevo. Las cinco skills existentes en dev se conservaron.

**PRs conciliados:** PR21 y PR31 figuran merged; PR22, PR23, PR25, PR27, PR28 y PR30 se cerraron como **incluidos indirectamente** en dev mediante PR31, con comentario explicativo (GitHub puede mostrarlos closed/unmerged por no tener merge directo). PR24 con los 401 SVG no aprobados y PR26 documental permanecen **abiertos e independientes**. No utilizar los assets del PR24 sin validación. No iniciar E6/R2–R4 por este cierre.

**PROTECCIÓN:** Preview104 es ahora el baseline UI y funcional completo validado de dev. Mantenerlo estable. Siguientes mejoras visuales en nuevas `feature/*`, con revisiones y pruebas; no reabrir reglas/balance/guardados sin motivo técnico y autorización.

**SIGUIENTE PASO:** contrastar en un dispositivo el APK [Preview104](https://github.com/axenoban/karmany-monsta-android/releases/download/android-preview-104/karmany-monsta-preview.apk) con el criterio artístico, y revisar por familias los recursos definitivos del kit PR24 **sin integrarlo** hasta aprobación.

**RESPONSABLE:** WORK para propuesta/revisión de recursos artísticos por familia en rama separada; CHAT para revisar evidencia/CI y proteger baseline.
**INSTRUCCIÓN PARA CONTINUAR:** Inspecciona `axenoban/karmany-monsta-android` @ dev real posterior al cierre y el PR24 pendiente; usa `game-visual-system`, `godot-ui-ux` y `android-game-qa`. Presenta recursos de una familia individual con variantes a tamaño real; no sustituir assets del baseline Preview104 ni integrar PR24 sin aprobación, no tocar reglas ni iniciar E6/R2–R4.


## 15/11/2026 · Aprobación de Preview104 para baseline dev

**Aprobación del creador:** «ok integra esta version , valido esta opcion por el momento». Se aplica a la versión **Android Preview104** en su conjunto, no a recursos visuales ajenos ni a resultados de prueba física detallados no declarados.

**Código aprobado:** `4a96bf3e18ce58cd5b6b8786b23fd598ded00f6e` de `feature/ui-integral-jade-exploracion-combate`, PR30; APK [Preview104](https://github.com/axenoban/karmany-monsta-android/releases/tag/android-preview-104); CI [43661494124](https://github.com/axenoban/karmany-monsta-android/actions/runs/43661494124) completada correctamente. Código Godot, escenas, datos canónicos y tests en el árbol aprobado se preservan al conciliar el historial.

**Resolución de historia:** dev contenía el commit documental `a0e108c1` (PR29, cinco skills) mientras la candidata se bifurcó antes y copió sus archivos. La integración requiere un commit con ambos padres, sin force push ni reescritura, y conservar las instrucciones de skills introducidas en dev. La rama `feature/integration-preview104-into-dev` prepara esa conciliación para CI y revisión; el avance de dev debe verificarse en GitHub antes de declarar integración definitiva.

**Dependencias:** Preview104 incluye por ascendencia R1.1/PR21, documento maestro/PR22, dirección Jade/PR23, prototipo Jade/PR25 y UX/PR27-28; esta autorización valida la **versión final combinada**, sin afirmar pruebas físicas individuales de todas las candidatas antiguas. **PR24 y sus 401 SVG de kit pendiente NO se integran ni se consideran aprobados.** No se crean reglas, mecánicas, estadísticas ni contenido nuevo. `main` sigue reservado para entregas publicables.

**Validaciones:** la CI de Preview104 fue satisfactoria; la CI de reconciliación debe volver a confirmar el árbol resultante (tests y exportación Android). Mantener guardados QA aislados y prohibición E6/R2–R4 sin nueva autorización. El protocolo de desarrollo y los pendientes de diseño final permanecen.

**Siguiente paso:** comprobar el SHA de la integración y sus tests, actualizar `dev/karmany-core` solo por fast-forward no forzado y cerrar/corregir los PR históricos mediante una auditoría de ancestros, sin marcarlos automáticamente como aprobados de manera individual.

**RESPONSABLE:** CHAT para conciliación/validación de Git; WORK para siguiente bloque de arte final solamente tras alcance aprobado.
**INSTRUCCIÓN PARA CONTINUAR:** En `axenoban/karmany-monsta-android`, comprobar `dev/karmany-core`, `main`, PR30, commit Preview104 y merge de reconciliación; verificar CI, conservar cinco skills y evitar el PR24. No iniciar funcionalidades ni tocar canon. Preparar únicamente revisión por familias del arte UI definitivo.


## Jade nocturno · revisión artística y archivo de diseños · 14/11/2026

El creador considera insuficiente la fidelidad visual de Preview46 respecto al concepto elegido y solicita registrar el inventario/manual antes de generar los diseños. Preview46 sigue siendo una primera adaptación técnica, sin aprobación artística final. No integrar por esta petición documental.

Manual y catálogo: docs/diseno/jade-nocturno/README.md y catalogo.csv. Archivo de imágenes: docs/diseno/jade-nocturno/imagenes/, con referencia original, cuatro bloques y carpetas propuestas/aprobados. No hay nuevos diseños finales aprobados. Esta entrega modifica solo documentación y archivo de referencia; no modifica APK, reglas ni guardados. PR23 permanece abierto en feature/jade-nocturno.

SIGUIENTE PASO: diseñar la lámina del kit maestro y presentarla para revisión.
RESPONSABLE: WORK.
INSTRUCCIÓN PARA CONTINUAR: En feature/jade-nocturno lee docs/diseno/jade-nocturno/README.md; diseña la lámina del kit maestro siguiendo la referencia y registra sus propuestas sin marcarlas aprobadas ni modificar el juego.


## Jade nocturno · implementación autorizada · 14/11/2026

**Entrega verificable:** [Preview46 / v0.25.0-jade](https://github.com/axenoban/karmany-monsta-android/releases/tag/android-preview-46), [PR23](https://github.com/axenoban/karmany-monsta-android/pull/23), código `ca3fd8d95d913998415618d11d27b706a669fbfd`, [CI43597428376 correcta](https://github.com/axenoban/karmany-monsta-android/actions/runs/43597428376). APK83.431.938 bytes, SHA256 `40fdf39d1012bbb5440eb1218adb7eb2edf0dd5a7ef4a508dcda84667b481e33`. Descarga completa comprobada; firma con el mismo certificado anterior;11 JSON de juego idénticos. 5.972 comprobaciones/32 suites Godot y3 Python correctas. Capturas en ui-review.zip de la release. Prueba física pendiente, sin integración. Evidencia: docs/JADE_NOCTURNO_VERIFICACION.json. Los commits documentales posteriores no alteran esta APK.

El creador eligió Jade nocturno y aprobó su extensión e implementación. Rama de trabajo: `feature/jade-nocturno`, v0.25.0-jade, basada en `docs/documento-maestro-android@3a468de`; conserva R1.1 y el documento maestro. PR21/22 siguen siendo dependencias pendientes de conciliación; no se han integrado. Dev continúa en29be7ba y main en9ef7af7. Esta autorización habilita el bloque visual; no habilita E6 ni cambios de reglas, balance, canon o guardado.

Implementación y protocolo: [JADE_NOCTURNO_IMPLEMENTACION.md](docs/JADE_NOCTURNO_IMPLEMENTACION.md). Tema, marcos/iconos propios y composiciones de inicio, regiones, equipo/colección, Libro, Bestiario, perfil y ajustes; HUD de combate con detalles al tocar. Arte canónico existente conservado. Comprobaciones locales Godot4.7.2 y Python satisfactorias; prueba física Android pendiente. Consultar PR/CI de la rama para la evidencia publicada; no confundir con Preview45.

SIGUIENTE PASO: acompañar validación física de Preview46; integrar solo tras aprobación identificable y revisión de la cadena de PR.
RESPONSABLE: WORK.
INSTRUCCIÓN PARA CONTINUAR: En axenoban/karmany-monsta-android verifica HEAD/PR/CI reales de feature/jade-nocturno, lee JADE_NOCTURNO_IMPLEMENTACION.md y contrasta la APK con el SHA publicado. Acompaña la prueba física; corrige fallos visuales reproducibles sin alterar reglas ni guardados. No integres dev/main antes de aprobación de esta candidata.


## Consolidación documental · 12/11/2026

Punto de entrada portable: `docs/DOCUMENTO_MAESTRO_ANDROID.md` (rama docs/documento-maestro-android). Reúne bases, estado real, contratos, datos exactos y guía de recuperación/compilación. Sin cambios funcionales ni integración de PR21: dev29be7ba, candidata6365654. CI histórica38955362578 correcta; no se ejecutaron nuevas pruebas de juego en esta consolidación. La recuperación de otros chats registra pruebas físicas satisfactorias, pero GitHub mantiene PR21 abierto; conciliar autorización y cierre antes de integrar.

SIGUIENTE PASO: revisar el documento y la evidencia de cierre R1.1. RESPONSABLE: CHAT. INSTRUCCIÓN PARA CONTINUAR: Revisa DOCUMENTO_MAESTRO_ANDROID.md y PR21/Preview45 en axenoban/karmany-monsta-android; concilia aprobación física y estado de GitHub sin modificar código ni iniciar E6/R2–R4.


## Entrega vigente · R1.1 candidata pendiente de prueba física · 17/10/2026

Preview45/v0.24.0-r1.1, código636565422baa63dd4cc0f5026e55361ccd8f4fe1, PR21 abierto/borrador, CI38955362578 correcta. SHA256701108382045758c013bb5ed5cceaddeae4e5f5970822770fb704b3c5242ef08. Implementados NAV-01 y QA-01;5.857 checks Godot/31 suites y3 Python, firma compatible. Consultar ROADMAP_ESTADO y R1_1_IMPLEMENTACION para evidencia y seis pruebas físicas. **CHAT revisa en lectura; creador prueba. No integrar dev/main hasta «prueba correcta, Preview45».** Dev29be7ba y main9ef7af7 permanecen intactos. No E6/R2–R4. Las entradas inferiores son históricas y no anulan esta entrega. Mantener el traspaso obligatorio.


## Estado vigente · R1.1 autorizada (16/10/2026)

El creador aprobó expresamente implementar **R1.1 — NAV-01/Atrás contextual y QA-01/laboratorio aislado**. Contrato obligatorio: `docs/R1_1_NAVEGACION_LABORATORIO_QA.md`. **Work es único escritor de código** y debe iniciar rama `feature/r1-1-navegacion-qa` desde HEAD vigente de dev tras verificar Git/PR/CI. El laboratorio jamás toca `user://profile.json` ni sus respaldos: niveles1–15, equipos1–3, 12 puntos, perfil QA separado. **Solo contrato/documentos creados por Chat hasta ahora; ninguna APK/CI/PR funcional de R1.1 confirmada.** Baseline aprobado R1/Preview42 código `293ac5e`, CI38889069848, PR20 integrado; dev anterior `672684b`. Sin E6, R2, R3, R4, reglas, balance ni cambios en main/dev antes de validación física. Tras este encabezado, los apartados de R1 «no iniciar nuevas funcionalidades» son históricos y no invalidan la autorización explícita de R1.1. Más detalles de responsable/instrucción en docs/ROADMAP_ESTADO.md.


Antes de actuar, leer `docs/ROADMAP_ESTADO.md`, `docs/ROADMAP_CHAT_WORK.md` y `docs/CONTINUIDAD.md`; verificar HEAD, historia, PR, diferencias y CI reales. Los documentos históricos no sustituyen GitHub ni las instrucciones actuales del creador.

## Estado vigente R1

Preview42/v0.23.0-r1 aprobada físicamente el16/10/2026; código293ac5efb1b781258065171384db58db47b77aec, CI38889069848 y SHA256f63f31c12b2588bf7b65dd13f390d4ceb7b8ad9af18abe104960e4d1a81f84f1. R1 completada e integrada por fast-forward a21c2964; PR20 cerrado/merged verificado. Consultar ROADMAP_ESTADO/CONTINUIDAD para la aprobación exacta y HEAD real. No atribuir pruebas físicas individuales no especificadas. NAV-01/Atrás contextual y QA-01/laboratorio aislado quedan pendientes R1.1 para entrega independiente, sin programar en este cierre. No E6/R2–R4 ni nuevas funcionalidades. Los baselines inferiores son históricos y se conservan.

## Baseline y etapa vigentes

**Baseline funcional aprobado:** Preview40 / v0.22.1-e5, código `0c356db0fcf003e6c6f56e109d9e1e85addfea1d`, CI38833949394 y SHA256 `b0499b43cea54b6b22f41291ec1f2d979fd06aca919fd2916d2e16180a657ea1`. El creador confirma el 15/10/2026 «Prueba correcta, Preview40», seis comprobaciones satisfactorias y autoriza el cierre seguro E5. Registrar solo esas pruebas declaradas. E5-REV-01 corregida/revisada por Chat. **E5 completada e integrada:** PR19 closed/merged verificado tras fast-forward de dev08ed2e7 a `1329bee479b013c753b6a2d631b3b840f11ee13c`; dev y feature idénticos. El commit documental posterior registra el cierre; comprobar HEAD real y registros ROADMAP_ESTADO/CONTINUIDAD antes de actuar.

E5 implementa únicamente el contrato de `docs/E5_PRIMERA_SESION.md`; su especificación histórica se conserva. Preview38/R0 continúa preservada (dos regiones/12 etapas, E1/E2 y partidas). **E6 NO INICIADA: el creador prohíbe comenzarla en este cierre.** No preparar su implementación ni asignar un nuevo bloque; Chat solo verifica cierre en lectura y ambos esperan nuevas instrucciones. No queda autorizado un escritor de nuevas funcionalidades.

## Ramas, validación y protección

- `main`: versiones publicables; no modificar durante este cierre.
- `dev/karmany-core`: última versión completa validada.
- `feature/*`: trabajo pendiente de validación.
- «Prueba correcta» sobre APK/SHA identificable autoriza el cierre e integración segura, preferentemente fast-forward. «Continúa» por sí solo no aprueba.
- No force push, no reescribir historia, no merges ciegos, no eliminar ramas/releases anteriores. Verificar ascendencia y HEAD antes y después de integrar. Si dev avanzó, revisar diferencias e incorporar su historia de forma trazable; nunca forzar un falso avance lineal.
- Conservar guardados, contratos, reglas, canon, economía y sistemas estables. No inventar contenido ni modificar balance sin decisión aprobada.
- Buscar el primer error real; no debilitar tests, asserts o controles para ocultarlo. Ejecutar las regresiones correspondientes a cambios transversales.
- CI verde no reemplaza prueba física. Registrar aprobación real sin atribuir casos o dispositivos no detallados.

## Protección permanente contra la divergencia

La auditoría `docs/AUDITORIA_DOS_LINEAS_2026-10-15.md` documentó el retroceso de Preview32 (dos regiones/12 etapas) a cuatro etapas en otra línea. La recuperación editable y su integración están resueltas en Preview38; consultar `docs/UNIFICACION_JADE_BOSQUE.md`. **No volver a partir de la línea de cuatro etapas ni perder regiones, criaturas, arte, flujos, migraciones, relevo E1 o motor E2.** No presentar GDC como fuente editable ni recrear contenido ya recuperado. Los bundles y evidencias se conservan.

## Coordinación Chat / Work

Un único escritor por bloque y archivos compartidos. Chat analiza, especifica, revisa y controla calidad; Work implementa, prueba y compila cuando el bloque esté aprobado y asignado. Lecturas simultáneas sí; escrituras concurrentes sobre motor, reglas o documentos de estado no. La asignación expresa del creador tiene prioridad.

Tras avances, fallos, interrupciones, validaciones o traspasos, el dueño actualiza `ROADMAP_ESTADO.md` y `CONTINUIDAD.md` en la misma rama: alcance real, responsable, SHA/PR/CI/APK, pruebas ejecutadas, aprobación, límites y siguiente acción. No declarar integrado antes de verificar GitHub.

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


## Skills especializadas de desarrollo (14/11/2026, rama feature documental)

Existen cinco procedimientos locales en `.agents/skills/` (`godot-ui-ux`, `game-visual-system`, `godot-ui-implementation`, `android-game-qa`, `godot-gameplay`) y guía en `docs/SKILLS_DESARROLLO.md`. Al trabajar sobre UI o gameplay, cargar la skill pertinente junto con estas instrucciones. Las skills son procedimientos de Codex/Work, no autorizan fases ni cambios canónicos, no cambian reglas y NO prevalecen sobre este `AGENTS.md`. El PR24 contiene kit visual propuesto, no automáticamente aprobado; verificar PR/rama real antes de integrarlo. Validar metadatos con `python ci/validate_skills.py`. Este bloque se incorporó en una feature independiente de `dev/karmany-core`, no en `main` ni en dev.
