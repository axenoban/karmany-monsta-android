# KARMANY MONSTA · ANDROID

## R1.1 · Preview45 candidata entregable · 17/10/2026

**Implementación y validación técnica terminadas. Pendientes revisión Chat y prueba física del creador. NO integrada.**

- Rama `feature/r1-1-navegacion-qa`, [PR21](https://github.com/axenoban/karmany-monsta-android/pull/21) abierto/borrador, código funcional **`636565422baa63dd4cc0f5026e55361ccd8f4fe1`**. El commit documental de esta entrega no modifica código ni APK.
- **Preview45 / v0.24.0-r1.1**, [descargar APK](https://github.com/axenoban/karmany-monsta-android/releases/download/android-preview-45/karmany-monsta-preview.apk),83.404.111 bytes, paquete `com.axenoban.karmanymonsta.preview`, versionCode1045.
- **SHA-256:** `701108382045758c013bb5ed5cceaddeae4e5f5970822770fb704b3c5242ef08`. Descarga completa contrastada con `apk.sha256`; metadatos internos confirman código6365654/build45.
- [CI38955362578](https://github.com/axenoban/karmany-monsta-android/actions/runs/38955362578) correcta: **5.857 comprobaciones en31 suites Godot**, sin duplicar renders de suites repetidas;3 tests Python. R1.1:233 comprobaciones funcionales/aislamiento y32 de interfaz;8 renders nuevos. Export y firma v2/v3 correctos. Certificado SHA256 `756c8c1a8136ae2e80987c540d805641d7bfd2d5b657d1f04584f0074ac61bf8`, igual aPreview42.
- APK comparada conPreview42:11 JSON de juego idénticos y122 entradas de recursos gráficos/audio/importación idénticas. Solo3 scripts existentes cambian (App/Main/TrialUI) y4 scripts nuevos implementan navegación/QA. Sin pruebas/documentos/CI empaquetados. Evidencia: `docs/R1_1_CANDIDATA_VERIFICACION.json`.
- NAV-01 y QA-01 implementados; guardado QA fijo y protegido, presets1–15/equipo1–3/12 etapas, reinicio y callbacks aislados. Se corrigieron durante validación la conservación del preset, preferencias visuales y espacio de botones. Preview43/44 quedan como iteraciones superadas, no candidatas finales.
- **Dev sigue en29be7ba3d30ea72e860f62ec4f0c8aa766e6d1b4; main en9ef7af778ee59a47f62bdfbfd5eb0786ce787213.** No E6/R2–R4, reglas, balance, canon ni PS persistentes modificados. No se atribuye ninguna prueba física dePreview45.
- Instalar sobrePreview42 sin desinstalar y ejecutar las seis comprobaciones de `docs/R1_1_IMPLEMENTACION.md`: regreso contextual, botón/gesto, encuentro conservado, QA Velo6/equipo3, salida sin contaminación y reapertura normal/letras grandes. Solo **«prueba correcta, Preview45»** autoriza preparar integración segura.

**SIGUIENTE PASO:** Chat revisa PR21/contrato/evidencias en lectura y acompaña la prueba física dePreview45.
**RESPONSABLE:** CHAT.
**INSTRUCCIÓN PARA CONTINUAR:** En axenoban/karmany-monsta-android revisa en lectura R1.1/PR21, código636565422baa63dd4cc0f5026e55361ccd8f4fe1, CI38955362578 y Preview45/SHA701108382045758c013bb5ed5cceaddeae4e5f5970822770fb704b3c5242ef08. Contrasta docs/R1_1_NAVEGACION_LABORATORIO_QA.md, R1_1_IMPLEMENTACION.md y R1_1_CANDIDATA_VERIFICACION.json; acompaña las seis pruebas físicas. No modifiques código ni integres dev/main antes de confirmación explícita «prueba correcta, Preview45». No E6/R2–R4.


## R1.1 AUTORIZADA · contrato implementable registrado · 16/10/2026

- **Nueva autorización del creador:** «Sí, autorizo» para **R1.1 — NAV-01 + QA-01**. La autorización corresponde a la solución descrita por Chat: Atrás contextual, y laboratorio configurable de niveles, equipos y 12 etapas sin alterar el guardado real. **No requiere otra ronda de diseño ni autorización adicional para que Work programe estos dos módulos.**
- **Contrato ejecutivo:** [docs/R1_1_NAVEGACION_LABORATORIO_QA.md](R1_1_NAVEGACION_LABORATORIO_QA.md). **NAV-01:** conservar procedencia entre pantallas y no apilar redibujos. **QA-01:** perfiles QA en almacenamiento separado (sin tocar `user://profile.json` ni sus copias), presets de entrenador y Karmany Nv.1–15, equipo1–3, puntos1–6 de Jade y Velo, stamina y reinicio QA, solo builds de prueba. Validación rigurosa con modelos existentes; no debilitar reglas.
- **Baseline funcional:** R1/Preview42 aprobada e integrada, PR20 cerrado; código `293ac5efb1b781258065171384db58db47b77aec`, CI `38889069848`, SHA APK `f63f31c12b2588bf7b65dd13f390d4ceb7b8ad9af18abe104960e4d1a81f84f1`. Dev antes de documentación R1.1: `672684b6167cc1537f8cf6bafd6831fc9de889fb`. El HEAD actual incluye solamente el nuevo contrato/documentos, no código nuevo. Verificar HEAD real al iniciar Work.
- **Responsable funcional exclusivo: WORK**, autorizado a comenzar implementación después de verificar HEAD/ramas/PR y leer contrato; nueva rama `feature/r1-1-navegacion-qa` desde dev real. No existe todavía PR, CI o APK de R1.1; Chat registra diseño/estado sin tocar scripts.
- **Exclusiones:** No iniciar E6, R2–R4, cambios de PS, curación, balance, canon, contenido, regiones ni otras funciones. No tocar `main`; no integrar `dev` hasta prueba física explícita de APK candidata R1.1.
- **Verificaciones obligatorias:** CI y pruebas con bytes idénticos de guardados reales antes/después de QA, navegación originaria y escenarios QA, cierre/reapertura, firma/actualización, pruebas físicas de creador.
- Las entradas inferiores sobre R1.1 «pendiente de autorización» y PR20 «abierto» son **históricas**; no prevalecen sobre este checkpoint.

**SIGUIENTE PASO:** Work implementa NAV-01 y QA-01 en rama independiente y entrega PR + CI + APK candidata (numeración verificada).
**RESPONSABLE:** WORK (único escritor de código, al ejecutar el encargo en Work); CHAT audita resultados.
**INSTRUCCIÓN PARA CONTINUAR:** «El creador autorizó R1.1. En axenoban/karmany-monsta-android verifica HEAD/PR/CI y lee AGENTS.md, ROADMAP_ESTADO.md, ROADMAP_CHAT_WORK.md, CONTINUIDAD.md y docs/R1_1_NAVEGACION_LABORATORIO_QA.md. Implementa solo NAV-01 y QA-01 en feature/r1-1-navegacion-qa desde dev vigente. El laboratorio debe tener guardado QA completamente separado del perfil real; niveles 1–15, equipo 1–3, 12 etapas. No E6/R2–R4 ni cambios de reglas. PR/CI/APK SHA verificable; no integrar sin «prueba correcta» del creador.» 


## R1 · aprobación física y cierre seguro · 16/10/2026 (America/La_Paz)

> «Prueba correcta, Preview42. Autorizo a Work a verificar y preparar el cierre seguro de R1/PR20. La corrección de Atrás y el laboratorio QA quedan para una entrega posterior independiente. No iniciar E6 ni R2–R4.»

**Estado: R1 COMPLETADA, APROBADA FÍSICAMENTE E INTEGRADA; PR20 cerrado/merged verificado.** Aprobación general de Preview42; no se atribuyen dispositivo, número de arrastres ni pruebas individuales no especificadas. NAV-01 y QA-01 son incidencias aceptadas y diferidas; esta aprobación no afirma que Atrás esté corregido en todos los contextos.

- Preview42 / v0.23.0-r1, código `293ac5efb1b781258065171384db58db47b77aec`, CI [38889069848](https://github.com/axenoban/karmany-monsta-android/actions/runs/38889069848) correcta, SHA256 `f63f31c12b2588bf7b65dd13f390d4ceb7b8ad9af18abe104960e4d1a81f84f1`. Se conserva la misma APK, sin recompilar.
- **Integración verificada:** fast-forward no forzado de dev `ce6917a61ab4dadd9e06296854361d9b9a56f22c` a `21c2964e0da17f58a1d7a413615a5f8138e95a61`. GitHub confirma PR20 closed/merged=true; feature y dev idénticos. Árbol scripts igual al código aprobado: `fd8699bddd52f1f5960b63f0e0c30958963e145b`. El commit documental que contiene este cierre avanza después ambas ramas sin código nuevo; consultar HEAD real. SHA publicado de APK vuelto a consultar y coincidente.
- Comprobación inicial real: dev `ce6917a61ab4dadd9e06296854361d9b9a56f22c`; feature `21c2964e0da17f58a1d7a413615a5f8138e95a61`; PR20 único abierto, mergeable. Merge-base=dev, ahead3/behind0. Desde código293ac5e solo cuatro documentos; no existe código posterior sin validar.
- Evidencia técnica anterior:5.560 checks Godot/29 suites +3 Python,26 renders R1; importación/exportación/firma v2/v3 correctas. Este cierre documental no ejecuta ni atribuye nuevas pruebas de juego. E5, dos regiones6+6, partidas anteriores y sistemas estables se conservan mediante identidad del código aprobado.
- main `9ef7af778ee59a47f62bdfbfd5eb0786ce787213` protegida. Sin funciones nuevas, cambios de reglas/balance/canon/PS, force push ni eliminación de historia o ramas.

### Pendientes R1.1 · sin implementación autorizada en este cierre

- **NAV-01:** algunos botones Atrás regresan al menú principal; pendiente navegación contextual hacia el mapa/escenario de procedencia. Aceptada y diferida por el creador.
- **QA-01:** pendiente laboratorio con niveles, equipos y regiones configurables, totalmente aislado del guardado real. No implementar ni usar la partida real como laboratorio en este cierre.

**SIGUIENTE PASO:** Chat verifica el cierre en lectura y mantiene NAV-01/QA-01 pendientes para entrega independiente; esperar autorización/contrato específico antes de implementarlas. **RESPONSABLE:** CHAT. **INSTRUCCIÓN PARA CONTINUAR:** En axenoban/karmany-monsta-android verifica HEAD real de dev, feature/r1-navegacion-identidad, main y PR20; contrasta Preview42/código293ac5e/CI38889069848/SHA registrado y aprobación literal. Revisa solo en lectura el cierre y los pendientes R1.1 NAV-01/QA-01. No escribas código ni integres nuevas funciones ni inicies E6/R2–R4; espera instrucciones del creador para la entrega posterior.

Los registros inferiores son históricos; las solicitudes previas de prueba física han quedado superadas por la aprobación expresa anterior.

## R1 AUTORIZADA PARA WORK · ejecución pendiente de confirmación técnica (15/10/2026)

- **Aprobación explícita del creador:** «sí, autorizo a work para que comienze con la implementacion». Corresponde únicamente al contrato cerrado [docs/R1_NAVEGACION_IDENTIDAD.md](R1_NAVEGACION_IDENTIDAD.md) y a sus cinco módulos R1-01…05: prólogo cinematográfico Axe/Ezel; navegación; Bestiario visual; perfil Ezel; árbol táctil.
- **Responsable exclusivo de escribir código: WORK.** Chat no desarrollará la misma rama y auditará solo en lectura. La autorización **no equivale** a que Work ya haya iniciado, creado rama, ejecutado CI o publicado APK; Work debe verificar el estado remoto antes de actuar.
- **Baseline funcional conservado:** Preview40 aprobada, código `0c356db`, CI38833949394, PR19 integrado. `dev/karmany-core` avanza únicamente por documentación de autorización, no por nueva funcionalidad. Comprobar HEAD real antes de crear rama.
- **Exclusiones:** no comenzar R2, R3, R4, alfa E6 ni implementar PS persistentes, curación, cambio de reglas, balance, canon o regiones; no tocar `main`. Conservar guardados Preview32/E2/38/40, E5 y dos regiones.
- **Puerta de integración:** Work debe entregar PR/CI/APK con commit y SHA verificables; revisión Chat y «prueba correcta» explícita de esa APK por el creador antes de integrar en dev.

**SIGUIENTE PASO:** Work comprueba HEAD/PR/CI, crea (si no hay otra activa) `feature/r1-navegacion-identidad`, implementa el contrato en su totalidad, prueba, publica PR y APK candidata y solicita validación física.
**RESPONSABLE:** WORK (único escritor R1).
**INSTRUCCIÓN PARA CONTINUAR:** «En axenoban/karmany-monsta-android, el creador autorizó implementar R1. Verifica HEAD actual de dev, ramas y PR, lee AGENTS, ROADMAP_ESTADO, ROADMAP_CHAT_WORK, CONTINUIDAD y docs/R1_NAVEGACION_IDENTIDAD.md. Ejecuta exclusivamente R1-01…05; añade regresiones/CI/APK candidata; no integres sin aprobación física, no toques main y no inicies E6 ni R2–R4. Devuelve PR, commit, CI, SHA APK y pruebas».


## Diseño R1 cerrado · prólogo cinematográfico Ezel/Axe · 15/10/2026

- Decisión humana: **Ezel** es protagonista controlado; **Axe** es su mentor. El creador aprobó **introducción cinematográfica** antes de explorar (no combate guiado) y pidió cerrar la especificación.
- **Contrato listo para autorización de ejecución:** [docs/R1_NAVEGACION_IDENTIDAD.md](R1_NAVEGACION_IDENTIDAD.md). Alcance R1-01 prólogo / R1-02 navegación / R1-03 Bestiario visual / R1-04 perfil Ezel / R1-05 árbol táctil. Contrato incluye condiciones de guardados antiguos, 21 especies canónicas y 13 de combate, Zephyr inicial separado del catálogo, 11 pruebas de aceptación y microcopias.
- **Solo documentación nueva, sin programación R1 ni CI ni APK candidata.** Preview40/E5 mantiene código funcional aprobado `0c356db`, CI38833949394; PR19 cerrado. No se atribuye nueva prueba física ni se considera la alfa E6 certificada. R2/R3/R4 quedan fuera y no iniciadas.
- **Puerta de aprobación:** el contrato queda cerrado en diseño, pero Work no está autorizado a implementarlo hasta orden expresa del creador. `main` no debe cambiar; no tocar reglas, balance ni partidas.

**SIGUIENTE PASO:** solicitar autorización expresa para que Work programe solamente R1-01…05 desde HEAD verificado.
**RESPONSABLE:** CHAT (especificación terminada; ningún escritor funcional asignado).
**INSTRUCCIÓN PARA CONTINUAR:** «Con docs/R1_NAVEGACION_IDENTIDAD.md y la Preview40 de base, autoriza o rechaza la implementación de R1. Work solo tras aprobación ejecutará el contrato en feature propia, PR/CI/APK, sin E6 ni R2–R4, esperando prueba física antes de integrar».

## Roadmap coordinado de Chat + Work


## Estado vigente · aprobación física de E5 / cierre autorizado (15/10/2026, America/La_Paz)

**Estado: E5 COMPLETADA, APROBADA FÍSICAMENTE E INTEGRADA; cierre verificado.** E5-01…12 y corrección E5-REV-01 aprobadas por el creador sobre **Preview40/v0.22.1-e5**.

> «Prueba correcta, Preview40. Confirmo que realicé satisfactoriamente las seis comprobaciones indicadas y autorizo a Work a preparar el cierre seguro de E5. No iniciar E6.»

- **Código funcional aprobado:** `0c356db0fcf003e6c6f56e109d9e1e85addfea1d`. [CI38833949394 correcta](https://github.com/axenoban/karmany-monsta-android/actions/runs/38833949394): 5.149 checks únicos Godot/28 suites +3 Python, exportación/firma v2/v3 y auditoría. No se ejecuta ni atribuye nueva CI a cambios solo documentales.
- **APK aprobada:** [Preview40](https://github.com/axenoban/karmany-monsta-android/releases/download/android-preview-40/karmany-monsta-preview.apk), SHA256 `b0499b43cea54b6b22f41291ec1f2d979fd06aca919fd2916d2e16180a657ea1`; manifest de SHA publicado vuelto a consultar y coincidente. Evidencia en `docs/E5_CANDIDATA_40_VERIFICACION.json`.
- **Alcance de la evidencia humana:** seis comprobaciones satisfactorias expresamente confirmadas por el creador; E5-REV-01 revisada por Chat según la instrucción de cierre. No se atribuyen dispositivo, datos de rendimiento, sesiones adicionales ni prueba independiente con persona novata no declarados.
- **Git previo verificado:** dev `08ed2e70b35bfd1489fd9d88a5cdff52e9447dc2`, feature `6dc3c3dd0ce176558de37d719b84a9018d26b67d`, PR19 abierto/no integrado. Merge-base=dev, ahead4/behind0. Entre código0c356db y feature6dc3c3d solo cuatro documentos; sin funcionalidad posterior no validada.
- **Integración realizada y verificada:** fast-forward no forzado de dev desde `08ed2e70b35bfd1489fd9d88a5cdff52e9447dc2` a `1329bee479b013c753b6a2d631b3b840f11ee13c`. GitHub confirma PR19 **closed / merged=true**, dev y feature idénticos, cero diferencias. No se creó un merge alternativo ni se reescribió historia. El commit documental posterior solo registra esta comprobación; consultar su HEAD real para la referencia final.
- **Protección:** main `9ef7af778ee59a47f62bdfbfd5eb0786ce787213` sin cambios. Preview38 permanece incluida, 2 regiones/12 etapas, contenido/arte, motor E1/E2, migraciones, guardados, XP/vínculo y sistemas estables preservados. El cierre solo toca AGENTS/documentación/evidencias, sin nueva APK ni cambios de reglas, balance o canon.
- **E6 NO INICIADA y NO AUTORIZADA en esta intervención.** No hay nueva implementación activa tras este cierre. Se conservan ramas/releases/historia; sin force push.

**SIGUIENTE PASO:** verificar el cierre real de E5 y esperar instrucciones del creador, sin iniciar E6.
**RESPONSABLE:** CHAT (auditoría de solo lectura, sin escritor funcional asignado).
**INSTRUCCIÓN PARA CONTINUAR:** En axenoban/karmany-monsta-android verifica HEAD real de dev/karmany-core, feature/e5-primera-sesion, main y PR19; contrasta el cierre E5 con Preview40/código0c356db, CI38833949394 y SHA aprobado. Revisa solo en lectura la integración, aprobación literal y continuidad. No hagas commits, merges, nuevas funciones ni inicies o prepares E6; espera instrucciones expresas del creador. Termina con siguiente paso, responsable e instrucción copiable.

Los checkpoints inferiores son históricos; sus estados de prueba pendiente no sustituyen la aprobación explícita actual.

## Historial previo del roadmap

## Prioridad operativa vigente · E5 aprobada para ejecución por Work (15/10/2026)

El creador aprobó explícitamente el contrato E5 y sus cuatro decisiones de UX. **Fuente vinculante: [E5_PRIMERA_SESION.md](E5_PRIMERA_SESION.md).** El diseño no está pendiente: **Work** debe implementar las 12 intervenciones contextuales en una sola feature desde `dev/karmany-core` verificado. Sin nueva narrativa, reglas, balance ni modificaciones a sistemas de Preview38. Requiere pruebas automáticas, guardados existentes, CI, APK candidata y validación física antes de integración.

Los apartados de abajo que dicen «Chat diseña E5» o «no iniciar E5» pertenecen a la etapa histórica de cierre R0, superada por esta autorización; mantienen valor como antecedentes, no bloquean a Work. `main` permanece protegida.

**SIGUIENTE PASO:** Work inicia bloque E5 autorizado. **RESPONSABLE:** WORK. **INSTRUCCIÓN PARA CONTINUAR:** consultar `AGENTS.md`, `ROADMAP_ESTADO.md`, `CONTINUIDAD.md` y `E5_PRIMERA_SESION.md`; comprobar HEAD y PR, crear `feature/e5-primera-sesion`, implementar únicamente E5 con tests/regresiones y APK, sin integrar antes de «prueba correcta».


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

Los apartados de partida y las especificaciones E1–E4/E7 documentan el recorrido histórico; sus tareas ya incorporadas no vuelven a abrirse. La prioridad vigente es E5, primero especificación de Chat, después implementación aprobada por Work.

**Versión de planificación:** 1.1 · **Documento original del 15 de octubre de 2026, incorporado íntegro y actualizado operativamente**  
**Objetivo inmediato:** una alfa cerrada realmente jugable y evaluable por jugadores externos.  
**Objetivo posterior:** beta sólida y, mediante una decisión posterior, versión comercial publicable.

> **Regla principal:** ambos agentes pueden leer e investigar en paralelo; solo uno debe escribir o integrar un bloque funcional sobre el baseline común. Chat reduce trabajo preparatorio y de revisión; Work ejecuta implementaciones acotadas, exportación y regresiones.

## AVISO DE ACTUALIZACIÓN: FUENTE MÁS AVANZADA RECUPERADA

**Antes de aplicar estas etapas: consultar [AUDITORIA_DOS_LINEAS_2026-10-15.md](AUDITORIA_DOS_LINEAS_2026-10-15.md) y [ROADMAP_ESTADO.md](ROADMAP_ESTADO.md).** Posteriormente a la redacción original se localizó una APK Preview32 con dos regiones/12 etapas y una rama Work E2 local no publicada en GitHub. La secuencia ordinaria E1→E2→E3 queda temporalmente subordinada a **R0 rescate → convergencia de Preview32 + E1 + E2 → pruebas de partidas anteriores**. Bosque del Velo no se considera nuevo contenido por inventar: existía en esa APK, y se debe preservar. Para lo que no se conserve como código fuente editable, reconstruirlo verificablemente en lugar de afirmar que está listo. Los roles exclusivos y controles de validación originales siguen vigentes.

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

## 10. Siguiente movimiento vigente · E5, especificación por Chat

R0/Preview38 ha sido aprobada físicamente. No volver a cerrar E1 de forma aislada ni rehacer E2, Jade o Bosque. La siguiente etapa pendiente es E5 (primera sesión autónoma). **No se inicia ni se diseña E5 durante el cierre de R0.**

Chat debe preparar primero un contrato con alcance/exclusiones, estados y textos propuestos, criterios de aceptación, pruebas de comprensión y regresiones de guardado/UI. Cualquier cambio de reglas, balance o canon queda como decisión pendiente. Work implementará después únicamente lo aprobado, desde dev validado y con un solo escritor.

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

## Cierre R0 y traspaso autorizado · 15/10/2026

Aprobación humana de Preview38/f0266ba y validación de Chat en PR18 registradas. Integración autorizada por fast-forward a dev; main intacta. E5 pendiente de especificación por Chat, no de implementación directa por Work. La regla permanente de cierre exige siempre SIGUIENTE PASO, RESPONSABLE (CHAT O WORK) e INSTRUCCIÓN PARA CONTINUAR lista para copiar.
