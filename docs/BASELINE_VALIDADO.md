# Baseline validado

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

Esta sección registra el baseline aprobado vigente. Los bloques siguientes son el historial de validaciones anteriores. No se ha creado una APK nueva para el cierre documental; se conserva la Preview38 aprobada.


## Bloque 01 · Base Android

- Aprobación del creador: «Prueba correcta, continúa», 14 de octubre de 2026.
- APK: Android Preview 3, versión 0.1.0, versionCode 1003.
- Código probado: `5de6f6e26292d6e2c508cbbd1d296e477553425d`.
- CI: 32 comprobaciones, exportación, firma, render de pantallas y publicación correctos.
- Dispositivo de validación: Android API 36, modelo 23122PCD1G, declarado por el creador como POCO X6.
- Incluye: menú, ajustes, visita a Valle Jade, guardado/respaldo, reanudación y diagnóstico.
- La imagen de diagnóstico muestra 60 FPS en la interfaz. No extrapolar al futuro combate.
- Pendiente de siguiente entrega: verificar actualización sobre Preview 3 sin perder datos.

`dev/karmany-core` se establece desde este código validado, seguido solo por documentación de cierre. `main` conserva la inicialización; no hay versión comercial publicable.

No cambiar motor, paquete, firma de preview ni esquema de guardado sin justificación y regresiones. Los bloques nuevos se trabajan en `feature/*` y no se integran hasta su validación.

## Bloque 02 · Bestiario de Valle Jade y contratos de captura

- Aprobación: «Prueba correcta», 14 de octubre de 2026.
- APK: Preview 4, versión 0.2.0, versionCode 1004.
- Código aprobado: `e09462a6d551c1583a8c30f67be9dbe2908fea4d`.
- Verificación: 35 regresiones de base/navegación y 38 de catálogo/captura, CI y firma correctos.
- Alcance: 15 especies canónicas, filtros/fichas, contratos de captura y restauración. No incluye combate o captura jugable.
- `dev/karmany-core` avanza por fast-forward desde el baseline anterior; el cierre solo cambia documentación.

## Bloques 03–05 · Libro, turno compartido y árbol de resonancias

- Aprobación: «El avance está correcto», 14 de octubre de 2026. Mejora pendiente del touch del árbol para la siguiente entrega.
- APK: Preview 8, versión 0.4.0, versionCode 1008.
- Código validado: `a436d58b3a08c55cebe2d0b3654d8d2af011bc5d`.
- Verificación: 221 comprobaciones, exportación y firma correctas; capturas normal/texto grande revisadas.
- Incluye: tabla del Libro, equipo/turno compartido, árbol aprendible/mejorable y cuatro espacios, laboratorio experimental y migración persistente.
- No incluye todavía combate ni captura jugable. El usuario autorizó comenzar ese bloque con fichas experimentales y Ezel/Zephyr frente a Tanugami.
- Integración mediante fast-forward desde `ad618c2`; `main` se conserva.

## Bloques 06–08 · Encuentro, equipo y correcciones

- Aprobación: «Prueba correcta, vínculo, árbol, todo correcto», 14 de octubre de 2026.
- APK: Preview 14, versión 0.6.1, versionCode 1014.
- Código validado: `71f5a0d39be6ac2f31a7e2cbabfbdb1aa985d142`.
- Verificación: 310 comprobaciones Godot y tres pruebas Python, firma y auditoría del APK correctas.
- Incluye: combate experimental ilustrado, resonancias, vínculo, colección, equipo/activo previo al encuentro, última acción, persistencia y corrección sin resonancias.
- Capturas de revisión desactivadas por defecto, solo activación manual de escritorio; bloqueadas en Android y excluidas del APK.
- Integrado por fast-forward desde `b2c411a`, sin reescribir historia ni alterar main.
- Nueva decisión del creador para la próxima rama: resonancia opcional primero; habilidad del Karmany termina el turno y da respuesta automática del rival. El cierre manual y el orden libre se reemplazarán únicamente en ese bloque.

## Bloque 09 · Turnos automáticos

- Aprobación: «Prueba exitosa y hasta el momento no encontré errores graves o visibles», 14 de octubre de 2026.
- APK: Preview 15, versión 0.7.0, versionCode 1015.
- Código validado: `61cfc5c6b505e38f65f39488e10ddf5ef122bdf5`.
- Verificación: 344 comprobaciones Godot y tres pruebas Python; CI, exportación, firma v2/v3 y auditoría del APK correctas.
- Incluye: resonancia opcional antes de la habilidad, respuesta rival automática, recuperación de respuestas pendientes sin duplicar daño y paso directo al Libro tras la derrota rival.
- Capturas de revisión desactivadas; el paso de render en CI fue omitido.
- Integrado por fast-forward desde `d078c8b`; main conserva su estado.
- La siguiente fase se definirá mediante cuestionario solicitado por el creador. No se autorizan aún nuevas reglas, balance, especies o economía.

## Bloque 10 · Cinco especies, combate táctico y animaciones

- Aprobación: «Procede con la siguiente etapa, las pruebas son correctas», 14 de octubre de 2026.
- APK: Preview 16, versión 0.8.0, versionCode 1016.
- Código validado: `c3be19409a6a8202febc00ec88ecfcd50cd02124`.
- Verificación: 443 comprobaciones Godot y tres pruebas Python; CI, exportación, firma y auditoría del APK correctas.
- Incluye: cinco especies con fichas experimentales aprobadas, cuatro rivales seleccionables, cambio voluntario confirmado, reemplazo tras derrota sin golpe extra, Vida/efectos/recargas por individuo, capturas multiespecie y animaciones 2D de Golpe/Insignia.
- Partidas anteriores conservadas por EncounterRouter; capturas de revisión desactivadas.
- `dev/karmany-core` integrado por fast-forward desde `67d006d`; main conserva su estado.
- La aprobación valida este bloque de ensayo; no autoriza inventar economía, reglas de evolución, iniciativa ni historia nueva.

## Bloque 11 · Estado y técnicas desde móvil

- Aprobación: «Prueba correcta, avanza con el juego en las siguientes etapas», 14 de octubre de 2026.
- APK: Preview 17, versión 0.8.1, versionCode 1017.
- Código validado: `1f6deae03c5f8747e7826bd98c5aae9cf8fb8662`.
- Verificación: 480 comprobaciones Godot y tres pruebas Python; CI, exportación, firma y auditoría del APK correctas.
- Incluye: panel táctil Activos/Equipo/Técnicas/Resonancias con cifras reales, efectos por individuo, recargas y motivos de bloqueo; texto grande y consulta sin consumo de acciones.
- `dev/karmany-core` avanza por fast-forward desde `2d90c5e`; main conserva su estado.
- Siguiente objetivo recomendado: un recorrido jugable de Valle Jade con progreso persistente, usando las especies y reglas aprobadas. Orden de recorrido y condición de avance requieren decisión del creador; no se inventan localizaciones, historia, economía o recompensas.

## Bloque 12 · Recorrido guiado de Valle Jade

- Aprobación del creador: «Prueba correcta», 14 de octubre de 2026, seguida de solicitudes nuevas de mapa, stamina e interfaz.
- APK validado: Preview 18, versión 0.9.0, versionCode 1018.
- Código validado: `0b8d083664fb945dc962d6452498b09f4203f769`.
- Verificación: 665 comprobaciones Godot y tres pruebas Python; CI, exportación, firma y auditoría del APK correctas.
- Incluye: cuatro puntos secuenciales, avance persistente por victoria, captura opcional confirmada, repeticiones y entrenamiento separado, migración sin avance retroactivo.
- Integrado por fast-forward desde eded1d0; main conserva su estado.
- Próximo bloque autorizado: mapa cenital con localizaciones sin revelar criaturas, PS visibles y acciones secundarias en menús; stamina 100, entradas 10/10/10/30, recuperación 1/minuto y objeto +30 con 20% por victoria en localizaciones, excluido Entrenamiento.

## Bloque 13 · Exploración, stamina y menús de combate

- Aprobación: «las pruebas estan correctas», 14 de octubre de 2026.
- APK: Preview 19, versión 0.10.0, código dd4c8b66f1b414b58de3c9fab1b2fa6613bdbabb.
- CI: 744 comprobaciones Godot y 3 pruebas Python; exportación, firma v2/v3 y auditoría correctas.
- Integrado en dev/karmany-core por fast-forward desde f830174; main conserva su estado.
- Siguiente bloque autorizado: información y coste al seleccionar localización, fondos por lugar y renovación visual de criaturas, personajes y UX usando las referencias como inspiración.

## Bloque 14 · Localizaciones y arte

- Aprobación: «prueba correcta», 14/10/2026. Preview22, 0.11.0, commit39ef4b6dbdee1e82abca90ca1f5f9c3cf9b52393.
- 796 comprobaciones Godot y 3 Python; CI, firma y auditoría correctas.
- Integrado por fast-forward en dev/karmany-core. PR10 cerrada.
- Próximo bloque autorizado: animaciones de golpes/habilidades y documento permanente de continuidad.

## Bloques15 y16 · Combate y vínculo animados

- Aprobación: «prueba correcta», 14/10/2026, sobre Preview25, que incluye ambos bloques.
- APK0.13.0/versionCode1025, código dd1fc0b530f4907f94dce1e017ace807dfba6d5e; documentación5c63dff.
- 1041 comprobaciones Godot y3 Python; CI38652857621, exportación, firma y auditoría correctas.
- Integración por fast-forward desde39ef4b6 a5c63dff en dev/karmany-core; PRs11/12 cerradas.
- Siguiente bloque autorizado: efectos de sonido para golpes, habilidades, vínculo y avisos necesarios.

## Bloque17 · Efectos de sonido

- Aprobación «pruebas correctas»,14/10/2026. Preview26,0.14.0/versionCode1026.
- Código27e066ea00adbcf625f61f584003e4c42e8cc1b3; documentaciónbb406ce.
- CI38654312252:1084 comprobaciones Godot y3 Python, firma/auditoría correctas. Humo real44 comprobaciones.
- Integrado en dev por fast-forward desde9db69ac abb406ce. PR13 cerrada.
- Siguiente bloque: movimiento reducido para combate/vínculo, conforme a continuidad y solicitud de seguir.

## Bloque18 · Movimiento reducido

- Aprobación «ok pruebas correctas»,14/10/2026. Preview27,0.15.0/versionCode1027.
- Código413ab07813724cf4bd68e562c6fb0fc81e3cbefc, documentación10e3886.
- CI38655224968:1174 Godot y3 Python, firma/auditoría correctas.
- Integrado por fast-forward desdea62ecb3 a10e3886, PR14 cerrada.
- Próximo paso: decidir progresión del Libro mediante docs/PROPUESTA_LIBRO_19.md; todavía no hay reglas nuevas aprobadas.

## Bloques19 y20 · Progresión, Libro y ventana de XP

- Aprobación del creador: «pruebas correctas, procede con la siguiente etapa»,14/10/2026 (America/La_Paz).
- Preview29,0.17.0/versionCode1029. Código a3d5dfffb93dd00242004295dd853f077875ec1a; documentación d6e960ab4bb480879ba2201f73113649f17a053c. Incluye Preview28/progresión df44144.
- CI38666473622 verificada nuevamente:1390 comprobaciones Godot y3 Python, exportación, firma v2/v3 y privacidad correctas.
- Integrados por fast-forward desde cb98974 a d6e960a en dev/karmany-core. main permanece9ef7af7. PR15/16 se cierran tras integración por avance directo, sin commit de merge.
- Incluye XP individual/equipo, tope Jade10, estadísticas por nivel, mejoras secuenciales del Libro con puntos, migración compatible y resumen animado de victoria de solo lectura.
- Próxima etapa: decisión de región y balance mediante docs/PROPUESTA_REGION_21.md. El cierre no autoriza valores nuevos.

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
