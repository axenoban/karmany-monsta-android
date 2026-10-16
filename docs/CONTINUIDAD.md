# Continuidad de Karmany Monsta

## R1 · entrega técnica Preview42 · 16/10/2026

- **HECHO:** R1-01…05 implementados según contrato: prólogo Axe/Ezel/Zephyr, navegación regional, Bestiario21 fichas/siluetas/datos reales, perfil Ezel/equipo y arrastre táctil del árbol. No E6/R2/R3/R4.
- **RAMA / PR / CÓDIGO APK:** `feature/r1-navegacion-identidad`, [PR20](https://github.com/axenoban/karmany-monsta-android/pull/20) abierto/borrador, no integrado; código `293ac5efb1b781258065171384db58db47b77aec`, árbol `b24c40e88a1ed3cc2b156942064daed394c3abb4`. El commit de esta evidencia solo añade documentación; no cambia el binario.
- **CI:** [38889069848](https://github.com/axenoban/karmany-monsta-android/actions/runs/38889069848) completa/correcta:5.560 checks únicos Godot/29 suites +3 Python, importación/exportación Android, firma v2/v3 y auditoría. Las repeticiones de render no suman checks únicos.
- **APK:** [Preview42 / v0.23.0-r1 / versionCode1042](https://github.com/axenoban/karmany-monsta-android/releases/download/android-preview-42/karmany-monsta-preview.apk),83.387.103 bytes; SHA256 `f63f31c12b2588bf7b65dd13f390d4ceb7b8ad9af18abe104960e4d1a81f84f1`. Descargada/verificada: paquete y fuente correctos, certificado de actualización idéntico a Preview40.
- **PRESERVACIÓN:**11 JSON de juego iguales al baseline;58 recursos compilados de arte/audio/icono iguales a APK40. Solo cinco scripts compilados existentes cambian (App/Main/SaveStore/SkillTreeMap/TrialUI) y se añaden dos de presentación. Migraciones, modelos de combate/regiones/progresión, estadísticas y JSON del árbol sin cambios. Schema3 conserva compatibilidad con extensión opcional `r1_intro`; campo ausente nunca fuerza prólogo.
- **PRUEBAS:**411 checks R1,26 renders normal/grande/960×540;40 arrastres sintéticos desde nodo/enlace/fondo, ratón/cancelación; siete fixtures generados ejecutando código exacto Preview40, además de69 Preview32/10 E2/7 Preview38. Carga sin reescritura, primario/backup/temporal, reconocimiento fallido no bloqueante, retorno, conservación E5, propiedad real, datos faltantes y equipo1–3. Suite histórica cubre recompensas únicas, finales, Sakuromushi, derrota/reemplazo, XP/vínculo y turnos.
- **INCIDENCIAS RESUELTAS:** área de arrastre demasiado estrecha y callback sobre vista retirada detectados/corregidos en prueba local inicial; notas de release heredadas de E5 corregidas. Sin fallo automatizado pendiente. La prueba de20 arrastres Android reales y validación física completa están pendientes; no se atribuyen a simulaciones de CI.
- **PROTECCIÓN REAL:** dev `ce6917a61ab4dadd9e06296854361d9b9a56f22c`; main `9ef7af778ee59a47f62bdfbfd5eb0786ce787213`, verificadas sin cambios. No force push ni historia eliminada. Guía: [R1_IMPLEMENTACION.md](R1_IMPLEMENTACION.md); evidencia: [R1_CANDIDATA_42_VERIFICACION.json](R1_CANDIDATA_42_VERIFICACION.json).

**SIGUIENTE PASO:** revisión Chat en lectura y seis comprobaciones físicas de Preview42 por el creador. **RESPONSABLE:** CHAT; Work conserva escritura para incidencias R1. **INSTRUCCIÓN PARA CONTINUAR:** En axenoban/karmany-monsta-android verifica HEAD de feature/r1-navegacion-identidad, PR20, CI38889069848 y candidata42/código293ac5e/SHAf63f31c12b2588bf7b65dd13f390d4ceb7b8ad9af18abe104960e4d1a81f84f1. Audita R1-01…05 contra contrato y evidencia, sin escribir. Acompaña prueba de R1_IMPLEMENTACION.md y solicita «prueba correcta, Preview42». No integrar ni iniciar E6/R2–R4. Solo aprobación física explícita permite que Work verifique después una integración segura.

Los registros inferiores son históricos y no sustituyen esta entrega ni su prueba física pendiente.

## R1 · implementación en curso · Work · 16/10/2026 UTC

Base remota verificada `ce6917a61ab4dadd9e06296854361d9b9a56f22c`; sin PR abiertos ni otra implementación R1. Rama única `feature/r1-navegacion-identidad` creada desde ese HEAD. main `9ef7af7` intacta, código baseline Preview40 `0c356db`, CI38833949394 correcta. Diferencias del baseline a dev exclusivamente documentales.

Primera implementación R1-01…05: prólogo opcional/transaccional de cinco viñetas; navegación regional y continuación; Bestiario ilustrado con propiedad real; perfil Ezel; zona de arrastre del árbol. Arte/datos/reglas preservados. Validación local completa:5.560 checks Godot/29 suites +3 Python;26 renders R1. Código inicial74ca7ea, PR20 borrador abierto. CI38888946147 iniciada; se corrige identificación de las notas de release heredadas de E5 y se espera nueva ejecución. Sin APK R1 entregada ni aprobación física. El SHA de este avance será el commit que contenga este registro.

SIGUIENTE PASO: terminar pruebas, revisión visual, PR/CI y APK candidata R1. RESPONSABLE: WORK. INSTRUCCIÓN PARA CONTINUAR: comprobar feature/r1-navegacion-identidad y contrato R1, corregir el primer fallo real, completar regresiones y entregar APK identificada; no integrar dev/main ni iniciar E6/R2–R4 antes de autorización.


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

## Entrega corregida E5-REV-01 · Preview40 · 15/10/2026

- **HECHO:** defecto P2 de cierre de Ayuda reproducido y corregido. Cerrar/Atrás cierran aunque falle persistir `seen`; Otra explicación avanza; aviso visible sin modal ni bucle. Reconocimiento fallido no se inventa en memoria y puede repetirse. Protección contra reapertura diferida cancelada.
- **RAMA / CÓDIGO APK:** `feature/e5-primera-sesion` @ `0c356db0fcf003e6c6f56e109d9e1e85addfea1d`, PR19 abierto, no integrado. Árbol fuente `e2f4ba6c8733c2b79ccc5838269e8801db1b4283`, igual al probado localmente. Commit posterior de evidencia solo documentación; ver HEAD real, sin recompilar esos registros.
- **CI:** [38833949394](https://github.com/axenoban/karmany-monsta-android/actions/runs/38833949394), Preview40, completa/correcta. **5.149 checks únicos Godot en28 suites +3 Python**. E5:601; cierre/persistencia:103. Renders repetidos no sumados otra vez. Import/export Android, firma v2/v3 y auditoría correctas.
- **APK:** [Preview40 · v0.22.1-e5 · versionCode1040](https://github.com/axenoban/karmany-monsta-android/releases/download/android-preview-40/karmany-monsta-preview.apk), 83374501 bytes; **SHA256 `b0499b43cea54b6b22f41291ec1f2d979fd06aca919fd2916d2e16180a657ea1`**. Descargada y contrastada con SHA de CI, paquete/build/source y certificado `756c8c1a8136ae2e80987c540d805641d7bfd2d5b657d1f04584f0074ac61bf8` correcto para actualizar.
- **PROTECCIÓN VERIFICADA:** de44 scripts compilados del APK39, solo cambia `context_help.gdc`; los otros43, 65 recursos gráficos/audio y los11 JSON de juego se conservan. Dos regiones6+6 intactas. App/Store/motores/migraciones sin cambios. Evidencia: [E5_CANDIDATA_40_VERIFICACION.json](E5_CANDIDATA_40_VERIFICACION.json).
- **PERSISTENCIA:** pruebas con archivo temporal bloqueado y destino inexistente comprueban botones reales, Atrás doble, avance, bytes exactos de primario+backup, perfil entero, recarga, repetición del tema no guardado y persistencia al reintentar correctamente. Partida antigua sigue sin campo E5 ni tutorial forzado. Fallo de almacenamiento inyectado solo en rutas aisladas de tests; no se pide llenar ni dañar almacenamiento humano.
- **VALIDACIÓN LOCAL:** suite completa y renders correctos:13 pantallas E5 (incluido aviso con texto grande) +22 regionales. Regresiones69 Preview32 +10 E2 +7 perfiles Preview38; recompensa única, derrota/reemplazo, XP/vínculo, interrupciones y continuidad intactos. La prueba anterior que exigía bloquear el cierre fue corregida conforme a AC-09 y reforzada con103 checks, no silenciada.
- **PENDIENTE EXTERNO:** nueva prueba Android física de APK40 y comprensión por al menos una persona novata sin guía verbal. Una prueba correcta de39 no valida este binario. No se declara validación humana ni cierre definitivo E5.
- **Ramas protegidas:** dev `08ed2e70b35bfd1489fd9d88a5cdff52e9447dc2`; main `9ef7af778ee59a47f62bdfbfd5eb0786ce787213`. No integración, force push, pérdida de historia ni E6.

**SIGUIENTE PASO:** Chat revisa la corrección en solo lectura y acompaña nueva prueba física de Preview40, incluida primera sesión autónoma.
**RESPONSABLE:** CHAT (Work conserva escritura únicamente para incidencias E5).
**INSTRUCCIÓN PARA CONTINUAR:** En axenoban/karmany-monsta-android verifica HEAD real de feature/e5-primera-sesion/PR19, contrato E5 y CI38833949394; revisa E5-REV-01 sobre código0c356db y evidencia de Preview40/v0.22.1-e5. No escribas ni integres ni inicies E6. Comprueba Cerrar/Atrás/Otra explicación, persistencia y oferta diferida; solicita prueba física nueva de APK/SHA y sesión con persona novata. Solo una nueva «prueba correcta» explícita sobre40 autoriza a Work a comprobar después una integración segura.

Los checkpoints inferiores son históricos y no sustituyen esta nueva candidata ni su validación pendiente.

## Corrección E5-REV-01 · Work · 15/10/2026

- Revisión real: PR19 abierto/no integrado, feature `6e96396`, dev `08ed2e7`, main `9ef7af7`. Código candidata39 `e9795fc` con CI38829976270 correcta. Sin otra implementación E5. Contrato E5 y coordinación releídos.
- Diagnóstico de Chat recuperado de la conversación: APTO CON CONDICIONES; E5-REV-01/P2, el fallo al guardar ayuda vista impedía cerrar y consumía Atrás. No hay comentario de revisión en el PR; no se inventa una referencia.
- Reproducido antes de corregir: la prueba de cierre no bloqueante falla en el código39. El test anterior exigía conservar la tarjeta al fallar: ese comportamiento contradice AC-09 y se reemplaza por cierre + conservación del perfil. Se añaden pruebas más estrictas; no se elimina ninguna protección de estado.
- Corregidos Cerrar, Atrás y Otra explicación: el reconocimiento se intenta sin impedir navegación. Error de escritura visible en una etiqueta no modal; no se finge guardado ni se cambia `seen` en memoria si falla. La explicación puede volver a aparecer en otra visita. Una llamada diferida ya cancelada tampoco reabre otra tarjeta.
- Fuente afectada: únicamente `context_help.gd` y metadatos0.22.1-e5; sin cambios a Store/App, migraciones, motores, estadísticas, XP, regiones ni reglas. Work conserva escritura, sin E6 ni integración.
- Regresión nueva `help_persistence_tests.gd`: fallos de archivo temporal y destino inexistente con botones reales/Atrás/Otra explicación, comparación de bytes primario+backup y perfil entero, cierre sin bucle, segundo Atrás, recarga/reintento exitoso y guardado antiguo sin campo E5. Suite completa local correcta: 5.149 checks Godot /28 suites +3 Python; incluye 103 de cierre/persistencia. Renders E5/regionales y aviso de error grande correctos. CI y nueva APK pendientes al registrar este avance; no se hereda aprobación física de39.

**SIGUIENTE PASO:** terminar suite completa/render, CI y nueva APK candidata de corrección.
**RESPONSABLE:** WORK.
**INSTRUCCIÓN PARA CONTINUAR:** verificar feature/e5-primera-sesion y PR19; concluir regresiones y exportación0.22.1-e5, registrar SHA/CI/APK y pedir nueva prueba física. No integrar en dev/main ni iniciar E6.

Los registros anteriores de Preview39 se mantienen como historia; su APK no contiene esta corrección.

## Entrega técnica E5 · Preview39 candidata · 15/10/2026

- **HECHO:** doce intervenciones aprobadas implementadas; tarjetas pequeñas descartables, Ayuda contextual, tutorial solo nuevo perfil/viaje confirmado y resumen permanente de derrota/XP. No E6 ni reglas nuevas.
- **RAMA / CÓDIGO APK:** `feature/e5-primera-sesion` @ `e9795fc20198c34bfe27b2126ed2b31ec4ee1a0c`, [PR19](https://github.com/axenoban/karmany-monsta-android/pull/19). Árbol `6207ae4570ef8648726a0b7af7b79efdb4d9b1cc`, idéntico al probado localmente. El commit que contiene este checkpoint solo añade evidencia/documentación; no cambia código ni APK.
- **CI:** [38829976270 / Preview39](https://github.com/axenoban/karmany-monsta-android/actions/runs/38829976270) completada, build y publicación correctos. 5.046 checks únicos Godot /27 suites +3 Python; 601 E5. Renders repiten comprobaciones sin contarlas dos veces. Exportación, firma v2/v3 y auditoría correctas.
- **APK:** [Preview39 · v0.22.0-e5 · versionCode1039](https://github.com/axenoban/karmany-monsta-android/releases/download/android-preview-39/karmany-monsta-preview.apk), 83.374.501 bytes; SHA256 `41578be4373256e46b7f26644be26a85ec15fe92c1fda08baf9382ce9a070bc7`.
- **Verificación descargada:** SHA coincide con CI, paquete `com.axenoban.karmanymonsta.preview`, build39/source e9795fc, helpers compilados presentes, seis puntos Jade +seis Bosque, tests/docs/ci excluidos. Certificado SHA256 `756c8c1a8136ae2e80987c540d805641d7bfd2d5b657d1f04584f0074ac61bf8`, igual a Preview32/E2/38. Evidencia: [E5_CANDIDATA_39_VERIFICACION.json](E5_CANDIDATA_39_VERIFICACION.json).
- **PRUEBAS:** suite completa local final correcta también sobre el árbol publicado. 69 Preview32 +10 E2 +7 perfiles cargados por fuente exacta Preview38; ninguna carga fuerza tutorial ni cambia bytes originales. Recompensa/bono únicos, stamina, reemplazo/derrota, XP parcial, vínculo y reanudación cubiertos por regresiones. 12 renders E5 normal/grande +22 regionales; Atrás, pausa, modo reducido, sonido y exclusión de animaciones comprobados técnicamente.
- **RESULTADO ESPERADO:** nueva partida comprende selección/coste/búsqueda/combate/resultado/vínculo/retomar; partida previa continúa sin tutorial automático y conserva acceso a Ayuda.
- **RIESGOS / PUERTA:** comprensión de una persona novata y Android físico siguen pendientes. No se atribuyen pruebas humanas. Instalar sin desinstalar; no usar Nuevo viaje sobre la partida que se quiera conservar. Prueba de máximo10 pasos en [E5_IMPLEMENTACION.md](E5_IMPLEMENTACION.md).
- **Protección:** dev conserva `08ed2e70b35bfd1489fd9d88a5cdff52e9447dc2`; main `9ef7af778ee59a47f62bdfbfd5eb0786ce787213`. PR19 abierto sin integración; Work conserva escritura para incidencias E5, Chat revisa en solo lectura.

**SIGUIENTE PASO:** revisión independiente de PR19 y validación física de Preview39 por el creador; sin E6.
**RESPONSABLE:** CHAT (revisión; Work corrige solo incidencias asignadas).
**INSTRUCCIÓN PARA CONTINUAR:** En axenoban/karmany-monsta-android verifica dev, HEAD real de feature/e5-primera-sesion, PR19, CI38829976270 y docs E5. Revisa solo en lectura las doce intervenciones contra E5_PRIMERA_SESION.md y la candidata39/código e9795fc. Emite APTO/APTO CON CONDICIONES/NO APTO con incidencias reproducibles; acompaña la prueba de máximo10 pasos de E5_IMPLEMENTACION.md y solicita al creador validación física de APK/SHA identificados. No hagas commits, merges ni E6. Solo «prueba correcta» explícita permite que Work verifique después una integración segura.

Los checkpoints que siguen son históricos; su CI/APK pendiente quedó resuelta por esta entrega técnica, no la aprobación humana.

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

## Checkpoint ACTUAL · E5 aprobada y traspasada a Work (15/10/2026)

El creador aprobó la especificación de «primera sesión autónoma, tutorial contextual y claridad de derrota/progresión» presentada por Chat, incluidos alcance, exclusiones, 12 intervenciones E5-01…E5-12, microcopias, criterios AC-01…AC-12 y regresiones. Ratificó cuatro decisiones:

1. Tarjetas pequeñas contextuales y descartables.
2. Tutorial automático una sola vez en partidas nuevas; guardados anteriores no forzados.
3. Opción `Ayuda` para repetir explicaciones cuando el jugador lo solicite.
4. Resumen breve siempre en derrota/progresión; detalles solo cuando correspondan.

**Contrato congelado:** [docs/E5_PRIMERA_SESION.md](E5_PRIMERA_SESION.md). **Próximo responsable/escritor exclusivo:** WORK. **Baseline de lectura verificado antes de redactar:** dev @ `76a7347f60605cc28259b0a087f4654b69a89164`, código aprobado Preview38 `f0266badaa7851da3de2bcc08a65752b6409360b`, PR abiertos: cero. Los nuevos commits de traspaso son exclusivamente documentales. Ninguna implementación, compilación, CI E5 ni prueba física E5 se afirma en este checkpoint.

**Proteger:** dos regiones/12 etapas, 13 criaturas de combate, E1, motor E2, continuidad E4, arte y compatibilidad de partidas Preview32/E2/Preview38. No reabrir balance/canon. `main` inalterada.

**SIGUIENTE PASO:** Work inspecciona HEAD real, crea `feature/e5-primera-sesion` desde la última dev validada, implementa solo el contrato y entrega PR/CI/APK con prueba local; E5 no se integra sin validación física.

**RESPONSABLE:** WORK.

**INSTRUCCIÓN PARA CONTINUAR:** «En `axenoban/karmany-monsta-android`, verifica HEAD, historia, PR y CI de `dev/karmany-core`. Lee `AGENTS.md`, `ROADMAP_ESTADO.md`, `ROADMAP_CHAT_WORK.md`, `CONTINUIDAD.md` y `E5_PRIMERA_SESION.md`. Ejecuta exclusivamente E5 aprobada en `feature/e5-primera-sesion`; integra 12 ayudas contextuales sin cambiar reglas ni sistemas estables, añade pruebas y regresiones Android/guardados, produce APK candidata/PR con CI. Actualiza registros en la feature y espera «prueba correcta» antes de integrar en dev. No tocar main.»

El historial de cierre R0 que aparece a continuación (solicitando especificación por Chat) es **anterior a esta aprobación**.


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

## Cierre operativo y traspaso

La orden actual se limita a cerrar la unificación. Se actualizan instrucciones, roadmaps y registro del baseline; no se toca ningún archivo funcional. La aprobación general no se convierte en una lista de casos físicos específicos no descritos. El entorno de ejecución local no está disponible en esta intervención; las verificaciones se realizan directamente contra GitHub y la evidencia de APK/CI ya descargada y registrada en la entrega anterior. No se afirma nueva ejecución de tests o compilación.

PR18 se integra mediante actualización no forzada de dev, con comprobación de ascendencia y HEAD esperado. PR17 está absorbido (00b2769 antecesor de 892a109), sin una segunda fusión. La integración debe verificarse después y conservar los releases/ramas anteriores. Solo se invocan herramientas de cierre; no se envían mensajes ni comentarios nuevos.

**SIGUIENTE PASO:** especificación E5 antes de programar.
**RESPONSABLE:** CHAT.
**INSTRUCCIÓN PARA CONTINUAR:**

```text
Continúa Karmany Monsta Android en axenoban/karmany-monsta-android. Verifica el HEAD real de dev/karmany-core y lee AGENTS.md, docs/ROADMAP_ESTADO.md, docs/ROADMAP_CHAT_WORK.md y docs/CONTINUIDAD.md. La Preview 38 (v0.21.0-unification, código f0266ba) está aprobada físicamente y la unificación está cerrada. Prepara únicamente el diseño y la especificación de E5: primera sesión autónoma, tutorial contextual y claridad de derrota/progresión. Define alcance, exclusiones, microcopias, criterios de aceptación, regresiones de guardado/UI y un bloque acotado con instrucción lista para Work. No programes ni modifiques reglas, balance, canon o sistemas estables. Distingue decisiones pendientes y espera su aprobación antes de autorizar implementación. Termina con SIGUIENTE PASO, RESPONSABLE (CHAT O WORK) e INSTRUCCIÓN PARA CONTINUAR.
```

## Historial anterior al cierre vigente

Los siguientes registros preservan el estado que había en cada checkpoint. Sus esperas de validación de R0/E1 y su baseline Preview29 son históricos, no el estado actual.

## Lectura inicial obligatoria
Leer este documento antes de cada proceso; `AGENTS.md` en la raíz establece esta instrucción para agentes compatibles. No depende del historial del chat. Un agente debe confirmar el estado real con git/CI y leer el código afectado; el documento no sustituye esa verificación.

## Proyecto y contrato del baseline Preview29 (histórico)
- Repositorio: axenoban/karmany-monsta-android. Godot 4.7.2, Android.
- main: publicación. dev/karmany-core: base validada. feature/*: mejoras pendientes.
- No force push, no pérdida de guardados, no cambios de reglas o canon sin aprobación.
- Cinco especies: Zephyr, Tanugami, Ushigane, Kitsunibi, Sakuromushi; personajes Ezel y Axe.
- Stamina 100; entradas 10/10/10/30; recuperación 1/minuto offline; objeto +30 limitado al máximo, 20% por victoria en localización, no entrenamiento.
- Cuatro lugares desbloqueados por victoria; captura opcional. Consultar ficha no gasta, retomar no cobra otra vez.
- Turno: resonancia opcional, habilidad/cambio, respuesta automática rival. Reemplazo por derrota sin ataque extra.
- Conservar anatomía y arte aprobado; los nombres de terreno son descriptivos, no canon nuevo.
- Libro: nivel4/coste1 y nivel8/coste2 aprobados para este bloque; no inventar mejoras adicionales.

## Última base aprobada
Preview29,0.17.0/versionCode1029, código a3d5dfffb93dd00242004295dd853f077875ec1a, documentación d6e960ab4bb480879ba2201f73113649f17a053c. Usuario confirmó «pruebas correctas, procede con la siguiente etapa» el14/10/2026 (America/La_Paz). Incluye progresión/Libro del bloque19 y resumen del bloque20. Integración por fast-forward en dev desde cb98974 a d6e960a verificada. CI38666473622 correcta:1390 Godot y3 Python, exportación/firma v2/v3/auditoría aprobadas. main conserva9ef7af778ee59a47f62bdfbfd5eb0786ce787213.

Historial: docs/BASELINE_VALIDADO.md. Movimiento reducido opcional/desactivado de inicio, normalización compatible, misma duración/audio y resultados. Audio22 efectos originales con volumen/silencio persistentes. Reglas y guardados de bloques anteriores aprobados.

## Bloque19: niveles, XP y Libro · implementación autorizada
Aprobación del creador14/10/2026: «es correcto, aplica esto a al proyecto». Leer docs/PROPUESTA_PROGRESION_19.md y docs/NIVELES_LIBRO_19.md. Rama feature/level-progression, base cb98974, versión0.16.0.

Reglas aprobadas e implementadas:25XP por victoria de localización al entrenador y a cada integrante del equipo, sin repartir;100×nivel actual para subir. Jade deja de darXP a cada individuo desde10, los inferiores siguen ganando y el excedente al llegar al límite se descarta. Entrenamiento libre/derrota/retirada sinXP. Capturas y nivel del entrenador anteriores conservados; XP parcial previa inexistente se inicia en0 y Karmany antiguos/nuevos en1. +5%Vida/Ataque/Defensa por nivel sobre base con redondeo; Velocidad y técnicas intactas.

Libro secuencial: Mejora1 Nv4/coste1punto; Mejora2 Nv8/coste2puntos, probabilidades ya aprobadas45/60/75%Común y rarezas de tabla original. Puntos compartidos con resonancias y gastos permanentes registrados en skill_tree.unlocks; redistribuir devuelve solo resonancias. Compras/reset normal fuera de encuentros activos. Encuentros nuevos congelan niveles y book_id; sesiones viejas mantienen política inicial y cifras hasta terminar.

Regiones configuradas en data/level_progression.json: Jade accesible Nv1/coste0/topeXP10. Regla de acceso/gasto preparada para futuras regiones configuradas; no se añadió una región ni un enemigo/encuentro sin canon aprobado. Entrenador sigue con el máximo actual10 hasta aprobar la siguiente región/progresión.

Persistencia: schema3 compatible con campos opcionales; campaign.progression contiene trainer_xp, units por instance_id y last_reward de victoria. Recibo, nivel/XP, puntos, ruta y recompensa se guardan juntos. Capturar no repiteXP; criaturas fuera del equipo no reciben. Escritura fallida no concedeXP ni consume puntos. Guardado JSON con máxima precisión de números; las pruebas comprueban los mismos resultados de las tiradas al recargar. Se normalizan perfiles de forma idéntica en memoria/disco para conservar enteros y migraciones.

Validación local:1348 comprobaciones Godot,174 nuevas de progresión, y3 Python correctas. Simulados combates a niveles1/5/10 contra cuatro rivales y revisadas pantallas normal/grande de Equipo, Libro, mapa, árbol, combate escalado y resumen deXP. CI38664822086 correcta:1348 Godot y3 Python, exportación/firma v2/v3/auditoría aprobadas. Código df4414419ec3012e514de5e5f59c9433c3d0fe88. APK0.16.0/versionCode1028: [Preview28](https://github.com/axenoban/karmany-monsta-android/releases/download/android-preview-28/karmany-monsta-preview.apk). [PR15](https://github.com/axenoban/karmany-monsta-android/pull/15). El commit posterior de documentación no cambia el APK. Validación confirmada por el creador sobre Preview29, que incluye este bloque. Prueba física docs/PRUEBA_ANDROID_19.md.

## Cierre y continuación
Aprobación e integración de bloques19/20 registradas. Ahora definir con el creador la siguiente región canónica: nombre/fuente, nivel de acceso, coste de puntos, tope deXP, especies/encuentros y niveles rivales. No inventar región, elevar el máximo del entrenador ni añadir rarezas jugables por disponer de probabilidades del Libro. Si se prioriza balance, medir duración de combates y ritmo deXP antes de proponer cambios numéricos para aprobación.

## Protocolo al terminar cada actualización
Actualizar bloque actual, estado probado y pendiente, rama y referencias verificadas, enlace de entrega cuando exista, riesgos reales y siguiente paso tras aprobación. Distinguir siempre CI/local de validación en dispositivo. Usar git log como referencia de commit cuando el documento forma parte del mismo commit, evitando autorreferencias imposibles.

## Bloque20: ventana de experiencia · solicitud actual
El creador pidió continuar y añadir una ventana con XP adquirida, barra que se llena y actualización de estadísticas al subir. Rama feature/experience-summary, parte de fcb5c28 (bloque19); versión0.17.0. Al implementarse no se supuso validación física de Preview28. Ahora el creador aprobó Preview29, que incorpora ambos bloques, y se integraron en dev por fast-forward; main no cambia.

Leer docs/PRUEBA_ANDROID_20.md y docs/NIVELES_LIBRO_19.md. experience_summary.gd presenta un recibo de solo lectura tras la victoria de localización: entrenador y equipo principal, retratos, XP aplicada, barra desde el valor anterior, pausa al completar, nivel nuevo y sobrante. Al subir muestra Vida/Ataque/Defensa antes→después con incremento y Velocidad sin cambios. Límite regional usa barra completa y etiqueta explícita. Sin nuevas reglas de XP, economía, especies o regiones.

El recibo incorpora before/after de nivel/XP y especie por integrante dentro de la misma transacción de victoria. Campos opcionales validados/normalizados; recibos de Preview28 siguen compatibles. Una marca temporal en App habilita la ventana solo después de guardar correctamente y se consume una sola vez. Recargar no vuelve a presentar una recompensa nueva; el resumen compacto sigue en la pantalla. La animación no escribe progreso y cerrarla antes de terminar conserva todo lo ganado.

Ventana modal con desplazamiento y Continuar siempre accesible. Atrás de Android cierra el resumen manteniendo el vínculo. Movimiento reducido muestra el resultado inmediatamente; modo normal anima2.4s y reutiliza un aviso sonoro existente al subir, respetando volumen/silencio. Audio y presentación pertenecen a la escena y se detienen al cerrarla. Sin XP/ventana en entrenamiento.

Validación local:1390 comprobaciones Godot (41 nuevas del resumen y una adicional del flujo Jade),3 Python; importación y git diff --check correctos. Revisión visual1280×720 con equipo de3, subida múltiple entre integrantes, límite regional, texto normal/grande, principio/final del desplazamiento. CI38666473622 completada correctamente:1390 Godot y3 Python; exportación, firma v2/v3 y auditoría de privacidad correctas. Código a3d5dfffb93dd00242004295dd853f077875ec1a. APK0.17.0/versionCode1029: [Preview29](https://github.com/axenoban/karmany-monsta-android/releases/download/android-preview-29/karmany-monsta-preview.apk). [PR16](https://github.com/axenoban/karmany-monsta-android/pull/16), borrador hacia dev, incluye el bloque19/PR15, también aprobado ahora. La documentación posterior no modifica el APK. Prueba confirmada por el creador el14/10/2026; ambos bloques integrados en dev.

Aprobación conjunta e integración de progresión/resumen completadas. Continuar definiendo la siguiente región con el creador (nombre/fuente, nivel de acceso, puntos, topeXP, especies/encuentros y niveles). No inventar contenido ni elevar el máximo actual10 sin esas decisiones.

## Bloque21: siguiente región · decisiones pendientes
Leer docs/PROPUESTA_REGION_21.md. Preparación basada en la Enciclopedia Oficial de Shisai, revisada directamente (páginas2 y8–9) el14/10/2026. Bosque del Velo es candidato recomendado por su conexión cartográfica con Valle Jade, no una región ya autorizada para implementar. Tres comunes propuestos: Suzumeko, Kodamashi y Mujina-Kage; fisiología canónica disponible, cifras/técnicas jugables no definidas.

Propuesta para decidir: acceso entrenador10/coste1punto/topeXP15 y100XP por victoria solo en Bosque (Jade mantiene25XP/tope10; requisito100×nivel intacto); preparar una propuesta experimental de estadísticas/técnicas para esas tres especies antes de programarla. Ni estos valores ni la selección están aprobados todavía. Falta fijar niveles rivales, nivel al vincular, número/orden de puntos y stamina. No ampliar level_cap del entrenador ni producir una región jugable hasta aprobar reglas completas. No importar mecánicas de las resonancias narrativas automáticamente.

Cierre actual: integración y revisión de historia/CI verificadas; actualización exclusivamente documental, sin nuevo APK ni necesidad de repetir pruebas de código. Siguiente acción: obtener decisiones de región/progresión/selección; después preparar tabla de combate y recorrido completos para aprobación. Tras esa aprobación, abrir feature/* e implementar el bloque regional con regresiones de guardados, puntos, XP, captura, navegación y combate.

## 2026-10-15 · Alerta crítica de convergencia (véase AUDITORIA_DOS_LINEAS_2026-10-15.md)

La última base Github validada en dev sigue siendo Preview29 más documentación. Tras comparar binarios recuperados en Library, se ha **confirmado** que una línea de desarrollo local anterior llegó hasta Preview32/v0.20.0 con seis encuentros Jade y seis Bosque del Velo, ocho criaturas extra, imágenes CTEX y scripts GDScript exportados como GDC. Ese código fuente no aparece en GitHub; los commits de Preview32 son locales/no accesibles en ese remoto. También se recuperó ZIP de Work E2 con git bundle incremental de `feature/e2-regional-engine`, código local `42fed0ce...`, nunca subido a GitHub; aunque su motor es nuevo, su APK solo muestra cuatro etapas de Jade. **No tratar la APK E1/E2 como sucesora con todo el contenido de Preview32.**

Nueva prioridad: conservar la línea avanzada en carpeta de rescate, recuperar fuente E2, preparar rama `feature/unificacion-jade-bosque` y alcanzar paridad funcional con Preview32 antes de nuevas etapas o integración en dev. Chat audita; Work propietario de escritura cuando se transfiera formalmente. Probar migración sin pérdida de partidas de Preview32 y E1/E2. La aprobación física de E1 sigue pendiente. No se ha creado ni probado todavía una APK unificada.
## E1 (15/10/2026): aprobación de Jade y relevo de Sakuromushi

El creador aprobó el paquete de seis etapas Jade, curva de XP, costes de stamina, encuentro final por relevos, elección de un vínculo, nuevas capturas al nivel encontrado, migración compatible y estadísticas/insignias experimentales de Sakuraneko e Inubari. Fuente completa: `docs/E1_JADE_RELEVO_2026-10-15.md`. No equivale a contenido todavía implementado.

Cambio solicitado: eliminar el gasto de una acción adicional para beneficiarse de la mejora a un aliado. Rama `feature/e1-jade-relay`, creada desde `dev/karmany-core` 4d1817a, ensaya solo Sakuromushi: golpe 70%, relevo automático antes de respuesta rival y +20% al entrante durante las dos rondas siguientes, sin suma aditiva entre buffs. Estas cifras nuevas se someten a validación antes de tratarse como balance final. Mantener `dev/karmany-core` en Preview29 mientras no existan pruebas y aprobación física. La rama incorpora regresiones de turno/cooldown/guardado/UI. CI aún pendiente de ejecutarse/confirmarse.

Siguiente E2 asignado a Work tras resolver esta rama: motor regional, XP/bonos por etapa, relevos enemigos y capturas a nivel rival, sin contenidos del Bosque. E3: añadir dos especies nuevas y terminar los seis puntos de Jade. No abrir ramas paralelas que modifiquen TacticalEncounter mientras E1 siga pendiente.

## Traspaso a Work y E2 (15/10/2026)
El creador autoriza expresamente tomar E1 como base y ejecutar las tareas de Work del roadmap Chat+Work. Base funcional de trabajo: origin/feature/e1-jade-relay 1719c6821319279f191734a0d4fbf836e9de428e, CI38777146974 correcta; PR17 abierta. No se interpreta como prueba física ni integración de E1. dev sigue4d1817a; main9ef7af7.

Único escritor de este bloque: Work, rama feature/e2-regional-engine derivada de E1. E2 prepara contratos regionales congelados, bonos únicos, reservas rivales secuenciales, elección única de vínculo, captura al nivel rival y XP multnivel. Conserva el ataque/relevo/buff de Sakuromushi de E1. Archivos reservados: scripts/regional_policy.gd, jade_route.gd, tactical_encounter.gd, app.gd, level_progression.gd, experience_summary.gd, trial_ui.gd, tests regionales, CI y documentación/versionado. No incorporar el código recuperado de Preview32 ni Bosque.

Frontera E2/E3: las cuatro ubicaciones publicadas siguen sus datos heredados mientras E3 no integre el paquete completo de seis ubicaciones y las dos especies. El motor consume datos regionales opcionales; las pruebas E2 activan contratos con especies existentes para comprobar persistencia y relevos. No presentar esos fixtures como contenido del juego. Validación técnica del bloque en curso; todavía sin APK nueva ni prueba física. Siguiente bloque después de revisión/validación: E3, Jade completo. E4 recuperará la continuidad visual solicitada.

Validación local E2: 1587 comprobaciones Godot correctas (22 suites; 186 regionales), tres Python, importación limpia y diff --check. Regresiones E1 intactas. Se corrigió normalización numérica JSON del contrato regional detectada por la prueba de recarga exacta; ningún assert se debilitó. Contrato, límites y prueba Android: docs/E2_MOTOR_REGIONAL.md. CI nueva aún no ejecutada; no atribuirle la CI de E1. Se prepara APK local E2 y respaldo de commits no sincronizados.

Entrega local E2: APK0.19.0-e2/código1035, código42fed0ce330366de891ad7944e50e6d79f5836d8. Exportación Godot correcta, firma v2/v3 verificada y auditoría de privacidad correcta. SHA256 eaf1b8c8e6e8df3e0497217f171b9dd103400f4d7f0875560b7a1570ffbb5f47. Compilación local; no hay CI nueva ni validación física. Actualizar desde E1/Preview29: este árbol no importa partidas de la rama divergente Preview30–32/Bosque. No instalar sobre esas partidas como una migración compatible.

No se reintenta el push bloqueado anteriormente por revisión automática sin autorización explícita para enviar el código. Se entrega un bundle Git incremental con los commits posteriores a E1, documentación y logs: permite restaurar exactamente esta rama tras mantenimiento sin duplicar el repositorio remoto. Próxima acción de Chat: auditar E2 contra E1; de Work: publicar la rama al autorizarse y ejecutar CI. Después de la validación correspondiente, E3 implementará Jade completo; E4 mantendrá el escenario a pantalla completa.

## R0 · Unificación autorizada (15/10/2026)
El creador asigna expresamente a Work la implementación y compilación de Preview32 + E1 + E2, con Chat como revisor de solo lectura. Rama única feature/unificacion-jade-bosque. Se verificó el bundle incremental (HEAD dc4a20a, requisito 1719c68 presente) y se recuperó feature/e2-regional-engine-recovered sin reescritura. Merge revisado: único conflicto documental, resuelto conservando ambos historiales. Preview32 y ZIP E2 coinciden con los SHA256 de la auditoría. No hay APK unificada ni migración probada todavía. dev/main intactos. Próximo paso: recuperar fuentes editables/arte de Preview32 y auditar contratos de guardado antes de integrar contenido.

## Checkpoint de implementación R1/R2 · 15/10/2026
Work es el único escritor autorizado; rama feature/unificacion-jade-bosque. Se recuperaron39scripts editables de Preview32 y97recursos; las doce imágenes regionales están comoPNG. Se integraron las dos regiones/12etapas,13criaturas de combate/21fichas, finales, UX de derrota/XP/vínculo de Preview32 con contrato/recompensas/persistencia E2 y relevo E1. No se inventaron cifras de Bosque: proceden de losJSON de laAPK.

Migración Preview32 probada con69guardados generados por su motor original, incluido combate abierto, respuesta pendiente, derrota, reemplazo yXPparcial;1846checks de unificación correctos. Respaldo .pre-unification conserva los bytes originales antes de escribir. Certificado Preview32/E2/keystore del repositorio idéntico. E2 publicada como importación fuente 1f65222 en feature/e2-regional-engine-recovered, con bundle original incluido; diff de fuente igual, salvo el bundle adicional.

Las22suites históricas pasan localmente; se añaden pruebas de UI regional y24simulaciones de balance sin cambiar cifras. Importación y3pruebasPython correctas. Compilación/CI y revisión gráfica remotas todavía pendientes en este checkpoint. No hay aprobación física ni integración en dev/main. Detalle de procedencia, comparación y prueba Android: docs/UNIFICACION_JADE_BOSQUE.md. Próximo paso de Work: terminar CI/exportación/firma y entregar laAPK candidata; Chat revisa en solo lectura.

## Checkpoint CI y revisión visual · 15/10/2026
Rama remota feature/unificacion-jade-bosque @55dc205, PR18 borrador contra dev; árbol remoto idéntico al árbol local probado (ad5bd6b). CI38823615057 iniciada, todavía no se afirma éxito en este checkpoint. Se renderizaron22pantallas localmente; se corrigió el fondo secundario de la vista del Libro y se fortaleció el rechazo de formas de guardado malformadas. Estos cambios requieren nueva CI; no son aprobación de la APK. Se añadieron generadores de los69fixtures originales en ci/recovery. Work conserva escritura, Chat revisa. dev/main intactas.

## Checkpoint técnico verde · candidata37 / cierre de identificación
CI38823832205 sobre código0e79ce486ed7c49521c15428aa40df8b1e8eb720 terminó correctamente:4279checksGodot únicos,3Python,22pantallas renderizadas, exportaciónAndroid, firma v2/v3 y auditoría. Se descargó y verificó Preview37/v0.21.0-unification, SHA256b0b3a3c774cf5ed44df67455ab74d40ba5a61355eb8ae9cb145920ff4b88c4b6; dosJSON regionales de6puntos presentes y tests/docs/ci excluidos delAPK. main9ef7af7 y dev2ea590c se mantienen intactos.

Verificación adicional: diez guardados generados ejecutando la fuente E2 original dc4a20a pasan130checks de conservación/recarga, incluidos contrato, ambos relevos y captura parcial; fixtures y generador quedan preservados y añadidos a CI. Se corrigió la etiqueta diagnóstica de build_info heredada como «E2 motor regional» para identificar correctamente la unificación; requiere una nueva compilación que será la candidata definitiva de esta entrega. No cambian reglas ni motor. Pendiente CI del último metadato/test, APK final y prueba física del creador. Work conserva escritura; Chat solo revisa.

## Cierre técnico R0 · candidata38 disponible (15/10/2026)
La implementación autorizada está terminada como candidata en feature/unificacion-jade-bosque, códigoAPKf0266badaa7851da3de2bcc08a65752b6409360b. CI38824304295 correcta:4409comprobaciones únicas Godot en26suites,3Python, importación,22pantallas renderizadas, exportaciónAndroid y firma v2/v3. Compatibilidad probada con69guardados generados por el motor recuperado Preview32 y10por la fuente E2 original;24simulaciones concluyen en4–22rondas. Se inspeccionaron adicionalmente las tarjetas de experiencia con equipo de tres y doble subida, normal/grande; las estadísticas usan desplazamiento y el botón Continuar permanece accesible.

APK Preview38/v0.21.0-unification descargada y verificada:83365989bytes, SHA25616a66fc970346981eb628f7ac4a04a7633eac8ff08b93a735d723c7bb37c08ac. Fuente, identificaciónR0, dosrutas/seispuntos cadauna,13especies y ausencia de archivos de prueba confirmadas dentro delAPK. Certificado de actualización igual a Preview32/E2 y alkeystore; instalar sin desinstalar. Evidencia estructurada: docs/recovery/CANDIDATA_38_VERIFICACION.json. Procedencia, comparativa y nueve pasos de prueba: docs/UNIFICACION_JADE_BOSQUE.md.

PR18 permanece borrador; no se cierra PR17 ni se eliminan ramas. No se han integrado cambios funcionales a dev/main: dev2ea590c y main9ef7af7 verificados. Falta exclusivamente revisión de Chat y prueba física del creador. Próximo paso: validar Preview38 conservando partida, dosregiones, Insignia/relevo, final secuencial, XP/vínculo, derrota/reemplazo y cerrar/reabrir. Work mantiene escritura para corregir incidencias. Solo tras aprobación explícita se verificará GitHub y se planteará la integración segura; no se declara la versión validada ahora.

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
