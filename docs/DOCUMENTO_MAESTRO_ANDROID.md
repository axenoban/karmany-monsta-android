# Karmany Monsta Android — Documento maestro de continuidad

Versión documental 1.0 · Corte verificado: 12 de noviembre de 2026 (Bolivia).
Propietario y director: Axe. Repositorio: https://github.com/axenoban/karmany-monsta-android

## 1. Cómo utilizar este documento

Este documento reúne la definición del producto, estado real, reglas implementadas, arquitectura, recuperación, compilación y traspaso. Sirve como punto de entrada para otro equipo o asistente sin depender del historial de conversación. Incluye anexos íntegros de contratos y datos para conservar detalles que una síntesis podría perder. Los anexos históricos conservan su fecha y NO convierten propuestas antiguas en pendientes actuales.

Es una fotografía verificable, no una autorización para nuevas funciones. Para trabajar se necesita además clonar los fuentes y recursos: un documento no reemplaza el repositorio ni las claves de distribución. Verificar siempre los HEAD remotos antes de ejecutar acciones.

Precedencia: decisión explícita vigente del creador → contrato aprobado del bloque → código y datos del baseline correspondiente → documentación histórica. Ante contradicción de canon o balance, registrar el conflicto y pedir decisión; no resolver inventando contenido. La implementación demuestra comportamiento, pero no autoriza por sí sola una regla nueva.

## 2. Identidad y alcance

Videojuego Android 2D ilustrado de exploración por localizaciones, combate táctico por turnos, vínculo mediante Libro y progresión de entrenador y criaturas. Ezel es protagonista, Axe mentor y Zephyr compañero inicial. Mundo de Shisai. La experiencia actual utiliza mapas regionales y escenarios de combate, equipo y colección, Bestiario, árbol de resonancias, ayudas y persistencia local.

Dispositivo histórico de validación: POCO X6. No se acredita una matriz de compatibilidad de todos los Android. El producto es una preview, no una publicación comercial. No hay en este baseline un sistema de cuentas, backend multijugador, NFT o pagos implementado. El objetivo histórico de 30 FPS no equivale a una medición certificada.

**Separación de proyectos:** Forja de la Resonancia es el juego de mesa; el antiguo proyecto hexagonal/3D y sus fases F30/F43 no son este repositorio Android. Karmany-Blockchain es una iniciativa separada. Las decisiones de esos proyectos no se importan a Android. Una posible migración web exige contrato y auditoría propios; este documento no la ejecuta ni supone equivalencia entre plataformas.

## 3. Estado real de GitHub

| Referencia | SHA verificado | Interpretación |
|---|---|---|
| main | 9ef7af778ee59a47f62bdfbfd5eb0786ce787213 | Inicialización; no es la última versión jugable |
| dev/karmany-core | 29be7ba3d30ea72e860f62ec4f0c8aa766e6d1b4 | Baseline integrado Preview42 más documentación R1.1 |
| feature/r1-1-navegacion-qa | 12605fc9fd9cc7984f21eecfcbbbc6fb6d470da7 | Candidata Preview45 y documentación de entrega |
| Código APK Preview45 | 636565422baa63dd4cc0f5026e55361ccd8f4fe1 | Código compilado; el HEAD posterior solo documenta |

PR21: abierto, borrador, mergeable y no integrado al consultar GitHub. CI38955362578: completed/success. La consulta de PR abiertos devuelve PR21. Este trabajo documental no integra ese PR.

**Conciliación con otros chats:** la recuperación de conversación del 18/10/2026 registra pruebas físicas comunicadas como correctas y una revisión favorable de NAV-01/QA-01. El repositorio sigue documentando la puerta de cierre pendiente. No debe confundirse «se comunicaron pruebas correctas» con «ya se integró». Antes del cierre, recuperar y registrar la confirmación expresa ligada a Preview45; si ya autoriza el cierre, no repetir innecesariamente la prueba ni pedir una fórmula ritual. Si no se puede verificar su alcance, resolver únicamente esa autorización. En esta intervención no se atribuyen pruebas físicas adicionales ni se autoriza integrar.

## 4. Evolución y protección del avance

| Hito | Resultado y estado |
|---|---|
| Preview32 | Dos regiones de seis etapas; origen de recuperación, no baseline para iniciar otra línea aislada |
| E1 | Mejoras de combate, incluido relevo Sakuromushi; existió retroceso de contenido regional |
| E2 | Motor regional, contrato de encuentro congelado, recompensas y persistencia |
| Preview38 / PR18 | Unificación aprobada e integrada: fuente f0266ba; recupera 6+6 y conserva E1/E2 |
| Preview40 / PR19 | E5 primera sesión, ayudas y corrección de cierre/persistencia; aprobada e integrada, fuente0c356db |
| Preview42 / PR20 | R1 prólogo, navegación regional, Bestiario, perfil y árbol táctil; aprobada e integrada, fuente293ac5e |
| Preview45 / PR21 | R1.1 Atrás contextual y laboratorio QA; implementada y CI correcta, PR aún abierto |

Nunca regresar a una línea de cuatro etapas ni eliminar ramas/releases para simular una historia lineal. Preview43 y44 son iteraciones superadas de R1.1. E6 y R2–R4 no están autorizadas por el último contrato del repositorio.

## 5. Bucle de juego y reglas vigentes

Inicio/continuación → regiones → localización y coste → exploración/descubrimiento → combate → derrota o victoria → XP y vínculo cuando corresponde → retorno al recorrido. La navegación visual no debe reiniciar el encuentro ni cobrar la entrada otra vez.

Equipo de hasta tres individuos, uno activo. Vida, Ataque, Defensa y Velocidad; acciones de Karmany y resonancias del entrenador separadas. El flujo automático vigente permite resonancia opcional antes de la habilidad Karmany y respuesta rival automática. Los documentos iniciales de orden libre son antecedentes, no sustituyen este flujo. Reemplazo tras derrota con reserva disponible sin ataque rival gratuito. Sakuromushi conserva su relevo implementado.

Captura posterior a derrota, elegibilidad por Libro y especie, máximo tres intentos; éxito añade una única instancia y los fallos consumen intentos persistidos. Tres fallos terminan en escape; no inventar una frecuencia de reencuentro. Los finales regionales presentan dos enemigos consecutivos y una decisión de vínculo según el estado del motor, no capturas duplicadas.

Libro: inicial45% común; mejora1:60% común/30% raro; mejora2:75% común/45% raro/20% épico. Mejoras disponibles a niveles4 y8, costes1 y2 puntos y prerrequisito de mejora anterior. Son datos aprobados para el prototipo, no probabilidades universales del mundo narrativo.

Árbol del entrenador: nivel máximo15, puntos compartidos y cuatro resonancias equipables según definición. No importar habilidades nuevas desde el juego de mesa. Requisitos, rangos, hitos de capturas y efectos exactos se conservan en los anexos de datos y contratos.

XP necesaria por nivel:100×nivel. Datos regionales congelan recompensa inicial/repetición y cap: Jade10; Velo15. Entrada normal al Velo: nivel10 y desbloqueo de1 punto. El campo genérico victory_xp25 no debe reemplazar las recompensas de los encuentros regionales. Escalado y efectos exactos pertenecen a los modelos, no deben recalcularse de modo independiente en UI.

Stamina máxima100, recuperación1 por60 segundos, recuperador30 y umbral de caída2000/10000. Las rutas actuales declaran su coste explícito; el antiguo array de cuatro entry_costs es fallback histórico, no el recorrido vigente. No introducir PS persistentes ni curación entre encuentros como cambio implícito.

## 6. Regiones y encuentros

La siguiente tabla se extrae de los JSON del candidato; conserva IDs utilizados por partidas antiguas.

| Región / ID | Enemigos en orden | Nivel | Stamina | XP primera / repetición |
|---|---|---:|---:|---:|
| jade / jade_point_1 | tanugami | 1 | 10 | 400 / 100 |
| jade / jade_point_2 | ushigane | 3 | 10 | 500 / 125 |
| jade / jade_point_3 | kitsunibi | 5 | 10 | 600 / 160 |
| jade / jade_point_4 | sakuromushi | 7 | 10 | 650 / 200 |
| jade / jade_point_5 | sakuraneko | 8 | 10 | 700 / 240 |
| jade / jade_point_6 | inubari, ushigane | 10 | 30 | 750 / 300 |
| veil / veil_point_1 | suzumeko | 10 | 10 | 700 / 175 |
| veil / veil_point_2 | kodamashi | 11 | 10 | 750 / 210 |
| veil / veil_point_3 | mujina_kage | 12 | 10 | 800 / 240 |
| veil / veil_point_4 | tsukimi_usagi | 13 | 10 | 850 / 260 |
| veil / veil_point_5 | kodama_shin | 14 | 10 | 900 / 290 |
| veil / veil_point_6 | karasu_origami, mujina_kage | 15 | 30 | 950 / 325 |

## 7. Criaturas, canon y arte

13 especies de combate no equivalen a21 fichas de Bestiario ni a las75 especies de la enciclopedia citada en la base. No afirmar que todo el catálogo está jugable. Los valores de combate se extraen aquí sin reinterpretación:

| Especie | Vida | Ataque | Defensa | Velocidad | Insignia (definición literal) |
|---|---:|---:|---:|---:|---|
| zephyr | 80 | 20 | 8 | 10 | `{"power": 1.5, "cooldown": 2}` |
| tanugami | 80 | 20 | 8 | 10 | `{"heal": 12, "guard": 0.25, "cooldown": 3}` |
| ushigane | 96 | 18 | 10 | 10 | `{"power": 1.25, "guard": 0.25, "cooldown": 2}` |
| kitsunibi | 68 | 22 | 6 | 10 | `{"power": 1.2, "weaken": 0.3, "cooldown": 2}` |
| sakuromushi | 76 | 19 | 9 | 10 | `{"power": 0.7, "relay_boost": 0.2, "relay_rounds": 2, "cooldown": 2}` |
| sakuraneko | 72 | 20 | 7 | 10 | `{"heal": 10, "guard": 0.2, "cooldown": 3}` |
| inubari | 84 | 18 | 11 | 10 | `{"power": 1.1, "guard": 0.3, "cooldown": 2}` |
| suzumeko | 64 | 23 | 5 | 10 | `{"power": 1.25, "weaken": 0.2, "cooldown": 2}` |
| kodamashi | 84 | 17 | 10 | 10 | `{"heal": 14, "guard": 0.2, "cooldown": 3}` |
| mujina_kage | 76 | 20 | 8 | 10 | `{"power": 1.1, "weaken": 0.3, "cooldown": 2}` |
| tsukimi_usagi | 72 | 18 | 8 | 10 | `{"power": 1.0, "grant_boost": 0.3, "cooldown": 2}` |
| kodama_shin | 80 | 18 | 10 | 10 | `{"heal": 10, "guard": 0.25, "cooldown": 3}` |
| karasu_origami | 68 | 23 | 6 | 10 | `{"power": 1.3, "cooldown": 2}` |

La Enciclopedia de Shisai describe ecología y resonancias, pero no todas las estadísticas jugables. Restricciones históricas documentadas: Orochi-Gami no se trata como captura ordinaria; Zephyr no recibe variante sombría por inferencia. Las edades y versiones de Axe cambian entre proyectos: no elegir una usando recuerdos de otro relato. Para nuevo contenido se requiere la ficha fuente y aprobación explícita.

Dirección implementada: ilustración2D, criaturas separadas del fondo, siluetas legibles, jade/bambú/niebla/origami y materiales tradicionales. Reutilizar assets aprobados. Animaciones de ataque, derrota, relevo, XP y vínculo; fondos continuos. El resultado se guarda antes de presentarlo y saltar una animación no vuelve a ejecutar recompensas. La Biblia artística posterior del juego de mesa no reemplaza automáticamente el arte Android.

## 8. UX, E5, R1 y R1.1

E5: doce intervenciones del contrato anexo. Tarjetas pequeñas, descartables, no bloqueantes; tutorial automático solo en partidas nuevas; partidas antiguas sin tutorial forzado; Ayuda permite reconsulta; resumen breve de derrota/progresión disponible. El cierre de ayuda permanece independiente del éxito al persistir el reconocimiento.

R1: introducción cinematográfica Ezel/Axe/Zephyr, navegación regional, Bestiario ilustrado/siluetas/estadísticas reales, perfil de Ezel con equipo/resonancias y desplazamiento táctil del árbol. No compra accidental por arrastre ni fichas que inventan habilidades.

R1.1: historial de rutas limitado y deduplicado; redibujar no apila historial; botón y Android comparten prioridad modal y regreso contextual; los destinos explícitos Mapa/Home/Abandonar siguen separados. Cambio de perfil/nuevo viaje invalida historial.

Laboratorio QA desde Ajustes→Diagnóstico, con confirmación y rótulo permanente. Perfil sintético en user://qa/profile.json. Configura Ezel1–15/XP, equipo1–3 entre13 especies, nivel individual/activo,12 etapas y stamina; conserva preset y preferencias al repetir. Solo export con feature qa_preview o editor con opción explícita. Producción deshabilita entrada/mutadores. Omite únicamente puertas regionales dentro de QA; no debilita validadores ni costes normales. Al salir recarga el perfil normal; si falla permanece seguro y no lo sobrescribe. Reiniciar aplicación abre perfil normal.

## 9. Arquitectura y persistencia

| Módulo | Responsabilidad |
|---|---|
| App autoload / app.gd | Estado de aplicación, transacciones, operaciones y respuesta rival programada |
| save_store.gd | Schema3, validación, temporal, respaldo y migraciones |
| trial_campaign / trial_roster / karmany_team | Campaña, propiedad e identidad de individuos, equipo |
| encounter_router / trial_encounter / tactical_encounter | Compatibilidad de encuentros y motor táctico |
| regional_policy / jade_route / progression_rules | Contrato regional congelado, rutas, desbloqueos |
| level_progression / exploration_energy | XP, recibos únicos, stamina y recuperación |
| trainer_skill_tree / book_capture_policy / capture_session | Resonancias y captura |
| main / trial_ui / navigation_history | Pantallas, interacción y contexto de regreso |
| first_session / context_help / r1_prologue | Incorporación, ayuda y narrativa aprobada |
| qa_profile / qa_store / qa_lab | Presets, aislamiento y herramientas QA |
| aftermath, transition, binding, experience | Presentación y continuidad de resultados |

Guardado normal user://profile.json, respaldos .bak, temporal .tmp y copia histórica .pre-unification cuando aplica. No cambiar IDs históricos ni schema sin migración probada. Validación estricta antes y después de escritura; recuperar respaldo sin rotar corrupción sobre la última copia válida. QA no escribe ni renombra ninguno de estos cuatro archivos. Generaciones de temporizadores/contextos invalidan callbacks viejos al cambiar de perfil.

Nunca persistir nodos UI. Conservar encounter.id/revision/HP/turno/cola rival, intentos, recibos XP/vínculo y stamina al interrumpir o navegar. Mantener fixtures32/E2/38/40/42. Los scripts y pruebas de persistencia son parte de la especificación ejecutable.

## 10. Entorno reproducible y acceso

Motor fijado por CI:Godot4.7.2, GDScript, renderer GL Compatibility, viewport1280×720, canvas_items, Android horizontal. Java17; build-tools35.0.1 y plataforma Android35 en workflow. Plantillas oficiales con SHA-512 verificado. Export ARM64; paquete com.axenoban.karmanymonsta.preview.

La firma preview es pública de pruebas (documentada en ci/README.md), no una credencial comercial. Mantenerla para actualizar sin desinstalar. Nunca usarla para una distribución comercial ni copiar tokens privados al documento. Un nuevo equipo necesita acceso GitHub propio y permisos de escritura/Actions según su función; la conexión de este chat no se transfiere por compartir el documento.

Para obtener el baseline estable:

```bash
git clone https://github.com/axenoban/karmany-monsta-android.git
cd karmany-monsta-android
git fetch origin --tags
git switch --detach origin/dev/karmany-core
git log -8 --oneline
```

Para revisar exactamente la candidata, usar `git switch --detach 636565422baa63dd4cc0f5026e55361ccd8f4fe1`. Para una nueva implementación autorizada, crear feature desde el HEAD vigente de dev; no comenzar desde main vacío ni copiar archivos sueltos de una APK.

Preparar Godot y plantillas con ci/install_godot.py (en local definir GITHUB_PATH a un archivo temporal). Definir ANDROID_HOME, JAVA_HOME, BUILD_COMMIT y GITHUB_RUN_NUMBER antes de ci/prepare_android.py, que modifica metadatos de exportación en el checkout. Preferir un checkout de compilación separado. Ejecutar importación, tests y export con los comandos exactos del workflow incluido en el anexo. En Linux los renders requieren Xvfb; no ejecutar tests que esperan frame_post_draw únicamente en headless.

Prueba rápida, una vez disponible Godot:

```bash
godot --headless --editor --path . --import --quit
godot --headless --path . --script tests/run_tests.gd
godot --headless --path . --script tests/r11_tests.gd
python3 -m unittest discover -s tests -p 'test_*.py'
```

Esto no sustituye la suite completa. Revisar logs con ci/check_log.py: exit0 no garantiza ausencia de errores Godot. Exportar con el preset Android Preview y verificar firma con apksigner. La CI genera versionCode1000+run_number y metadatos de commit de la rama, no del merge sintético.

## 11. Evidencia y entrega verificable

Preview45:v0.24.0-r1.1; versionCode1045;83.404.111 bytes.
APK:https://github.com/axenoban/karmany-monsta-android/releases/download/android-preview-45/karmany-monsta-preview.apk
SHA256:701108382045758c013bb5ed5cceaddeae4e5f5970822770fb704b3c5242ef08
CI:https://github.com/axenoban/karmany-monsta-android/actions/runs/38955362578
Certificado SHA256:756c8c1a8136ae2e80987c540d805641d7bfd2d5b657d1f04584f0074ac61bf8.

Evidencia histórica verificada en CI:5.857 comprobaciones/31 suites Godot,3 Python; R1.1:233 funcionales y32UI,8 renders; firma v2/v3. Este trabajo documental reconsulta el estado de CI, pero no vuelve a ejecutar esas pruebas ni atribuye una nueva validación física. Fixtures y scripts se conservan en Git; descargar artefactos temporales de Actions mientras estén disponibles y no depender de su retención como archivo permanente.

Validación física de seis pasos: actualizar sin desinstalar; Equipo→Colección→Atrás dos veces; Libro/Ajustes/Perfil/Bestiario con botón y gesto; combate→mapa→retomar sin nuevo coste; QA Ezel10/equipo3/Velo6 y rótulo; salida sin contaminación, reset aislado, cierre en QA/reapertura normal y letras grandes. Registrar dispositivo, versión, SHA y resultado real, sin atribuir casos no ejecutados.

## 12. Recuperación y traslado de equipo

Preview32 fue recuperada con GDRE2.7.4:39 scripts editables y recursos convertidos; hubo conversiones lossy. No se recuperaron mágicamente comentarios ni historia Git original. E2 se preserva mediante bundle incremental; verificarlo en un clon que contenga su prerrequisito. Los detalles y SHA exactos están en el anexo de unificación.

Para transferencia completa: clonar todas las ramas/tags; conservar docs/recovery y fixtures, recursos originales/importables, fuentes, project.godot, export_presets.cfg, workflows y clave preview pública. Guardar copia independiente del repositorio y releases; por ejemplo `git bundle create respaldo.bundle --all` y `git bundle verify respaldo.bundle`. No incluir archivos privados de usuarios en un repositorio público. No restaurar un stash desconocido sin compararlo.

Inventariar herramientas y accesos, abrir proyecto con el motor fijado, importar assets, ejecutar regresiones, generar una candidata con SHA y probar actualización sobre la versión anterior. Para migrar a web/iOS/u otro motor, preservar primero pruebas y contratos; es otro alcance y requiere decisión sobre persistencia, input, exportación, rendimiento y distribución.

## 13. Pendientes y riesgos concretos

1. Cierre trazable R1.1: conciliar confirmación física recuperada de chats y registro del repositorio; verificar ascendencia/diff antes de integrar PR21. Este documento no es una aprobación funcional.
2. Nuevas etapas: E6/R2–R4 siguen excluidas por contrato. Los roadmaps históricos no autorizan automáticamente desarrollarlas.
3. Metadatos: project.godot conserva config/version0.23.0-r1 mientras build_info/export declaran0.24.0-r1.1. Diferencia detectada; no se corrige código en este trabajo documental. Para identificar APK usar manifiesto y build_info verificados.
4. Datos heredados: base inicial y algunos textos dicen pendientes ya resueltos; usar la matriz actual y las fuentes fechadas. entry_costs de cuatro puntos no debe truncar rutas6+6.
5. Distribución comercial: firma/paquete propios, privacidad, licencias/procedencia de assets, permisos y rendimiento necesitan auditoría específica. Una firma preview válida no acredita preparación para tienda.
6. No consta una autorización en este repositorio para importar NFT, monetización web ni reglas del juego de mesa. La relación estratégica con otros proyectos debe quedar explícita antes de una migración.

## 14. Organización y protocolo de continuidad

Axe decide canon, reglas, balance, prioridades y aprobación física. Chat analiza/especifica/revisa; Work implementa, prueba y compila. Un escritor por bloque; revisión simultánea solo en lectura. main versiones publicables; dev último baseline completo validado; feature trabajo no validado. No force push, reescritura, merges ciegos ni eliminación de historia. Preferir fast-forward si la ascendencia lo permite; si hay divergencia, revisar antes de actuar.

Tras avance importante actualizar ROADMAP_ESTADO y CONTINUIDAD con SHA/PR/CI/APK, alcance, pruebas y siguiente acción. Actualizar este documento cuando cambie un baseline o decisión; los anexos son una fotografía de12605fc y deben regenerarse desde la referencia nueva, no editarse a mano de modo divergente.

## 15. Instrucción portable para un nuevo equipo

> Trabaja sobre axenoban/karmany-monsta-android. Lee este documento y AGENTS.md; verifica HEAD de main/dev/feature, PR21 y CI. Referencias del corte:dev29be7ba, candidata6365654, documentación12605fc, Preview45. Conserva dos regiones6+6, E1/E2/E5/R1 y partidas anteriores. Revisa la confirmación física de Preview45 y su alcance antes de preparar cierre; no presupongas integración. No inicies E6/R2–R4 ni cambies reglas/canon/balance/PS sin autorización. Usa un único escritor, pruebas completas, PR y APK identificable. Termina indicando HECHO, RAMA/COMMIT, CI, APK, PRUEBA LOCAL, RESULTADO ESPERADO, RIESGOS, SIGUIENTE PASO, RESPONSABLE e INSTRUCCIÓN PARA CONTINUAR.

## 16. Procedencia y límites de esta consolidación

Revisión directa: ramas Git clonadas, PR21 y lista de PR abiertos, CI del código6365654, docs/ y JSON/scripts/configuración de la rama12605fc. Contexto adicional: recuperación de conversaciones Android del14–20/10/2026 y mensajes visibles de esta conversación. La recuperación entre chats puede ser incompleta; no se presenta como lectura exhaustiva de cada conversación existente. Los relatos de otros proyectos se excluyen cuando no hay identidad de repositorio demostrada.

Los contratos siguientes se incorporan íntegros para permitir consultar sus criterios aun fuera de GitHub. Son documentos con fecha: una frase histórica de «pendiente» no anula el estado consolidado de las secciones3–4. Las tablas JSON son exactas y permiten resolver cifras sin depender de una interpretación del redactor.


---

## Anexo A1. Fuente íntegra: docs/UNIFICACION_JADE_BOSQUE.md

SHA256 del archivo fuente: `f9bd1d01f40c7216580335f3adb24cd1848893a61fda97b6556a18267ed56294`. Referencia:12605fc.

# Unificación validada · Preview32 + E1 + E2

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

Los apartados de procedencia y comparación describen la implementación original; la aprobación vigente sustituye las referencias históricas a prueba pendiente.

## Procedencia y recuperación

- APK Preview32 original: SHA256 3a65d6f760bd881e0fb176220e1c2ae59c25b1e09327d4fa2ed71c36f453f06a, código original 009e0c7d9dc4e7e6aa61509157318982152971f7. No apareció un respaldo fuente original en las búsquedas por nombre de Karmany/Preview32/Fuente en Library ni en las ramas GitHub.
- GDRE Tools v2.7.4 recuperó 39 scripts editables (ningún fallo), detectó Godot4.7.2 y bytecode4.5 ebc36a7. Convirtió97 recursos,23 indicados como lossy; no se afirma restauración de píxeles originales anteriores a la compresión. Las doce imágenes regionales se recuperaron como PNG importables, no como CTEX renombrados.
- `docs/recovery/Preview32_editable_scripts.zip` preserva los .gd recuperados sin integrar y los JSON exactos de la APK. No contiene GDC usado como código de producción. Decompilado no equivale a recuperar comentarios ni historial Git original.
- `docs/recovery/E2_incremental.bundle` conserva exactamente HEADdc4a20a63c70526270350b28c4bb4fa950ffc303 y código42fed0ce330366de891ad7944e50e6d79f5836d8, requisito1719c6821319279f191734a0d4fbf836e9de428e. `git bundle verify` correcto en clon de GitHub.
- El envío Git nativo no dispone de credenciales. La rama remota feature/e2-regional-engine-recovered @1f65222 contiene el mismo árbol fuente de E2, con la única adición del bundle; comparación git diff verificada. El bundle preserva los SHA originales; el commit de importación tiene su propia identidad y no se presenta como dc4a20a.

## Comparación funcional implementada

| Función | Preview32 | E1 | E2 | Candidata |
|---|---|---|---|---|
| Valle Jade |6 etapas|4|4|6; ID históricos conservados|
| Bosque del Velo |6 etapas|ausente|ausente|6; accesoNv10/coste1/tope15 recuperados|
| Criaturas de combate |13|5|5|13; cifras y técnicas recuperadas, excepción Saku E1|
| Catálogo canónico |21|15|15|21; no confundir con13 criaturas de combate|
| Final regional |dos rivales consecutivos|ausente|motor en pruebas|Jade Inubari+Ushigane; Bosque Karasu-Origami+Mujina-Kage|
| Relevo Sakuromushi |apoyo sin relevo|golpe70%, relevo, +20%/2rondas|preservado|E1 conservado, incluido al derrotar primer rival|
| Motor regional |implementación anterior|heredado|contrato congelado y transacciones|E2 reutilizado; adaptador de datos Preview32|
| Recompensas |claves punto@1|heredadas|región/punto/v1|E2; conversión de claves sin volver a cobrar bonos|
| Captura final |un objetivo elegido|heredada|selección irreversible|una selección y tres intentos persistidos|
| Derrota y entrada |animadas|ataques|motor|flujos Preview32 y ataques E1|
| XP y vínculo |flujo continuo|ventana anterior|XP multinivel|flujo Preview32 con muestreo multinivel E2|
| Escenario |transiciones regionales|escena anterior|escena anterior|fondo completo en batalla y flujos; controles superpuestos|
| Guardados |formato divergente|base29|base29/E1|lector compatible y respaldo original antes de escribir|

No se alteran cifras recuperadas para facilitar las simulaciones; no se declara balance final aprobado.

## Persistencia y seguridad de actualización

Preview32 usa regional.version, claves punto@1 y cambia enemy_index al elegir captura. E2 usa regional.schema, enemigos congelados dentro del contrato y enemy_index conserva el último rival vencido. `preview32_contract.gd` conserva únicamente el validador anterior; `preview32_migration.gd` convierte contratos y claves, conserva HP/efectos/recargas/turno/selección/rolls/XP/colección y valida después el perfil completo. No se cambian encuentros activos sin contrato ni capturas históricas de nivel1.

La lectura no escribe. Antes del primer guardado que sustituya un perfil Preview32, se copia el archivo original a `.pre-unification`; si no se puede preservar, el guardado se rechaza. Sigue funcionando el respaldo transaccional .bak/.tmp. No se elimina la partida para resolver corrupción.

Se verificó el mismo certificado SHA256 en Preview32, E2 y el keystore de previews del repositorio:756c8c1a8136ae2e80987c540d805641d7bfd2d5b657d1f04584f0074ac61bf8. La CI debe verificar también la firma del APK candidato. La instalación es una actualización del paquete de previews, sin desinstalar.

## Pruebas reproducibles

69 JSON generados ejecutando el motor recuperado original de Preview32: batalla, relevo rival, victoria, elección, intento, captura, mapa, respuesta pendiente, derrota y reemplazo aliado, incluyendoXPparcial. La suite de unificación verifica la carga, conservación, recarga exacta, copia original e idempotencia y continúa combates/vínculos. Además recorre los12 puntos reales, costes, contratos, finales, capturas y activos importados. No se generan los fixtures con el migrador nuevo.

Las suites históricas de ruta/progresión/UI ejecutan sus contratos anteriores sobre los JSON de Preview29 conservados en tests/fixtures/preview29. Se mantienen sus asserts. La campaña real de doce puntos se prueba aparte; los conteos canónicos se amplían a21. Las pruebas E2 usan datos históricos explícitos para el encuentro pre-E2 y navegan por el nuevo flujo de elección. Las pruebas de vínculo finalizan la nueva presentación de derrota antes de intentar capturar.

```sh
godot --headless --editor --path . --import --quit
godot --headless --path . --script tests/unification_tests.gd
godot --headless --path . --script tests/unification_ui_tests.gd
godot --headless --path . --script tests/regional_balance_tests.gd
python3 -m unittest discover -s tests -p test_apk_privacy.py
```

Ejecutar también todas las suites de .github/workflows/android-preview.yml. La revisión visual renderiza22 pantallas de mapas/combate/derrota/XP/elección/vínculo con texto normal y grande en CI. Las24 simulaciones deterministas ejercitan cada etapa con equipo al nivel rival y dos niveles inferior; son pruebas de finalización e integridad, no sustituyen playtest.

## Validación física del creador

1. Anotar versión instalada y equipo/progreso actual. Instalar la candidata encima; no desinstalar ni borrar datos. Si Android rechaza actualizar, conservar la partida y reportar el mensaje.
2. Verificar colección, niveles, XP parcial, Libro, puntos, compras, stamina y ajustes. Si había encuentro abierto, retomarlo sin cobrar de nuevo ni cambiar HP/rival.
3. Confirmar seis puntos en cada mapa. Bosque conserva el accesoNv10 y desbloqueo de un punto; no aparece abierto gratis en partida nueva.
4. Con Sakuromushi activo y reserva viva, usar Insignia y elegir compañero: ver golpe, salida/entrada, bonificación y respuesta rival contra el entrante.
5. En una final, vencer al primer rival: entra el segundo sin curar aliados ni atacar gratis. Solo al vencer al último se concede recompensa.
6. Ver derrota→victoria→XP→elección→vínculo sobre el mismo escenario. Elegir un rival final e intentar vincular; cerrar/reabrir entre intentos conserva la elección y los intentos.
7. Repetir etapa: recibir XP de repetición, sin cobrar el bono inicial otra vez. Probar también una etapa ya completada en Preview32.
8. Perder con reserva, elegir reemplazo y comprobar ausencia de ataque extra. Perder el equipo completo, cerrar/reabrir y volver al mapa sin perder avance.
9. Probar texto grande, movimiento reducido, sonido y Atrás de Android; informar versión del APK y pasos ante cualquier fallo.
10. Solo después confirmar «prueba correcta» sobre esta candidata. Hasta entonces, no integrar en dev.

### Recuperación reproducible de fixtures
Los scripts en ci/recovery se ejecutan con Godot4.7.2 sobre el proyecto original descomprimido desde docs/recovery/Preview32_editable_scripts.zip (con sus recursos recuperados), no sobre el motor unificado:

```sh
godot --headless --path /ruta/preview32-recuperado --script /ruta/repositorio/ci/recovery/generate_campaign_fixtures.gd -- --output=/ruta/fixtures
godot --headless --path /ruta/preview32-recuperado --script /ruta/repositorio/ci/recovery/generate_edge_fixtures.gd -- --output=/ruta/fixtures
```

Revisión gráfica local posterior:22pantallas renderizadas con Mesa/Xvfb, texto normal/grande, mapas de ambas regiones y flujos regionales. Se detectó y corrigió un fondo secundario estrecho en la vista previa del Libro: ahora esa vista dibuja solo actores/Libro sobre el escenario continuo. La animación de vínculo a pantalla completa conserva su fondo. Las24simulaciones terminaron en victoria,4–22rondas, sin tocar estadísticas. La aceptación final de ritmo y estética sigue siendo humana.

### Compatibilidad directa de la fuente E2
Además de las regresiones del motor, tests/e2_source_compatibility_tests.gd carga diez guardados generados ejecutando dc4a20a original: encuentros heredados y regionales, respuesta pendiente, relevo aliado E1, relevo rival, victoria, elección, intento, captura y mapa. Comprueba130condiciones de conservación/recarga. Los JSON están en tests/fixtures/e2; generador ci/recovery/generate_e2_fixtures.gd, ejecutable sobre el worktree original con --output=/ruta/fixtures. La formación sintética del generador ejercita el contrato preparado en E2 y no añade contenido al juego.

## Resultado final de esta entrega
[Descargar Preview38 / v0.21.0-unification](https://github.com/axenoban/karmany-monsta-android/releases/download/android-preview-38/karmany-monsta-preview.apk). [CI correcta](https://github.com/axenoban/karmany-monsta-android/actions/runs/38824304295). [PR18 borrador](https://github.com/axenoban/karmany-monsta-android/pull/18).

4409checks únicos Godot/26suites y3Python correctos; la suite UI se repite además al renderizar22pantallas. Todas las24simulaciones finalizaron con victoria en4–22rondas. No implica aprobación humana del balance. SHA256APK16a66fc970346981eb628f7ac4a04a7633eac8ff08b93a735d723c7bb37c08ac;83365989bytes. Código fuente, dosregiones y ausencia de tests/ci/docs verificados dentro delAPK descargado. Firma v2/v3 correcta y certificado igual al de Preview32/E2. Conservar partida mediante actualización sin desinstalar; ante rechazo de instalación, reportar el mensaje conservando los datos.

Limitaciones históricas al emitir la candidata (actualizadas por la aprobación física general del 15/10/2026): el historial Git y los comentarios originales de Preview32 no pueden recuperarse de laAPK; las imágenes se recuperan de sus recursos ya comprimidos. La procedencia editable, las mecánicas y los formatos de partidas sí se implementaron y probaron. No se afirma equivalencia visual física definitiva ni balance final aprobado. Esperar prueba del creador antes de integrar.

## Cierre de aprobación

El creador confirmó que probó físicamente Preview38/v0.21.0-unification y la considera correcta y aceptable. Chat registró la validación en PR18. Se aprueba el código f0266ba, no funcionalidades nuevas; el único commit posterior previo al cierre (892a109) es documental. La integración autorizada conserva ese código mediante fast-forward de dev. E5 queda a cargo de Chat para especificación previa; Work no implementa hasta recibir lo aprobado. La prueba física es general; no se presume cobertura exhaustiva de todos los casos propuestos arriba.


---

## Anexo A2. Fuente íntegra: docs/E2_MOTOR_REGIONAL.md

SHA256 del archivo fuente: `5f25193f0c5dc76f86251949e51aca8123aa21cc2b5b2c1febd880885e86aafa`. Referencia:12605fc.

# E2 · Motor regional sobre E1

Base: `1719c6821319279f191734a0d4fbf836e9de428e` (E1).
Responsable escritor: Work. Rama: `feature/e2-regional-engine`.
Estado: implementación técnica; pendiente revisión de Chat/CI remota y prueba física. No integrado a dev.

## Contrato implementado

- Rutas consultables por región configurada, sin registrar ni habilitar Bosque. Se preserva `route.completed` de Jade y los identificadores históricos; el contador global `jade-N` no cambia para mantener partidas anteriores.
- Una entrada con `level`, `first_xp`, `repeat_xp`, `cost` y opcionalmente `enemies` activa el contrato regional. El contrato guarda niveles y enemigos, región, tope, recompensa, repetición y clave de bono antes del combate. Las entradas sin estos campos siguen el comportamiento heredado.
- Bonos `región/punto/v1`, registrados en la misma transacción que la victoria, el recibo de XP, el progreso y el objeto de stamina. Una etapa ya completada antes de E2 permite reclamar el nuevo bono una vez al volver a ganarla. No se asignan recompensas a integrantes históricos desconocidos.
- Equipo enemigo de hasta dos miembros conforme a E1: uno activo; entra la reserva conservando su estado. No se cura al equipo aliado, no se reinician efectos/recargas y no hay golpe gratuito del nuevo enemigo. Se abre el siguiente turno normal. Solo la derrota del último rival concede victoria/XP.
- Al vencer a dos rivales se elige uno: la selección se guarda y queda bloqueada; no consume intento ni genera tiradas. Los tres intentos originales pertenecen al único vínculo. Con un rival la elección es automática.
- Captura regional al nivel encontrado y XP parcial cero. Los encuentros y capturas anteriores mantienen nivel uno y recompensa heredada. Las capturas y niveles existentes no se reinterpretan.
- Resumen de XP con paso por todos los niveles cruzados y cifras de estadísticas correspondientes al nivel mostrado. Ambos modos de movimiento terminan con los valores persistidos.
- El golpe con relevo y bonus temporal de Sakuromushi de E1 permanece intacto; se prueba también cuando ese golpe derrota al primer miembro del equipo enemigo.

## Frontera con E3 y E4

Este bloque NO modifica `data/jade_route.json`: los cuatro puntos jugables continúan con la configuración anterior. La activación de seis etapas, cifras aprobadas, Sakuraneko/Inubari y arte pertenece a E3. No activar una final provisional con otras especies ni publicar fixtures como contenido real.

La selección funcional de vínculo ya existe en la UI. La caída/entrada cinematográfica del rival y el fondo continuo pertenecen a E4. E2 no afirma haber completado la solicitud visual previa.

Los tests usan datos temporales en memoria y especies existentes para ejercitar el motor. Se excluyen del APK. No son reglas nuevas ni una ruta desbloqueable por el jugador.

## Validación reproducible

```bash
godot --headless --editor --path . --import --quit
godot --headless --path . --script tests/regional_engine_tests.gd
godot --headless --path . --script tests/tactical_tests.gd
godot --headless --path . --script tests/experience_summary_tests.gd
python3 -m unittest discover -s tests -p test_apk_privacy.py
```

La suite completa sigue definida en `.github/workflows/android-preview.yml`, con el nuevo test regional incluido. No se modifica ni elimina ningún assert existente.

## Revisión de Chat

Comparar contra E1, no contra Preview32. Revisar validación/normalización del estado, el vencimiento del bonus de relevo al avanzar de ronda, selección irreversible de un solo objetivo, migración sin borrado de completados, y exclusión de los tests del APK. No editar simultáneamente archivos reservados por Work.

## Prueba Android

Instalar la entrega E2 sobre E1/Preview29 sin borrar datos; NO usarla como actualización compatible de Preview30–32/Bosque, una rama divergente que este árbol no importa. conservar equipo, niveles, Libro y progreso. Probar una pelea, la Insignia de Sakuromushi con reserva viva, el contraataque al entrante, guardar/reabrir, captura y regreso al mapa. Probar texto grande y movimiento reducido. El mapa aún muestra cuatro puntos; los contratos nuevos se validan automáticamente hasta su activación en E3.

Siguiente: revisión E2, validación de la actualización y después E3. E1/E2 no se integran a dev sin aprobación física expresa; main permanece reservado para publicación.


---

## Anexo A3. Fuente íntegra: docs/E5_PRIMERA_SESION.md

SHA256 del archivo fuente: `262f3612eeb6b353de0d59f2241711a2dd7359a50e34d92036594c16f8597e6b`. Referencia:12605fc.

# E5 · Primera sesión autónoma · contrato funcional aprobado

**Aprobación humana:** 15/10/2026 (America/La_Paz). El creador aprobó explícitamente las 12 intervenciones, microcopias, criterios y cuatro decisiones de UX.
**Estado actual:** E5 COMPLETADA, APROBADA FÍSICAMENTE en Preview40 por el creador e integrada mediante fast-forward verificado a dev `1329bee479b013c753b6a2d631b3b840f11ee13c`; PR19 closed/merged. Código0c356db, CI38833949394 y SHA en ROADMAP_ESTADO. Este documento conserva íntegro el contrato aprobado; referencias a implementación futura del cuerpo son antecedentes. E6 no iniciada.
**Repositorio:** `axenoban/karmany-monsta-android`.
**Base comprobada al aprobar:** `dev/karmany-core` @ `76a7347f60605cc28259b0a087f4654b69a89164`. **Código de juego aprobado:** `f0266badaa7851da3de2bcc08a65752b6409360b` (Preview 38 / v0.21.0-unification). Work DEBE consultar HEAD real antes de crear rama.
**Rama futura sugerida:** `feature/e5-primera-sesion`, desde el nuevo `dev` validado. `main` intacta.
**Fuente de autorización:** declaración explícita del creador en la conversación de aprobación E5; no confundir aprobación de especificación con validación de APK E5.

## Objetivo y frontera

Una persona sin experiencia previa debe poder comenzar una partida, seleccionar una localización, entender el coste de stamina, descubrir el encuentro, combatir, interpretar victoria o derrota, entender la progresión y decidir si intentar un vínculo, regresar al mapa y reanudar sin explicación verbal. **Solo UX/onboarding y claridad; ninguna modificación de reglas.**

Contrato de comportamiento aprobado:
1. Tarjetas contextuales pequeñas, descartables, no bloqueantes, integradas en la interfaz real.
2. Primer recorrido guiado automáticamente SOLO en **partidas nuevas**. Las partidas previas no reciben tutorial forzado; no inferir que todo campo ausente equivale a “partida nueva”.
3. Una opción `Ayuda`, disponible en ubicaciones pertinentes, permite consultar de nuevo todas las explicaciones cuando el jugador lo desee.
4. **Resumen breve** de derrota/progresión siempre visible en los estados pertinentes; explicación contextual ampliada únicamente cuando corresponda a primera experiencia o ayuda solicitada.
5. Mostrar como máximo una tarjeta contextual a la vez. La ayuda no roba turnos, recompensa, desbloqueos, recursos ni acciones y no se superpone a animaciones críticas.
6. Toda variable en los textos se toma del estado real del juego; no fijar costes, XP, intentos, niveles o especies como constantes de tutorial.
7. Preservar continuidad visual, controles y fondos de E4. No añadir nuevas pantallas largas ni navegación obligatoria.

## Alcance E5 · 12 intervenciones de interfaz

| ID | Ámbito | Intervención |
|---|---|---|
| E5-01 | Mapa | Guiar la selección de puntos explorables |
| E5-02 | Stamina | Informar el coste de entrada antes de aceptar |
| E5-03 | Exploración | Distinguir Buscar encuentro y Retomar sin segundo gasto |
| E5-04 | Combate | Interpretar PS, turno y respuesta rival |
| E5-05 | Habilidades | Diferenciar Golpe, Guardia e Insignia consultando el efecto real |
| E5-06 | Entrenador | Identificar resonancias opcionales |
| E5-07 | Equipo | Explicar cambio voluntario y su respuesta rival |
| E5-08 | Derrota parcial | Explicar reemplazo tras caer el activo |
| E5-09 | Derrota total | Explicar recuperación y ausencia de XP |
| E5-10 | Progresión | Interpretar recompensa, barra XP, niveles y límite regional |
| E5-11 | Vínculo | Explicar intentos disponibles y continuación sin vínculo |
| E5-12 | Continuidad | Volver al mapa, reanudar encuentro e interrupciones |

No obliga a crear doce pantallas ni doce scripts. Reutilizar vistas existentes y agrupar lógica de ayuda de manera simple.

## Microcopias aprobadas

Estas cadenas son texto editorial autorizado. Cambios sustantivos se consultan antes de implementar; sustituciones dinámicas y ajustes accesibles de corte de línea son aceptables.

| Contexto | Texto aprobado |
|---|---|
| Primer mapa | "Selecciona un punto del mapa para explorar esa localización." |
| Antes de entrar | "Entrar cuesta {coste} de stamina. Retomar un encuentro no vuelve a cobrarte." |
| Dentro de la localización | "Pulsa Buscar encuentro para descubrir al Karmany de este lugar." |
| Primer combate | "Los PS indican la vida restante. Si llegan a cero, el Karmany queda fuera de combate." |
| Turno | "Puedes usar una resonancia y después actuar con tu Karmany. El rival responderá." |
| Insignia | "Cada Insignia tiene su propio efecto y disponibilidad. Consulta su descripción." |
| Entrenador | "Las resonancias son opcionales. Puedes combatir sin utilizar ninguna." |
| Cambio voluntario | "Cambiar de Karmany consume tu acción. El rival responderá contra el nuevo activo." |
| Reemplazo por derrota | "Tu Karmany ha caído. Elige un compañero disponible: este relevo no provoca otro ataque rival." |
| Derrota total | "Todo tu equipo ha caído. No recibes XP por esta derrota. En el próximo encuentro, el equipo volverá recuperado." |
| Experiencia | "Has ganado {xp} XP. Observa la barra para comprobar tu progreso y las subidas de nivel." |
| Límite regional | "Has alcanzado el límite de experiencia de esta región." |
| Vínculo | "Puedes intentar el vínculo con el Libro. Te quedan {intentos} intentos." |
| Omitir vínculo | "Puedes continuar sin vincular. Tu victoria y la experiencia obtenida se conservan." |
| Regresar al mapa | "Volver al mapa conserva tu encuentro pendiente. Usa Retomar para continuar." |

**Precisión:** mensajes solo en estados verdaderos. No prometer XP en derrotas ni duplicar una recompensa guardada. El comportamiento real de `aftermath_screen.gd` y los demás flujos de Preview 38 tienen prioridad sobre suposiciones de texto; cualquier contradicción funcional debe informarse, no cambiar reglas.

## Criterios de aceptación

| ID | Prueba observable |
|---|---|
| AC-01 | Jugador nuevo localiza y entra en un punto sin orientación externa |
| AC-02 | Stamina clara antes del coste; Retomar nunca cobra una segunda vez |
| AC-03 | Identifica PS, acciones y turno; la ayuda nunca altera combate |
| AC-04 | Ayudas de Insignia/resonancia reflejan opciones realmente disponibles |
| AC-05 | Derrota parcial y reemplazo correctos, sin ataque rival adicional |
| AC-06 | Derrota total: no recibe XP; jugador comprende cómo regresar |
| AC-07 | XP y subida de niveles veraces, ninguna duplicación de recompensa |
| AC-08 | Vínculo opcional: omitirlo conserva la victoria y XP |
| AC-09 | Tutorial y botón Ayuda no bloquean interacción ni estados pendientes |
| AC-10 | Reinicio conserva guardado y estado del tutorial, sin onboarding forzado en guardados previos |
| AC-11 | Texto grande, movimiento reducido, audio/silencio y Atrás de Android funcionan |
| AC-12 | Jade y Bosque, ambas seis etapas, 13 criaturas, arte, finales, relevos, migraciones y demás Preview 38 permanecen idénticos |

**Test de comprensión:** prueba humana sin guía verbal que cubra: (1) elegir punto; (2) coste; (3) Buscar; (4) PS/turno; (5) Insignia/Entrenador; (6) ganar o recuperarse de derrota; (7) XP si gana; (8) vínculo opcional; (9) regresar/cerrar/reanudar. Registrar dudas, fallos y asistencia. Al menos una persona novata completa una localización autónomamente; recomendable tres para contrastar antes de E6.

## Regresiones obligatorias

- **Guardados:** partida nueva, perfil Preview 38, fixtures Preview 32 y E2, batalla abierta, enemigo pendiente, sustitución, derrota, victoria, vínculo pendiente, XP parcial, cierre en tutorial y reapertura.
- **Economía/progreso:** stamina única, recompensa/bonos únicos, captura única, puntos y árbol, XP correcta y topes regionales.
- **Flujos UI:** batalla y transiciones E4, derrota, resumen XP, vínculo, finales con varios rivales, fondo continuo, activación de Ayuda, descartado, no repetición automática en partidas antiguas.
- **Android:** Atrás, pausar/reanudar durante animaciones, cierre/reapertura, tamaño de texto, movimiento reducido, silencio, pantalla pequeña y botones accesibles.
- **Técnicas:** Godot 4.x import limpio, parser/runtime sin errores, suites existentes completas + pruebas E5, CI, exportación/firma y auditoría habitual. No aumentar watchdogs ni debilitar asserts.

## Exclusiones / zonas protegidas

No añadir Karmany, regiones, lugares, narrativa, tutorial narrativo, objetos, habilidades o recompensas. No modificar canon, balance, costes de stamina, XP, dificultad, técnicas, turnos, probabilidades de vínculo, Libro, datos regionales, árbol, motor E1/E2, combate ni migraciones históricas; no rehacer E4 ni su arte. No crear telemetría, cuentas, monetización, servidores ni tareas E6/E7/E8. No modificar `main`.

Si para persistir el tutorial se requiere un dato adicional, usar extensión opcional, aislada y compatible con los guardados existentes; verificar que no altera ni normaliza destructivamente ningún perfil. Work evalúa el mecanismo concreto inspeccionando el código real antes de implementarlo. No sobrescribir guardados ni iniciar tutorial al cargar un perfil previo.

## Entrega exigida a Work

1. Antes de editar: `AGENTS.md`, `docs/ROADMAP_ESTADO.md`, `docs/ROADMAP_CHAT_WORK.md`, `docs/CONTINUIDAD.md` y este contrato; verificar HEAD, historia, PR, CI y estado exclusivo del escritor.
2. Una única rama `feature/e5-primera-sesion` desde `dev/karmany-core` actualizado, sin trabajo paralelo sobre los mismos archivos.
3. Implementar únicamente E5-01 a E5-12; documentar correspondencia requisito → componente y prueba.
4. Ejecutar todas las regresiones, CI y exportar APK candidata identificable; no declarar prueba física por CI.
5. Actualizar `ROADMAP_ESTADO.md` y `CONTINUIDAD.md` EN LA RAMA feature, con SHA, CI, APK y validación humana pendiente.
6. Entregar PR con diff revisable y prueba local de máximo 10 pasos; E5 queda pendiente hasta “prueba correcta” sobre APK/SHA identificable. No integrar a `dev` sin ese hito. `main` intacta.

## Checkpoint documental de aprobación

- **R0:** cerrada, Preview38 aprobada físicamente, PR18 integrado.
- **E5 especificación:** aprobada explícitamente, contrato congelado para Work.
- **E5 código:** no iniciado durante este traspaso documental.
- **Responsable siguiente:** WORK.
- **Siguiente paso:** verificar HEAD real, crear feature desde dev, implementar alcance E5 aprobado y entregar CI/APK/PR para revisión y validación física.


---

## Anexo A4. Fuente íntegra: docs/R1_NAVEGACION_IDENTIDAD.md

SHA256 del archivo fuente: `9d50c2b2aef5f9c7875b46dc848c5b32ebd3719aaf4685a1cd33b1068f984aa4`. Referencia:12605fc.

# R1 · Navegación, identidad y prólogo cinematográfico

**Actualización vigente de cierre R1 (16/10/2026):** Preview42/v0.23.0-r1 aprobada físicamente por el creador; código293ac5e, CI38889069848, SHA256f63f31c12b2588bf7b65dd13f390d4ceb7b8ad9af18abe104960e4d1a81f84f1. Integrada por fast-forward a21c2964; PR20 cerrado/merged verificado. NAV-01/Atrás y QA-01/laboratorio aislado aceptados y diferidos a R1.1, sin implementar. No se atribuyen casos físicos individuales. Ver ROADMAP_ESTADO.md/CONTINUIDAD.md para evidencias y estado real. El contenido inferior conserva el contrato y la guía históricos, no autoriza una nueva implementación ni exige repetir la prueba ya aprobada. No E6/R2–R4.

**Estado:** contrato de diseño cerrado e **implementación R1-01…05 expresamente autorizada por el creador** (15/10/2026). **Responsable de implementación: WORK**. No se ha confirmado inicio de programación, rama activa, CI o APK de R1.
**Decisión expresa del creador:** Ezel es protagonista controlado; Axe es su mentor y presenta el mundo antes de explorar. Prólogo **cinematográfico**, no combate guiado.
**Baseline:** Preview40 aprobada (código `0c356db0fcf003e6c6f56e109d9e1e85addfea1d`; CI38833949394; PR19 integrado) en `dev/karmany-core` @ `6c3f6f4da25dac3c5a4f5866d9043b4c2c68fa48` antes de este documento.
**Responsables:** Chat especifica y revisa; el creador **ha autorizado a Work a comenzar la implementación de R1**. Work es único escritor funcional, con integración bloqueada hasta prueba física correcta identificable. El diagnóstico de partidas reportado por el creador no equivale a certificar la alfa E6 de 5–10 testers.

## Límite del contrato
**R1-01:** prólogo con Axe/Ezel. **R1-02:** navegación principal. **R1-03:** Bestiario visual. **R1-04:** perfil de Ezel. **R1-05:** árbol de resonancias táctil.
**Fuera de R1:** exploración de pantalla completa (R2); tres criaturas visibles en combate y continuidad audiovisual combate→XP→vínculo (R3); PS persistentes, curación y reanimación (R4); cambios de reglas, canon, balance, nuevos enemigos, nuevas regiones y E6 certificación alfa. No reabrir el antiguo E7: Bosque del Velo ya está implementado (6+6 puntos regionales).

## R1-01 · Prólogo cinematográfico breve, omitible y repetible
- Primera partida creada **después de R1**: al concluir satisfactoriamente `App.start_journey()`, ofrecer una escena de 4–5 viñetas durante aproximadamente 45–90 segundos, con imágenes existentes de Ezel/Axe/Zephyr y un escenario de Valle Jade. No combate forzado, ni nuevos objetos, recompensas, gastos de stamina o tutorial de acciones. La guía mecánica real se mantiene en las tarjetas E5.
- Mensajes editoriales propuestos, breves y sin canon adicional:
  1. Axe: «Ezel, antes de emprender el viaje hay algo que debes recordar.» (ambos en el valle)
  2. Axe: «Los Karmany no son solo fuerza. Observa a tu compañero y aprende de él.» (Zephyr)
  3. Axe: «Cada lugar exige esfuerzo. Cuida tu stamina y usa el Libro cuando llegue el momento.» (paisaje y Libro)
  4. Ezel: «Lo entiendo, Axe. Quiero descubrir lo que hay más allá.» (Ezel mira el camino)
  5. Axe: «Entonces, adelante. El camino es tuyo.» (CTA «Explorar Valle Jade»)
- Transiciones suaves y composición cinematográfica (zoom/parallax si procede), sin exigir vídeo ni sonido. **Siguiente, Omitir y Atrás** disponibles; avance manual con tiempo de lectura libre. En modo movimiento reducido, transiciones instantáneas. Texto grande sin solapamientos. Una repetición voluntaria de «Ver introducción» desde Opciones no escribe, no cambia progreso ni reinicia E5.
- **No forzar en guardados antiguos.** `campaign.intro_seen` ya existe, pero no debe interpretarse su valor `false` heredado como permiso de forzar el nuevo prólogo. Introducir una marca opcional `r1_intro` (ejemplo `{version:1,status:"pending|completed|skipped"}`), creada únicamente en viaje nuevo posterior a R1, y validarla sin invalidar perfiles previos. **Campo ausente = partida anterior, sin intro automática.** Completar u omitir escribe marca e `intro_seen` de modo transaccional con SaveStore; preserva schema3 si es compatible. Ante fallo, avisar sin bloquear navegación ni fingir persistencia. Pausa/reanudación y Android Back no generan bucles ni dobles efectos.
- Escena visible solo antes del primer recorrido. Al terminar u omitir, mismo destino: mapa de regiones/Valle Jade, sin saltarse ayudas E5 posteriores.

## R1-02 · Navegación inequívoca
- Inicio con `Continuar aventura`, `Nueva partida` (confirmación destructiva actual), `Ajustes`. «Diagnóstico» permanece accesible desde Opciones/Ajustes, no como prioridad de jugador novato.
- `Continuar aventura` conduce a exploración o combate pendiente si lo hay, sin gasto adicional; si no hay encuentro, abre mapa Shisai. Una partida no creada nunca finge progreso.
- Mapa: tarjetas de región **Valle Jade** y **Bosque del Velo** con fondos existentes, progreso real `completadas/6`, estado y acceso «Explorar región» o requisitos reales. El mapa regional muestra sus puntos. Abrir región **no cobra stamina**: el coste sigue en la entrada real a una localización. Mantener bloqueo y precio del Bosque.
- Ocultar duplicados «Entrar al valle jugable» y `Visitar` (la acción que solo modifica `journey.visited_jade`). **Conservar ese campo histórico** en guardados y su actualización legítima al iniciar encuentro; no cambiar IDs ni barreras.
- Libro, Bestiario, Entrenador y Árbol quedan en menú accesible. Navegación Atrás coherente, sin pantallas vacías ni reseteos.

## R1-03 · Bestiario con ilustración, silueta y datos ciertos
- El catálogo en `data/jade_species.json` (15) y `data/veil_species.json` (6) tiene **21 entradas canónicas**. `data/tactical_combat.json` ofrece estadísticas para **13 especies de combate**. El inicial **Zephyr** pertenece al equipo, pero no es una de las 21 fichas canónicas: mostrarlo en Equipo/Perfil, **no aumentar artificialmente el catálogo a 22**.
- Vista en tarjetas con ilustración, nombre/rareza y filtro. Especie no vinculada: silueta de la ilustración si existe o silueta neutral, sin revelar ficha completa ni cifras. Vinculada (verificar **`campaign.collection`**, no simulaciones del árbol): sprite real, nombre, bioma/rareza, resumen de 1–2 frases extraído de `physiology`/`behavior`, estadísticas **base Nv1** desde `CombatCatalog.stats_at_level(id,1)`.
- Si faltan arte o estadísticas en una especie canónica, usar recurso de reserva legible o «Datos de combate aún no disponibles». **No inventar arte canónico ni números.** No cargar `TrialStage.texture(id)` si la ruta de imagen no existe; manejar su ausencia. Las fichas de criaturas adquiridas no desaparecen al mover el equipo; duplicados capturados se muestran como una especie.
- Mantener el catálogo original sin modificar ni copiar imágenes de Monster Galaxy. La galería se adapta al ancho y funciona con toque, scroll, texto grande y fondos de baja gama.

## R1-04 · Perfil jugable de Ezel
- Reemplazar `main.gd::_trainers()`, hoy explicación abstracta, por tarjeta de **Ezel** (sprite existente), nivel y XP desde `skill_tree.level`/`campaign.progression.trainer_xp`, puntos disponibles, resonancias **realmente equipadas** con nombre/rango desde `skill_tree.equipped`/`ranks`.
- Mostrar retratos de **todos los integrantes reales del equipo, de 1 a 3**, nombre de especie, estado activo/reserva, nivel desde `campaign.progression.units[instance_id]` y accesos a Equipo/Árbol/Libro. Conservar `instance_id` para dos individuos de la misma especie.
- **Axe es mentor**, no personaje elegible ni segundo entrenador jugable. Sin nuevas habilidades, bonificaciones ni compras; limpiar textos de placeholder de «reglas de prueba» de la vista de jugador, conservándolos solo en Diagnóstico.
- No presentar PS como persistentes fuera de encuentro: ese cambio de reglas pertenece a R4.

## R1-05 · Interacciones táctiles del árbol
- Problema encontrado: `scripts/skill_tree_map.gd` usa un `Control` de altura mínima 320 y escucha arrastres desde botones individuales, dentro de un `ScrollContainer` exterior. Rediseñar zona de arrastre para que funcione sobre fondo, enlaces **y nodos**, sin obligar a empezar en un hueco.
- Tap corto selecciona, drag arrastra el mapa sin activar selección; separación por umbral adaptado a densidad/resolución. Soporte mouse/Android, desplazamiento cuando hay contenido fuera de vista y conservación de posición tras seleccionar. No permitir controles fuera de límites.
- La compra/equipamiento continúa mediante botón explícito y validación actual. **Ningún gesto de movimiento debe gastar puntos, comprar o equipar**. Mantener `trainer_skill_tree.gd`, JSON, rangos/costes y economía sin cambios.

## Pruebas de aceptación obligatorias
1. Nueva partida R1 inicia secuencia de Axe/Ezel una vez; terminar y omitir llegan al mismo mapa, sin batalla tutorial ni premios.
2. Guardados anteriores Preview32/E2/38/40 no muestran prólogo forzado ni mutan al cargarse. Repetir la secuencia desde Opciones es de solo lectura.
3. Pausa, cierre, reinicio, Atrás y modo sin sonido/movimiento reducido no bloquean el prólogo; fallo de guardado informa sin sobrescribir partida.
4. «Continuar» recupera scouting, combate y estado exacto del encuentro, sin segundo pago de stamina, XP o captura.
5. Desaparecen «Visitar» y CTA duplicado. Requisitos de Bosque, mapas 6+6 y progresión intactos.
6. Bestiario lista 21 entradas canónicas, con siluetas para no vinculadas, arte auténtico para vinculadas y stats Nv1 solo si existen; Zephyr se ve en perfil/equipo, sin cambiar el total del catálogo.
7. Captura duplicada no duplica ficha; ausencia de sprite o stats no causa crash. Se validan filtros y pantalla pequeña.
8. Perfil Ezel refleja nivel, XP, resonancias y 1–3 criaturas equipadas; Axe nunca se presenta como jugador.
9. Árbol: 20 arrastres Android desde nodo, enlace y zona vacía desplazan correctamente; taps seleccionan; drag no compra; compra/equipamiento sigue seguro; texto grande funciona.
10. Suite y regresiones históricas completas: Preview32, E2, Preview38, Preview40, copias .bak y .tmp, premios únicos, E5, dos regiones y finales, Sakuromushi, capturas, XP y turnos sin alteración.
11. CI, Android APK, firma y SHA verificados. PR propio; sin integración a dev hasta declaración física «prueba correcta» de la APK R1 correspondiente.

## Límites de ejecución
**R1 está especificado y AUTORIZADO por el creador para su implementación exclusiva por Work.** Work verifica HEAD/AGENTS/PR/CI, crea `feature/r1-navegacion-identidad` desde dev real si no hay otra implementación activa, implementa R1-01…05 y solo las pruebas/regresiones necesarias. No integrar sin validación física; no tocar main, E6 ni R2/R3/R4. Ninguna CI/APK nueva se afirma aquí.
**SIGUIENTE PASO:** Work inicia R1-01…05 en rama feature, genera PR/CI/APK candidata; Chat audita y el creador prueba físicamente antes de integrar.
**RESPONSABLE:** WORK para implementación R1; Chat revisa en solo lectura.
**INSTRUCCIÓN PARA CONTINUAR:** «El creador autorizó expresamente implementar R1-01…05. Verifica HEAD y escritor activo, lee docs/R1_NAVEGACION_IDENTIDAD.md, AGENTS y estado, crea feature desde dev vigente y programa solo este contrato. No implementar E6, R2/R3/R4, reglas o balance; genera PR/CI/APK y espera validación física explícita antes de integrar».

---

## Anexo A5. Fuente íntegra: docs/R1_1_NAVEGACION_LABORATORIO_QA.md

SHA256 del archivo fuente: `147835a8ba01e142f52553166166fc95ca36ba2e3b5a6a2f6441bd8e4f62ebe0`. Referencia:12605fc.

# R1.1 — Navegación contextual (NAV-01) y Laboratorio QA aislado (QA-01)

**Estado:** CONTRATO CERRADO Y AUTORIZADO PARA IMPLEMENTACIÓN POR WORK. **Fecha:** 16/10/2026.
**Orden del creador:** «Sí, autorizo», en respuesta a la propuesta de iniciar R1.1 con NAV-01 y QA-01, configurando niveles/equipo/regiones en un laboratorio separado del guardado real. No hace falta volver a solicitar autorización de diseño.
**Baseline verificado antes de este documento:** `dev/karmany-core @ 672684b6167cc1537f8cf6bafd6831fc9de889fb`; R1/PR20 cerrado, Preview42/v0.23.0-r1 físicamente aprobada; código APK `293ac5efb1b781258065171384db58db47b77aec`, CI `38889069848`, SHA-256 `f63f31c12b2588bf7b65dd13f390d4ceb7b8ad9af18abe104960e4d1a81f84f1`. Work debe comprobar HEAD actualizado y PR antes de tocar código.
**Responsable exclusivo de implementación:** WORK en una nueva rama `feature/r1-1-navegacion-qa` basada en el HEAD documental de dev vigente. **CHAT:** diseño, revisión y pruebas; **CREADOR:** prueba física de la APK candidata.
**Exclusiones:** E6, R2, R3 y R4 NO autorizados; sin cambios en mecánicas normales, PS persistentes, curación, reglas, balance, canon, regiones o contenido. No tocar `main` ni integrar a `dev` antes de aprobación física.

## Contexto real de código
- `scripts/main.gd::_show(next_page)` reconstruye la página y `_back()` usa destinos fijos; `trial_ui.gd` emite `navigate("team"/"collection"/"book"/"settings"/"home"/"jade_play")`. Entrar desde exploración al Libro o Ajustes y usar Volver puede llevar a Home, perdiendo ubicación visual (no necesariamente datos).
- `main.gd::_refresh_combat`, `_toggle`, `_tree_action`, `_team_action` y `_select_tree_node` pueden redibujar la pantalla actual. **No deben llenar un historial de navegación con duplicados.**
- `main.gd::_tree_lab` está en Diagnóstico y llama `_tree_action("level"|"capture"|"reset")`. `App.change_tree()` usa `commit_profile()` y `SaveStore("user://profile.json")`: el laboratorio actual **sí puede modificar el perfil principal**. Sustituir o aislar estas acciones, no perpetuarlas accidentalmente.
- `SaveStore` dispone de validación `schema=3`, escritura transaccional y respaldo `.bak`/`.tmp`, soporte de guardados antiguos. `TrialCampaign.valid` valida colección, `Roster.valid` equipo, `LevelProgression.valid` los niveles y XP; `TrainerSkillTree.valid` puntos, rangos y desbloqueos. Un preset QA es **un estado sintético válido**, no saltarse validadores.
- Rutas Jade y Velo: **6 + 6** etapas. 13 especies de combate con estadísticas, 21 fichas de Bestiario no equivalen a 21 combatientes.

## NAV-01 — Navegación Atrás contextual

### Contrato funcional
1. Mantener un historial de navegación **solo de rutas reales de usuario**, no de reconstrucciones de UI: modelo de pila o estado anterior explícito (`origin_page` + `origin_mode` cuando proceda). Registrar origen antes de entrar a sección desde `TrialUI.navigate`, tarjetas de Shisai, perfil, equipo, colección, árbol, Libro, Bestiario o Ajustes.
2. «Volver» de cabecera y Atrás de Android deben usar una misma función, con esta prioridad: confirmar/cerrar cuadros modales visibles; procesar transición, cinematografía o ayudas por su protocolo actual; regresar al origen contextual existente; por último, usar destino seguro (mapa/región) cuando no hay origen válido. Nunca dejar una pantalla destruida referenciada por historial.
3. Ejemplos obligatorios:
   - **Exploración Jade → Opciones → Libro → Atrás = Exploración Jade** (sin pasar por Home).
   - **Exploración → Equipo → Colección → Atrás = Equipo → Atrás = Exploración**.
   - **Shisai → Bestiario → Ficha → Atrás = Bestiario → Atrás = Shisai**.
   - **Exploración → Perfil Ezel → Árbol → Atrás = Perfil → Atrás = Exploración**.
   - **Home → Ajustes → Diagnóstico → Atrás = Ajustes → Atrás = Home**.
   - **Laboratorio QA → pantalla o batalla QA → Atrás = Laboratorio o mapa QA**, según destino real.
4. **Separar** «Atrás/Volver» de «Ir al mapa», «Menú principal», «Abandonar combate» y «Viajar a otra región». Los botones con destino explícito mantienen su función; no deben ser reinterpretados como Volver. Si se abandona una batalla debe seguir existiendo confirmación y semántica del motor original.
5. Proteger batalla pendiente, respuesta rival programada, relevo, captura, derrota, recompensas, XP, vínculo, transición cinematográfica y prólogo R1. Salir visualmente sin terminar encuentro **no** consume nueva stamina, no duplica XP/recompensas ni resetea HP/turnos. Volver desde pantalla de combate debe conservar su estado real y permitir Retomar.
6. Restablecer/invalidar historial al iniciar Nueva partida, al reemplazar un perfil, entrar/salir de modo QA o tras recargar datos incompatibles. Limitar profundidad, deduplicar, manejar rutas inexistentes sin recursividad. No persistir el historial dentro de `user://profile.json` ni introducir migraciones.
7. `_refresh_combat`, selección de nodo, ajuste de preferencias, operación de equipo/árbol y recreación de la pantalla activa deben usar un método `refresh_current()` o `navigate(..., record_history=false)`; cambios de modo `battle`/`exploration` también evitan apilar estados obsoletos. Comprobar comportamiento cuando `TrialUI` reemplaza su nodo.
8. Accesibilidad: mismo comportamiento con botón Volver, gesto/sistema Atrás Android, letras grandes, pausar/reanudar, orientación/tamaño de pantalla.

### Archivos candidatos
`scripts/main.gd` y `scripts/trial_ui.gd` como consumidores de navegación; un controlador `scripts/navigation_history.gd` aislado y testeable es preferible a una cadena de casos. Cambios en `scripts/r1_prologue.gd` únicamente si se detecta conflicto real con prioridad Atrás, sin alterar historia.

## QA-01 — Laboratorio QA totalmente aislado

### Riesgo y separación obligatoria
1. Al entrar al Laboratorio desde `Ajustes → Diagnóstico`, activar un **modo QA claramente identificado en todo momento** (rótulo «LABORATORIO QA · NO AFECTA TU PARTIDA»). Guardado principal de producción: `user://profile.json`, `profile.json.bak`, `profile.json.tmp` y copias `.pre-unification`, si existen. **Ningún botón QA ni acción iniciada en QA puede escribir, reordenar, sobrescribir o renombrar esos archivos.**
2. Crear un almacén QA **distinto** en directorio propio (recomendación `user://qa/profile.json`, con `.bak`/`.tmp` específicos) usando un `SaveStore` parametrizado o aislamiento equivalente; validar directorio y permisos. No utilizar el guardado primario como plantilla modificable: iniciar un perfil QA sintético con `SaveStore.defaults()` y solo datos compatibles con `SaveStore.valid`.
3. No basta cambiar el título: todas las escrituras de `App.commit_profile`, cambio de árbol, equipo, exploración, avance, recompensas, respuestas automáticas de enemigo, navegación/ayudas y cierre de app deben permanecer en el almacén QA cuando está activo. Añadir salvaguarda de ruta de escritura y pruebas que fallen inmediatamente si QA intenta escribir el perfil real. Los procesos/Timer en curso deben detenerse/reprogramarse correctamente al cambiar el perfil, evitando callbacks tardíos contra el perfil equivocado.
4. Al entrar al modo QA, guardar referencia/snapshot solo en memoria del estado real y **no ejecutar `start_journey()` real**. Al salir, recargar perfil principal desde almacenamiento validado y mostrar su estado exacto; si la recuperación falla, indicar error y mantener el perfil en modo seguro, **sin sobrescribir archivos válidos**. Si la app se cierra estando en QA, al reiniciar debe cargar la partida principal por defecto; volver al QA requiere entrada explícita.
5. `Nueva partida` dentro de QA, si se ofrece, resetea únicamente el perfil QA. `Restablecer laboratorio` exige confirmación pero nunca elimina un guardado real. Impedir cualquier exportación, transferencia o aplicación del progreso QA sobre la partida real. QA no es una solución para recuperar una partida perdida; es un entorno separado para reproducir pruebas.
6. Herramientas QA disponibles solamente en builds de desarrollo/preview mediante condición explícita de exportación/compilación comprobable. Nunca asumir `OS.is_debug_build()` por sí solo si la configuración de exportación pueda compilar release con la opción encendida. En builds publicables ocultar/desactivar entrada y mutadores del laboratorio. Conservar `Diagnóstico` de solo lectura en builds normales si ya existe.

### Controles de pruebas aprobados
- **Preset entrenador Ezel Nv. 1–15** y valor de XP parcial coherente; accesos rápidos Nv. 1/5/10/15. Sin exceder cap real `trainer_skill_tree.json` y respetar `LevelProgression.requirement()`/`SaveStore.valid()`.
- **Equipo de 1 a 3 Karmany**, entre **13 especies reales disponibles en `data/tactical_combat.json`**, nivel individual ajustable Nv. 1–15, con activo elegible y `instance_id` únicos. Zephyr como inicial; para compañeros sintéticos crear colección con entradas y contadores **consistentes** y válidos; no mutar el Bestiario canónico real ni fingir capturas históricas del usuario.
- **Región** Jade o Bosque del Velo y **localización 1–6**; lanzar directamente ese escenario sin completar manualmente toda la campaña QA. Preparar requisitos/unlocks y historial de ruta **solo en QA**, satisfaciendo validación estricta del motor. Si una ruta requiere puntos/recompensas anteriores, construir una fixture QA coherente o un adaptador exclusivo de modo QA; **no relajar validadores globales ni reglas de partidas normales**.
- **Stamina**: preset completa (y, cuando útil, 0 u otro valor válido) para reproducir costes/errores, sin otorgarla al perfil normal. Permitir «Reiniciar escenario QA» para repetir combates sin recompensas duplicadas reales.
- Mostrar resumen de configuración antes de iniciar; botones «Aplicar en laboratorio», «Probar escenario», «Reiniciar QA» y «Salir al juego normal». Todo en pantalla accesible con texto grande; los controles QA no deben confundirse con controles de juego real.
- Configuraciones altas permiten simular acceso aunque el jugador real no haya desbloqueado una región. Ni puntos, XP, especies, stamina, etapas ni recompensas de QA pueden aparecer en `user://profile.json`.

### Modelo de validación y riesgos
- Generar presets mediante funciones/modelos existentes (`TrialCampaign`, `LevelProgression`, `TrainerSkillTree`, `Roster`, `ProgressRules`, `SaveStore`) y verificar cada transición con los mismos `valid()` del juego normal. En modo QA se admiten datos sintéticos **solo si pasan todas las invariantes**: niveles, XP parcial, puntos gastados, equipo/propiedad, victorias/capturas si se utilizan, secuencia, desbloqueos y etapas completadas. No eliminar tests o aserciones para forzar el acceso al Bosque.
- Mantener `qa/profile.json` recuperable y separado; falla de escritura QA -> mensaje de error + salida sin daño. La creación de QA fallida no debe activar parcialmente el modo ni tocar la partida normal.
- Evaluar si `main.gd::_tree_lab` se elimina como mutador o se mueve **dentro** de la sesión QA. Hasta entonces está prohibido promocionarlo como herramienta segura. Registrar que los usuarios de Preview42 deberían evitarlo en partidas valiosas.
- No agregar atajos QA en el menú normal de primera partida ni comandos secretos que puedan activarse accidentalmente. Acceso desde diagnóstico con confirmación.

## Criterios de aceptación automatizados obligatorios
**NAV01:** probar las cinco cadenas de navegación anteriores desde sus contextos reales (incluido `TrialUI.navigate`), con botón y Atrás Android; compare estado de página y `campaign`.
**NAV02:** editar ajustes/comprar resonancia/ver nodos/refrescar combate 20 veces sin historial duplicado, loops ni salto a Home. Comprobar límite de pila y desaparición de pantallas destruidas.
**NAV03:** battle→map→retomar conserva `encounter.id`, `revision`, HP, turno, cola de respuesta, XP/stamina, con cero premios duplicados. Probar selección de reserva, captura, prólogo y ventanas.
**QA01:** conservar bytes y/o SHA-256 de los cuatro archivos primarios históricos si existen (`profile.json`, `.bak`, `.tmp`, `.pre-unification`) antes y después de crear QA, editar, ganar/derrotarse y salir; impedir operaciones incluso ante fallos de persistencia. Es preferible comparar copias binarias además de perfiles lógicos.
**QA02:** presets niveles 1,5,10,15 con XP consistentes, Ezel y 1–3 unidades, especies válidas y `SaveStore.valid=true`; combinaciones con capturas sintéticas y duplicados con IDs únicos.
**QA03:** 12 entradas directas, seis de Jade y seis de Velo, y finales de dos enemigos; funcionamiento sin progreso normal; pruebas de bloquear/desbloquear QA y stamina cero.
**QA04:** cambiar perfil durante encuentro pendiente y Timer de respuesta; ningún callback altera el perfil real; reabrir app carga partida normal, no QA.
**QA05:** corrupción de `qa/profile.json` y/o fallo de escritura recupera o informa **sin acceder al perfil real en modo escritura**; reset QA tampoco modifica partida real.
**QA06:** atajos de laboratorio inexistentes/inaccesibles en export de producción, incluso si Diagnóstico sí existe. La suite debe probar ambas configuraciones.
**REG01:** intactos Preview32/E2/38/40/42, `SaveStore` schema3, E5 ayudas, R1 cinematográfica, guardado transaccional y dos regiones/12 puntos.
**REG02:** CI completa, export, firma, certificado compatible para instalar encima de Preview42, hash SHA-256 del APK e informe del PR; no basta CI si falla hardware.

## Pruebas físicas breves — creador
1. Sobre una partida existente de Preview42: Exploración → Equipo → Colección → Atrás dos veces = Exploración, nunca Home.
2. Desde exploración: Libro/Ajustes/Perfil/Bestiario → Atrás regresa a exploración; desde ficha Bestiario → Bestiario; botón Atrás Android coincide.
3. Con combate vivo, abrir otra pantalla y regresar sin reiniciar combate ni descontar stamina de nuevo.
4. Diagnóstico → Laboratorio QA: configurar Ezel Nv.10, equipo de tres y Bosque del Velo punto 6, probar escenario sin completar Jade. Confirmar indicador QA siempre visible.
5. Salir QA: equipo, niveles, stamina, regiones, capturas y partidas originales exactamente iguales.
6. Cerrar app dentro QA, reabrir; debe abrir partida normal. Restablecer QA solo borra sesión de prueba. Texto grande y dispositivo Android verificables.

## Entrega / puertas
- Work verifica git HEAD, ramas, PR y CI antes de crear `feature/r1-1-navegacion-qa` desde el HEAD actualizado. Único escritor de implementación. **Puede programar R1.1 sin pedir otra autorización**, pues el creador la concedió.
- Mantener `dev/karmany-core` y `main` intactas durante implementación. No E6, R2, R3 ni R4, no corregir PS ni modificar experiencia exploratoria/combate excepto el regreso de navegación y el modo QA.
- Entregar PR propio, CI completa, APK candidata **con numeración nueva libre** (no asumir Preview43 sin comprobar), SHA256, manifiesto/firma, lista de cambios, pruebas de aislamiento, incidencias y seis comprobaciones físicas.
- No integrar a dev hasta mensaje explícito del creador «prueba correcta» identificando número de la nueva APK; no reclamar pruebas físicas sintéticas como reales.
- Documentación y estado en rama feature; Chat revisa PR y acompaña pruebas.

**SIGUIENTE PASO:** WORK implementa NAV-01 y QA-01; Chat audita PR, CI y APK, creador prueba físicamente.
**RESPONSABLE ACTUAL:** WORK como escritor R1.1, solo tras recibir esta instrucción vía Work.
**INSTRUCCIÓN PARA CONTINUAR:** «En axenoban/karmany-monsta-android, el creador autorizó R1.1. Verifica HEAD real de dev, historia Git, ramas, PR y CI. Lee AGENTS, ROADMAP_ESTADO, ROADMAP_CHAT_WORK, CONTINUIDAD y docs/R1_1_NAVEGACION_LABORATORIO_QA.md. Implementa exclusivamente NAV-01 y QA-01 en feature/r1-1-navegacion-qa, sin afectar guardados reales ni cambiar reglas. Entrega PR, CI y APK candidata SHA verificable; no integres dev/main sin prueba física correcta. No E6, R2, R3 ni R4».

---

## Anexo A6. Fuente íntegra: docs/R1_1_IMPLEMENTACION.md

SHA256 del archivo fuente: `4d0680d00b71711985d9ca3c375dcf95c56943dfc4ff375c9a523bd58c387f8c`. Referencia:12605fc.

# R1.1 · implementación y validación

Base documental:29be7ba. Base funcional aprobada:Preview42/293ac5e. Candidata:Preview45/v0.24.0-r1.1, código636565422baa63dd4cc0f5026e55361ccd8f4fe1; CI38955362578 correcta. SHA256701108382045758c013bb5ed5cceaddeae4e5f5970822770fb704b3c5242ef08. Evidencia completa en R1_1_CANDIDATA_VERIFICACION.json. Work implementa, Chat revisa; no integración en dev/main sin prueba física explícita.

La primera ejecución PR21/Preview43 corresponde a cef00c5 y queda sustituida por la corrección de repetición de escenarios: el laboratorio conserva en memoria su preset al volver de combate y mantiene preferencias de accesibilidad al aplicar/reiniciar escenarios. Se añadió comprobación de igualdad de configuración tras regresar. No se entregó ni aprobó físicamente Preview43.

## NAV-01

`navigation_history.gd` guarda hasta32 nombres de ruta, deduplica redibujos y colapsa retornos a ancestros. `main._back` comparte botón y Android, cierra modales antes de los protocolos de ayudas/transiciones y vuelve al origen. Cambios de perfil/nuevo viaje invalidan historia. `TrialUI` ofrece Volver contextual y mantiene Mapa explícito. Ninguna navegación llama a iniciar encuentro ni concede recompensas.

## QA-01

`qa_profile.gd` construye desde defaults perfiles sintéticos estrictamente válidos, Ezel1–15/XP parcial, equipo1–3 de13 especies, niveles individuales/activo, región/etapa y stamina. Zephyr es la instancia inicial única; otras especies admiten duplicados con ID propio. Historial de rutas sintético ordenado para las12 entradas.

El adaptador QA omite exclusivamente la puerta de nivel/desbloqueo regional en `start_route`, `_start_encounter` y `select_region`, solo con `qa_active`. Los validadores, costes, estadísticas, combate, recompensas y guardados normales conservan sus reglas. No se alteran archivos de datos salvo metadatos de versión, ni recursos gráficos.

`qa_store.gd` fija `user://qa/profile.json`; App comprueba modo/almacén/ruta antes de guardar. Crear QA fallido no cambia el contexto. Salir recarga el almacenamiento normal validado; un error mantiene QA y muestra aviso sin escritura real. Reiniciar la aplicación nunca restaura modo QA automáticamente. Reiniciar QA requiere confirmación. No hay exportación en QA. Generación de Timer y contexto de botones impiden callbacks antiguos tras cambiar perfil.

Build preview:feature de exportación explícita `qa_preview`. Editor:requiere además `karmany/qa/development=true` (no activada por defecto). Producción sin feature no muestra entrada ni habilita simuladores. El antiguo laboratorio que mutaba la partida real fue sustituido; la redistribución normal de resonancias permanece operativa.

Indicador QA en CanvasLayer100, incluso sobre transiciones/captura. Controles en panel desplazable; letras grandes verificadas en render1280×720. Las pruebas de hardware siguen pendientes.

## Evidencia local

-CI final:31 suites Godot/5.857 comprobaciones sin fallos,3 pruebas Python; export/firma v2-v3 y publicación correctos.
-Suite R1.1 final:233 comprobaciones correctas, incluyendo perfiles/bytes principales, ruta errónea, archivo temporal no escribible, corrupción QA/recuperación, fallo de recarga normal, reinicio de App, callbacks, combate victoria/derrota, XP/recibo/captura únicos,12 etapas/finales dobles, navegación y Preview42.
-Interfaz:32 comprobaciones correctas,8 renders laboratorio/exploración/combate con texto normal/grande; logs sin errores.
-7 fixtures Preview42 emitidas por checkout exacto293ac5efb1b781258065171384db58db47b77aec, script reproducible `ci/recovery/generate_preview42_fixtures.gd`. Las regresiones históricas32/E2/38/40 se conservan.
-El test fundacional ahora establece rutas reales antes de comprobar Atrás, en lugar de suponer destinos fijos tras una lista artificial de pantallas. No se eliminaron sus aserciones.
-El test de captura usa tiradas deterministas y distingue la nueva ficha de unidad de una duplicación de XP. No se modifica el motor para satisfacer el test.

## Prueba física pendiente

1.Actualizar sobre Preview42 sin desinstalar. Exploración→Equipo→Colección→Atrás dos veces vuelve al origen.
2.Libro/Ajustes/Perfil/Bestiario vuelven al origen; ficha vuelve al Bestiario. Comprobar botón y gesto Android.
3.Combate vivo→mapa→retomar conserva encuentro y stamina.
4.Ajustes→Diagnóstico→Laboratorio QA: Ezel10, equipo3, Velo6. Confirmar indicador permanente y dos enemigos.
5.Salir QA: comparar equipo/niveles/stamina/regiones/capturas originales. Reiniciar QA no afecta la partida.
6.Cerrar app en QA y reabrir: carga partida normal. Comprobar letras grandes.

**SIGUIENTE PASO:** Chat revisa PR21/contrato/evidencias en lectura y acompaña la prueba física dePreview45.
**RESPONSABLE:** CHAT.
**INSTRUCCIÓN PARA CONTINUAR:** En axenoban/karmany-monsta-android revisa en lectura R1.1/PR21, código636565422baa63dd4cc0f5026e55361ccd8f4fe1, CI38955362578 y Preview45/SHA701108382045758c013bb5ed5cceaddeae4e5f5970822770fb704b3c5242ef08. Contrasta docs/R1_1_NAVEGACION_LABORATORIO_QA.md, R1_1_IMPLEMENTACION.md y R1_1_CANDIDATA_VERIFICACION.json; acompaña las seis pruebas físicas. No modifiques código ni integres dev/main antes de confirmación explícita «prueba correcta, Preview45». No E6/R2–R4.


---

## Anexo A7. Fuente íntegra: docs/DECISIONES_ENTRENADORES_03.md

SHA256 del archivo fuente: `9cf80cad4ba78eb6b7a0262f74a220ead1f11b755d15778827b8e42f3b041783`. Referencia:12605fc.

# Decisiones aprobadas y propuesta de entrenadores

Actualización: 14 de octubre de 2026. El creador aprobó Preview 4 y pidió aplicar las sugerencias 1 y 3; aclaró que las resonancias son habilidades del entrenador.

## Aprobado

- Equipo de hasta tres Karmany, uno activo por bando.
- Vida, Ataque, Defensa y Velocidad; valores por especie todavía pendientes.
- Tres habilidades iniciales por especie, incluida una insignia; efectos y valores todavía pendientes.
- Las resonancias son habilidades del entrenador. Habrá distintos tipos de entrenador, con distintas funciones.
- Aclaración posterior del creador: entrenador y Karmany comparten el turno; evitar turnos separados. El entrenador debe poder aprender resonancias y construir estrategias más complejas, sin quedar limitado a curar.
- Aprobado posteriormente: una acción del Karmany y una resonancia opcional dentro del mismo turno, en orden libre. Resonancias especiales o explosivas según tipo y personalidad; biblioteca/escuela permite aprender resonancias generales sin depender del tipo.
- Tipo Curador: sus resonancias curan a sus Karmany. Todavía sin nombres, cantidades, recursos, recargas o selección de objetivos definidos.
- Tabla del Libro: Inicial Común 45%; Mejora 1 Común 60%/Raro 30%; Mejora 2 Común 75%/Raro 45%/Épico 20%. Cada cifra es por intento. Las rarezas no incluidas están bloqueadas.
- Tres intentos después de derrotar a un Karmany elegible; escape al agotar intentos y posibilidad de otro encuentro.

Las descripciones de resonancia lumínica/sombría de la enciclopedia son referencias ecológicas y narrativas. No se borran ni se convierten automáticamente en habilidades activables de una criatura. Las habilidades de Karmany y del entrenador deben tener catálogos independientes.

## Implementación de este bloque

Datos de Libro separados de lógica de captura, validación de mejoras que no reduzcan acceso/probabilidad, configuración de estructura, equipo con identidad individual y único activo, y registro de tipos de entrenador ampliable. Solo Curador está registrado; no se asigna un tipo a Ezel o Axe. El curador tiene habilidades vacías de forma explícita hasta definirlas.

Las pantallas del Libro y Entrenadores consultan esas reglas reales. No permiten comprar mejoras ni conceden un entrenador o Karmany inicial. Motor, firma, paquete y guardado aprobado se conservan.

## Propuesta de funcionamiento para decidir

La recomendación anterior de sustituir la acción del Karmany por la del entrenador se retira como propuesta principal tras la aclaración del creador. No está implementada.

Regla aprobada: un turno compartido del bando permite hasta una acción del Karmany y una resonancia opcional del entrenador. El jugador decide el orden de ambas. El entrenador no tiene una entrada propia en la iniciativa ni un turno adicional. La resonancia ocupa su propio cupo dentro del mismo turno. Frecuencia/coste de cada habilidad y orden de iniciativa entre bandos siguen pendientes.

Ejemplos funcionales de combos para revisar, sin nombres canónicos ni valores: potenciar antes de atacar, proteger antes de una acción arriesgada, actuar con el Karmany y después curarlo, controlar al rival para apoyar otra acción. El orden importa solo cuando las reglas de duración/objetivo y resolución lo hagan relevante; no añadir pasos obligatorios sin efecto táctico.

La existencia de más botones no garantiza mayor profundidad. Si todas las resonancias son gratuitas y siempre convenientes, usarlas pasa a ser una rutina obligatoria. Necesitamos elecciones entre funciones y entre usar ahora o reservar, mediante costes y/o recargas, sin decidir cantidades todavía.

## Aprendizaje y especialización

Requisito confirmado: el entrenador aprende resonancias y puede desarrollar más de una estrategia. Curador es una función de ejemplo, no un catálogo limitado a repetir curación.

Propuesta para aprobación: distinguir resonancias aprendidas de resonancias equipadas para el combate. El personaje conserva sus aprendizajes, pero prepara una selección antes del encuentro. Cantidad de huecos, método de adquisición y posibilidad de cambiar durante el combate siguen pendientes.

Regla aprobada: el acceso a resonancias generales de la biblioteca/escuela no depende del tipo del entrenador. Las especiales o explosivas dependen de su tipo y personalidad. No asignar bonificaciones, árboles de habilidad, rasgos de personalidad o poderes concretos sin fuente/aprobación. Ezel todavía no tiene tipo ni personalidad jugable configurados.

Funciones posibles para revisar, todavía no aprobadas ni registradas salvo Curador:

| Tipo propuesto | Función propuesta |
|---|---|
| Protector | Mitigar daño o proteger al equipo. |
| Potenciador | Mejorar temporalmente capacidades de sus Karmany. |
| Controlador | Dificultar acciones o capacidades del rival. |

Son funciones de diseño, no nuevos personajes ni escuelas canónicas. No asignar afinidades elementales, nombres de poderes, estadísticas o lore sin fuente/aprobación.

## Decisiones que bloquean el combate completo

1. Definir tipo y personalidad de Ezel para su resonancia especial/explosiva.
2. Definir repertorio, método y coste de aprendizaje de la biblioteca/escuela, y si se preparan resonancias para cada encuentro.
3. Definir primer repertorio versátil del entrenador: funciones, objetivos, frecuencia y coste; no limitarlo arbitrariamente a curación.
4. Aprobar fichas de balance de Karmany: valores de estadísticas, daño, técnica e insignia. Los nombres/efectos no se inventan por analogía con Monster Galaxy. Orden de iniciativa y cambio de activo siguen pendientes de confirmación.

Orden práctico recomendado: definir identidad jugable de Ezel y repertorio; después presentar fichas de efectos/balance juntas para revisión. Los casos de cambio de criatura, derrota durante un combo y cierre del turno se especificarán antes de conectarlos al encuentro.

Ya se implementaron contratos internos de turno compartido y aprendizaje. No están conectados todavía a un combate ni a una escuela en el mapa. El bloque 03 sigue pendiente de validación física; no se integra automáticamente a dev/karmany-core por aprobar reglas nuevas.


---

## Anexo A8. Fuente íntegra: docs/TURNO_AUTOMATICO_09.md

SHA256 del archivo fuente: `f61d96a8cd8bc347ce3e59cf08e741b9e217b22964ff520ba6d84fbc9c0031a6`. Referencia:12605fc.

# Turno automático · Preview 0.7.0

El creador validó Preview 14 y reemplazó el orden libre por: resonancia opcional del entrenador primero; habilidad del Karmany después; respuesta automática del rival. Se conserva una acción por propietario y la resonancia sigue siendo opcional. La nueva regla se aplica en feature/automatic-combat-turns desde el baseline validado 0.6.1, integrado por fast-forward.

Toda habilidad del Karmany, incluida Protección, termina la fase del jugador. El turno se cierra en el modelo y no permite una resonancia tardía, segunda habilidad o retirada durante la respuesta pendiente. Si el rival queda derrotado, se pasa directamente al Libro sin respuesta. Las cifras, recargas, progresión, probabilidades y reglas de captura no cambian.

## Resolución y persistencia

La habilidad guarda su resultado y enemy_pending antes de la respuesta. Un Timer único, hijo del autoload App, espera 0,7 segundos para que el último ataque del jugador sea legible y resuelve al rival. No hay coroutines asociadas a páginas que puedan quedar destruidas. Cambiar de pantalla no cancela la respuesta; una señal actualiza combate/mapa cuando se resuelve.

Suspender la aplicación detiene el Timer; reanudar lo programa desde el mismo estado pendiente. La identidad del encuentro y la revisión esperada evitan respuestas obsoletas, dobles toques y daño duplicado. Al confirmar la respuesta, el guardado avanza al siguiente turno o derrota. Una escritura fallida conserva el checkpoint pendiente, muestra error y ofrece Reintentar respuesta en la fila inferior; no aplica daño silenciosamente ni ejecuta un bucle de reintentos.

El esquema del perfil sigue siendo 3 con un campo compatible en el encuentro. Las partidas anteriores que ya gastaron la habilidad y esperaban cierre manual se reconocen por el historial de presupuesto y reciben una sola respuesta automática. Vida, efectos ya aplicados, árbol, colección, activo, recargas y resultados del Libro se conservan. Los encuentros en captura o terminados no programan respuesta.

SharedCombatTurn conserva su contrato genérico de presupuesto, útil para restaurar snapshots antiguos. TrialEncounter aplica el cierre al actuar el Karmany y el orden entrenador primero; combat_structure.json registra la nueva regla. Las pruebas del orden anterior en el juego se adaptan a la decisión nueva sin retirar las verificaciones de presupuesto, cooldowns, daño, guardado y captura.

## Verificación

Las pruebas de botones sin resonancias mantienen sus límites de disposición y completan ahora el combate mediante el Timer, sin un control manual. Las nuevas pruebas comprueban orden, bloqueo, Protección, pausa/reanudación, teardown de UI, errores de escritura/reintento, golpe final, recompensas únicas, migración y callback obsoleto. Las pruebas anteriores de equipo, Libro, árbol y privacidad siguen vigentes. La revisión automática mediante imágenes permanece desactivada.


---

## Anexo A9. Fuente íntegra: docs/COMBATE_TACTICO_10.md

SHA256 del archivo fuente: `a7680c1182425d4b902026a62449a519a6c097bfeeb8db18e3da9a8388dd1af5`. Referencia:12605fc.

# Combate táctico · Preview 0.8.0

Propuesta del 14 de octubre aprobada por el creador para ensayo. Validado físicamente por el creador el 14 de octubre de 2026 mediante Preview 16 e integrado por fast-forward a dev/karmany-core. Baseline: 67d006d; propuesta: d4fc1cd.

Se recuperó el trabajo local interrumpido: tres PNG con alfa real y sus prompts, catálogo experimental, motor táctico y conexiones de campaña. Se completaron interfaz, animaciones, regresiones y compilación CI. Las fichas numéricas se mantienen según PROPUESTA_COMBATE_TACTICO_10.md y data/tactical_combat.json; no se presentan como canon definitivo.

## Comportamiento

Entrenamiento abre selector de Tanugami, Ushigane, Kitsunibi o Sakuromushi. Cada rival usa su ficha, insignia y recarga; Tanugami se cura solo si faltan al menos 12 de Vida. Zephyr sigue como inicial. Capturar entrega la especie derrotada una sola vez y conserva identidades, equipo máximo de tres y progreso del árbol.

El cambio voluntario exige confirmación y consume la acción del Karmany: responde el rival contra el nuevo activo. Cada individuo conserva Vida, efectos y recargas dentro del encuentro. Si cae el activo, se guarda la elección de reemplazo; elegirlo abre el siguiente turno sin ataque extra. El equipo no se puede reorganizar durante batalla, reemplazo o captura. Al comenzar otro ensayo se recupera la Vida.

Sakuromushi solicita beneficiario vivo antes de confirmar la insignia, incluyendo reservas y sí mismo. Los efectos simultáneos se aplican tras el daño; fuentes repetidas conservan el porcentaje mayor. La colección muestra las cifras y descripción experimental de cada insignia. Velocidad permanece sin función de iniciativa.

## Persistencia y presentación

EncounterRouter mantiene encuentros schema 1 con el motor anterior, incluso sus respuestas pendientes. Solo los encuentros nuevos usan schema 2. El perfil conserva schema 3; SaveStore valida antes de escribir, conserva respaldo y publica el estado en memoria tras una escritura correcta. No se recalculan recompensas ni se agregan reservas a encuentros antiguos.

Las animaciones son transformaciones 2D del recorte completo, sin rig esquelético: carga de Ushigane, salto de Kitsunibi, embestida corta de Sakuromushi, vuelo corto de Zephyr y balanceo de Tanugami. Cada insignia tiene trayectoria o secuencia propia y efecto visual distinto: ondas, halo de recuperación, anillo de bronce, luces orbitales o partículas de apoyo. Son efectos de presentación sin reglas adicionales. Duran 0,62 s, dentro de los 0,7 s ya existentes antes de la respuesta. El nodo detiene su proceso al terminar; destruirlo no deja coroutines ni decide daño. La revisión mediante imágenes sigue desactivada.

## Verificación

Las regresiones previas de encuentro/UI usan una fixture explícita schema 1 para proteger los encuentros guardados de Preview 15, sin cambiar sus aserciones de daño ni recarga. Las nuevas pruebas tácticas cubren especies, daño, efectos por individuo, duplicados, recargas, curación, cambio, reemplazo, derrota total, captura, guardado JSON, fallo de escritura, pausa, reanudación, migración legacy y botones reales con texto normal/grande. La CI ejecuta ambos conjuntos antes de exportar un APK con el mismo paquete y firma pública de pruebas.


---

## Anexo A10. Fuente íntegra: docs/NIVELES_LIBRO_19.md

SHA256 del archivo fuente: `c994dd102835f9ba000ff48da173736020d2032a8010594806250120e4c665f8`. Referencia:12605fc.

# Bloque19 · Niveles, XP, límite regional y Libro

Aprobado por el creador14/10/2026. Parámetros en data/level_progression.json, tablas de captura aprobadas en data/book_levels.json. No se modifica la naturaleza canónica de las especies ni sus técnicas.

## Modelo y migración
level_progression.gd mantiene trainer_xp y progreso individual por instance_id. Conserva nivel del entrenador y colección; incorpora XP0 y criaturas Nv1 sin simular experiencia histórica. El perfil sigue en schema3 con campos compatibles. SaveStore valida negativos, fracciones, IDs desconocidos y XP pendiente de resolver; la normalización ocurre tras validación y antes de guardar, sin tocar el perfil visible ante fallo. JSON se escribe con máxima precisión.

25XP por victoria en localización para cada elegible del equipo y entrenador. Requisito100×nivel actual. Jade tiene tope10 por individuo; si un compañero ya está en10, el resto inferior sigue ganando. Al alcanzar el límite se consume soloXP hasta10 y se descarta excedente; el recibo informa la cantidad aplicada. Todos los miembros del equipo del encuentro cuentan, incluida una reserva derrotada; colección fuera del equipo no cuenta. Entrenamiento no daXP. No se cambia stamina ni objetos.

La transición de batalla a captura guarda XP, progreso de ruta y recompensa en una transacción. El recibo por encuentro y la fase/revisión evitan duplicación. Captura, reabrir menús y recargar no conceden otra recompensa. Nuevas capturas empiezanNv1/XP0 y no reciben la victoria que las originó.

## Estadísticas y sesiones
combat_catalog.stats_at_level escala Vida/Ataque/Defensa sobre base por1+0.05×(nivel-1), roundi; Velocidad y técnicas/recargas conservadas. Los encuentros schema2 nuevos incluyen nivel por unidad y book_id, sin nueva versión de encuentro. Validación, daño, máximo de curación, barras y lectura detallada usan esos niveles congelados. Las unidades de sesiones viejas sin nivel equivalen al nivel1/base; mejorar el progreso no las reescribe a mitad de batalla.

## Gastos compartidos y Libro
skill_tree.unlocks conserva adquisiciones permanentes; spent_points suma sus costes y rangos de resonancias. Requisitos y orden se validan, sin compras repetidas ni saldos negativos. Redistribuir limpia rangos/equipadas y conserva unlocks. Compras de Libro y redistribución normal bloqueadas en batalla/reemplazo/captura; se confirman desde UI.

Libro inicial45%; Mejora1 nivel4/1punto60%; Mejora2 nivel8/2puntos75% paraComún. Acceso y probabilidades Raro/Épico siguen su tabla aprobada, sin nuevos rivales de esas rarezas. Política se fija al iniciar encuentro; sesiones antiguas conservan45% y sus intentos/tiradas al restaurar. UI usa la probabilidad real de la captura, no una etiqueta fija.

## Regiones e interfaz
progression_rules.gd resuelve nivel, coste, desbloqueo y tope por región configurada. Jade está abierta desdeNv1 y tiene tope10. No hay siguiente región jugable configurada; su identidad y contenido necesitan aprobación. Entrenador conserva máximo actual10.

Mapa muestra nivel/XP del entrenador y tope. Equipo/Colección muestran nivel, experiencia, barra en equipo y cifras escaladas; combate y detalles usan cifras del encuentro. Resumen de victoria compacto conserva acceso a vínculo/continuar. Libro muestra equipado/adquirido/disponible/bloqueado, requisitos, puntos y confirmación de compra. Redistribución accesible fuera del laboratorio con confirmación.

## Verificación
174 comprobaciones nuevas: migración, datos inválidos, XP y topes, duplicados, bajas/reservas, equipo/colección, filas de recompensa, fallos de escritura, doble acción, compras/orden/costes, redistribución, política histórica y real45/60/75, daño/curación y simulaciones. Regresiones previas mantienen todas sus aserciones salvo recompensa antigua de entrenamiento: se actualiza a victoria conservada sin nivel/XP, según la decisión explícita del creador.


## Anexo B. Datos exactos: book_levels.json

```json
{
  "schema": 1,
  "levels": [
    {"id": "book_initial", "name": "Libro inicial", "chances": {"Común": 0.45}},
    {"id": "book_upgrade_1", "name": "Mejora 1", "chances": {"Común": 0.60, "Raro": 0.30}},
    {"id": "book_upgrade_2", "name": "Mejora 2", "chances": {"Común": 0.75, "Raro": 0.45, "Épico": 0.20}}
  ]
}
```

## Anexo B. Datos exactos: build_info.json

```json
{
  "version": "0.24.0-r1.1",
  "commit": "local",
  "build": 0,
  "stage": "R1.1 · navegación contextual y laboratorio QA"
}
```

## Anexo B. Datos exactos: combat_structure.json

```json
{
  "schema": 1,
  "team_capacity": 3,
  "active_per_side": 1,
  "stats": ["vida", "ataque", "defensa", "velocidad"],
  "skills_per_species": 3,
  "signature_skills_per_species": 1,
  "resonance_owner": "trainer",
  "shared_turn": {"karmany_actions": 1, "trainer_actions": 1, "order": "trainer_first"},
  "resonance_learning": {"general_access": "any_trainer_type", "personal_access": "type_and_personality", "provider": "skill_tree"},
  "trainer_roles": [
    {"id": "healer", "name": "Curador", "purpose": "Curar a sus Karmany", "skill_definitions": []}
  ]
}
```

## Anexo B. Datos exactos: exploration_rules.json

```json
{"schema":1,"experimental_approved":true,"stamina_max":100,"recovery_seconds":60,"entry_costs":[10,10,10,30],"recovery_item_amount":30,"drop_scale":10000,"drop_below":2000}
```

## Anexo B. Datos exactos: jade_route.json

```json
{
  "schema": 1,
  "id": "jade_trial_route",
  "experimental": true,
  "points": [
    {
      "id": "jade_point_1",
      "species": "tanugami",
      "level": 1,
      "first_xp": 400,
      "repeat_xp": 100,
      "cost": 10,
      "enemies": [
        "tanugami"
      ]
    },
    {
      "id": "jade_point_2",
      "species": "ushigane",
      "level": 3,
      "first_xp": 500,
      "repeat_xp": 125,
      "cost": 10,
      "enemies": [
        "ushigane"
      ]
    },
    {
      "id": "jade_point_3",
      "species": "kitsunibi",
      "level": 5,
      "first_xp": 600,
      "repeat_xp": 160,
      "cost": 10,
      "enemies": [
        "kitsunibi"
      ]
    },
    {
      "id": "jade_point_4",
      "species": "sakuromushi",
      "level": 7,
      "first_xp": 650,
      "repeat_xp": 200,
      "cost": 10,
      "enemies": [
        "sakuromushi"
      ]
    },
    {
      "id": "jade_point_5",
      "species": "sakuraneko",
      "level": 8,
      "first_xp": 700,
      "repeat_xp": 240,
      "cost": 10,
      "enemies": [
        "sakuraneko"
      ]
    },
    {
      "id": "jade_point_6",
      "species": "inubari",
      "level": 10,
      "first_xp": 750,
      "repeat_xp": 300,
      "cost": 30,
      "enemies": [
        "inubari",
        "ushigane"
      ]
    }
  ]
}
```

## Anexo B. Datos exactos: jade_species.json

```json
{
  "schema": 1,
  "source": {
    "filename": "Enciclopedia Oficial de Shisai- Ecosistemas y Best....pdf",
    "sha256": "039d3d63556c4de0cb2985cd452383b3e36ef7b372ea61e48ef64ae327e0f9ae",
    "section": "Sección II · Bioma 1 · entradas 1–15"
  },
  "species": [
    {
      "id": "tanugami",
      "source_entry": 1,
      "name": "Tanugami",
      "epithet": "El Mapache del Elíxir",
      "biome": "Tierras Bajas de Jade",
      "rarity": "Común",
      "biology": "Vivíparo (Mamífero)",
      "mythology": "El Tanuki (Mapache místico de la fortuna).",
      "physiology": "De cuerpo esférico cubierto de pelaje áspero marrón. Posee una protuberancia ósea en su espalda que, al madurar, adquiere la consistencia de una calabaza leñosa (hyotan), fusionada de por vida con su estructura ósea.",
      "behavior": "Manso y sociable. Utiliza sus garras delanteras para remover la tierra y buscar raíces dulces.",
      "resonance": {
        "luminous": "La calabaza secreta un aceite templado que purifica el agua contaminada y alivia las quemaduras solares de los labradores.",
        "shadow": "Su pelaje se torna gris carbón; el contenedor emite un humo denso de olor acre que genera desorientación en los intrusos."
      }
    },
    {
      "id": "sakuromushi",
      "source_entry": 2,
      "name": "Sakuromushi",
      "epithet": "El Coleóptero de los Cerezos",
      "biome": "Tierras Bajas de Jade",
      "rarity": "Común",
      "biology": "Ovíparo (Insecto)",
      "mythology": "El Kabutomushi (Escarabajo rinoceronte de la corteza).",
      "physiology": "Insecto de 50 cm. Su caparazón exterior imita con exactitud la veta y el color de la madera del cerezo centenario de Shisai. Al envejecer, desarrolla un segundo par de alas membranosas rígidas.",
      "behavior": "Se alimenta de la savia dulce. Atrae a los campos de cultivo a especies menores beneficiosas.",
      "resonance": {
        "luminous": "Emite un rítmico chirrido que estimula de forma acelerada la germinación de las semillas de lino del huerto de Ezel.",
        "shadow": "Su caparazón se eriza con púas leñosas y su canto se vuelve tan estridente que genera cefaleas en un radio de diez metros."
      }
    },
    {
      "id": "ushigane",
      "source_entry": 3,
      "name": "Ushigane",
      "epithet": "El Buey de Bronce",
      "biome": "Tierras Bajas de Jade",
      "rarity": "Común",
      "biology": "Vivíparo (Ungulado)",
      "mythology": "El Ushi-oni (Bovino sagrado de arado).",
      "physiology": "Bovino masivo cubierto de placas epidérmicas compuestas por un mineral natural que asimila el bronce pulido. Al envejecer, sus astas forman un arco plano que le ayuda a empujar carretas.",
      "behavior": "Obstinado e incansable. Mantiene una lealtad silenciosa hacia los miembros de la granja.",
      "resonance": {
        "luminous": "El bronce de su lomo adquiere un brillo dorado translúcido, actuando como escudo protector que disipa la fatiga física de su portador.",
        "shadow": "El metal de su cuerpo se cubre de óxido de cobre corrosivo; la criatura carga de forma destructiva contra cualquier obstáculo."
      }
    },
    {
      "id": "sakuraneko",
      "source_entry": 4,
      "name": "Sakuraneko",
      "epithet": "El Felino de los Pétalos",
      "biome": "Tierras Bajas de Jade",
      "rarity": "Común",
      "biology": "Vivíparo (Felino)",
      "mythology": "El Bakeneko de las flores.",
      "physiology": "Felino blanco de movimientos ágiles. Los extremos de sus orejas y su cola están formados por pétalos flexibles de queratina rosa.",
      "behavior": "Se oculta en los tejados de paja de Valle Jade; es extremadamente sensible a las discusiones familiares.",
      "resonance": {
        "luminous": "Libera un aroma a cerezos frescos que calma el pulso y reduce los espasmos de los heridos.",
        "shadow": "Los pétalos se marchitan y se vuelven rígidos como navajas de corteza, arañando a cualquiera que intente acercarse."
      }
    },
    {
      "id": "inubari",
      "source_entry": 5,
      "name": "Inubari",
      "epithet": "El Erizo de Bambú",
      "biome": "Tierras Bajas de Jade",
      "rarity": "Común",
      "biology": "Vivíparo (Roedor)",
      "mythology": "El Hari-nezumi (Erizo de las agujas).",
      "physiology": "Pequeño roedor con espinas de caña de bambú endurecidas en su lomo que crecen verticalmente al envejecer.",
      "behavior": "Habita en los campos de cultivo; recolecta fibras sueltas para confeccionar su nido bajo las raíces.",
      "resonance": {
        "luminous": "Sus espinas de bambú se vuelven flexibles y suaves, facilitando su transporte sin peligro para su dueño.",
        "shadow": "Expulsa sus agujas de caña ante ruidos fuertes, dejando el suelo sembrado de púas afiladas e infectas."
      }
    },
    {
      "id": "kitsunibi",
      "source_entry": 6,
      "name": "Kitsunibi",
      "epithet": "El Cachorro del Candil",
      "biome": "Tierras Bajas de Jade",
      "rarity": "Común",
      "biology": "Vivíparo (Cánido)",
      "mythology": "Las leyendas del Kitsunebi (Fuego de zorro).",
      "physiology": "Cachorro de zorro de pelaje crema. Su cola termina en una callosidad porosa que acumula fósforo natural.",
      "behavior": "Acompaña de noche a los niños del valle; se mimetiza con las linternas para guiar sus pasos.",
      "resonance": {
        "luminous": "Su cola enciende una flama azul templada que disipa la bruma húmeda y reconforta las articulaciones heladas.",
        "shadow": "Produce un humo aceitoso y espeso de color purpúreo que irrita los ojos y bloquea la visibilidad."
      }
    },
    {
      "id": "namazuko",
      "source_entry": 7,
      "name": "Namazuko",
      "epithet": "El Bagre del Arrozal",
      "biome": "Tierras Bajas de Jade",
      "rarity": "Común",
      "biology": "Ovíparo (Pez)",
      "mythology": "El pequeño Namazu (Bagre telúrico menor).",
      "physiology": "Pez de fango plano con largos barbillones táctiles y piel recubierta de un mucus protector denso.",
      "behavior": "Remueve constantemente el cieno profundo del arrozal para oxigenar las raíces tiernas.",
      "resonance": {
        "luminous": "Su moco cutáneo actúa como abono orgánico, purificando las impurezas del riego agrícola.",
        "shadow": "Excava galerías profundas en las bases de los canales de riego, provocando filtraciones que inundan los graneros."
      }
    },
    {
      "id": "tsuru_ori",
      "source_entry": 8,
      "name": "Tsuru-Ori",
      "epithet": "La Grulla Espantapájaros",
      "biome": "Tierras Bajas de Jade",
      "rarity": "Común",
      "biology": "Ovíparo (Ave)",
      "mythology": "Las grullas de paja de los arrozales.",
      "physiology": "Ave zancuda cuyo plumaje áspero emula un espantapájaros tradicional. Al madurar, sus patas se alargan.",
      "behavior": "Permanece inmóvil durante días en los límites del cultivo de lino, vigilando el horizonte con ojos de cuarzo natural.",
      "resonance": {
        "luminous": "Sus alas de paja filtran el viento emitiendo un silbido que ahuyenta a las plagas de insectos parásitos.",
        "shadow": "Genera graznidos sordos y erráticos que estresan al ganado del valle y marchitan los brotes más jóvenes."
      }
    },
    {
      "id": "sarutachi",
      "source_entry": 9,
      "name": "Sarutachi",
      "epithet": "El Macaco del Té",
      "biome": "Tierras Bajas de Jade",
      "rarity": "Raro",
      "biology": "Vivíparo (Primate)",
      "mythology": "El Saru (Primate protector del cultivo).",
      "physiology": "Pequeño simio con extremidades adaptadas a la escalada. Su lomo está cubierto de ramas de té vivas.",
      "behavior": "Habita en los acantilados más escarpados del valle, cosechando hojas tiernas de té silvestre con precisión quirúrgica.",
      "resonance": {
        "luminous": "Las hojas de té de su lomo adquieren propiedades curativas, curando heridas de lino al contacto directo.",
        "shadow": "Se torna territorial e irritable; roba herramientas de metal a los agricultores y sabotea los graneros."
      }
    },
    {
      "id": "shishimai",
      "source_entry": 10,
      "name": "Shishimai",
      "epithet": "El Cachorro del León",
      "biome": "Tierras Bajas de Jade",
      "rarity": "Raro",
      "biology": "Vivíparo (Félido)",
      "mythology": "El león danzante feudal Shishi.",
      "physiology": "Cachorro de melena compuesta por fibras textiles rojas y un cráneo exterior ensanchado que asimila una máscara de madera lacada.",
      "behavior": "Protege los accesos a los altares abandonados del valle, ahuyentando a los ladrones de tumbas.",
      "resonance": {
        "luminous": "Su rugido disipa las acumulaciones menores de Karma Sombrío y alivia la tensión muscular de los aliados.",
        "shadow": "Su máscara ósea se ensancha y exhala un aire gélido que adormece temporalmente los músculos de los invasores."
      }
    },
    {
      "id": "kitsune_kaze",
      "source_entry": 11,
      "name": "Kitsune-Kaze",
      "epithet": "El Zorro Tejedor",
      "biome": "Tierras Bajas de Jade",
      "rarity": "Raro",
      "biology": "Vivíparo (Cánido)",
      "mythology": "El zorro del viento (Zenko).",
      "physiology": "Zorro de pelaje largo y plateado que flota con el viento. Su cola se divide en filamentos de fibra textil brillante al madurar.",
      "behavior": "Se oculta en los talleres de hilado del pueblo; asiste secretamente a las tejedoras más ancianas.",
      "resonance": {
        "luminous": "Teje filamentos de viento y lino que forman barreras cinéticas invisibles para proteger del viento helado de la montaña.",
        "shadow": "Teje redes pegajosas de fibra oscura que se enredan en las articulaciones del rival, limitando su velocidad física."
      }
    },
    {
      "id": "kirin_chigo",
      "source_entry": 12,
      "name": "Kirin-Chigo",
      "epithet": "La Cría del Jade",
      "biome": "Tierras Bajas de Jade",
      "rarity": "Épico",
      "biology": "Vivíparo (Cérvido)",
      "mythology": "El vástago del legendario Kirin.",
      "physiology": "Pequeño ciervo cubierto de escamas de jade verde translúcido. Sus pezuñas flotan sobre el suelo sin pisarlo de manera directa.",
      "behavior": "Se manifiesta únicamente ante entrenadores dotados de una pureza de espíritu y una resolución de paz absoluta.",
      "resonance": {
        "luminous": "Su sola presencia purifica las fuentes de agua de Valle Jade y acelera la floración del cerezo sagrado del altar.",
        "shadow": "Si es forzado a la violencia, sus escamas se opacan y llora lágrimas de azufre que marchitan toda vegetación a su alrededor."
      }
    },
    {
      "id": "nezumi_koban",
      "source_entry": 13,
      "name": "Nezumi-Koban",
      "epithet": "El Ratón del Cobre",
      "biome": "Tierras Bajas de Jade",
      "rarity": "Común",
      "biology": "Vivíparo (Roedor)",
      "mythology": "El Nezumi de la suerte.",
      "physiology": "Pequeño ratón de pelaje gris metálico. Su abdomen presenta una placa ósea dura con la forma exacta de una moneda Koban de bronce.",
      "behavior": "Se alimenta de los residuos minerales de las herrerías; es sumamente astuto y silencioso.",
      "resonance": {
        "luminous": "Detecta vetas de bronce y jade puro en el subsuelo, alertando a los campesinos mediante pequeños chirridos agudos.",
        "shadow": "Se vuelve una plaga que roe el metal de las herramientas del arado, debilitándolas hasta romperlas."
      }
    },
    {
      "id": "bakeneko_chaya",
      "source_entry": 14,
      "name": "Bakeneko-Chaya",
      "epithet": "El Gato de las Tabernas",
      "biome": "Tierras Bajas de Jade",
      "rarity": "Raro",
      "biology": "Vivíparo (Felino)",
      "mythology": "El Bakeneko de las posadas de Shisai.",
      "physiology": "Felino de complexión robusta y pelaje bicolor. Al alcanzar la madurez, su cola se bifurca lateralmente de forma limpia.",
      "behavior": "Habita en los establos y cocinas de Valle Jade; resuena con los murmullos de los forasteros que descansan.",
      "resonance": {
        "luminous": "Al frotarse con las piernas del entrenador, absorbe el Karma Sombrío acumulado de sus canales mágicos.",
        "shadow": "Roba la energía de los candiles de aceite para generar pequeñas combustiones de gas inestable detrás de las puertas."
      }
    },
    {
      "id": "komainu_ishi",
      "source_entry": 15,
      "name": "Komainu-Ishi",
      "epithet": "El Cachorro de la Puerta",
      "biome": "Tierras Bajas de Jade",
      "rarity": "Raro",
      "biology": "Vivíparo (Cánido Pétreo)",
      "mythology": "Los perros guardianes de los templos (Komainu).",
      "physiology": "Cachorro de piel dura y agrietada similar al granito grisáceo de las canteras de la montaña.",
      "behavior": "Permanece sentado en las entradas de los templos de lino del valle; es impasible ante el clima adverso.",
      "resonance": {
        "luminous": "Sus grietas se llenan de musgo verde que absorbe impactos físicos pesados para proteger al entrenador.",
        "shadow": "Se torna violento y pesado, golpeando sus pezuñas de granito contra el suelo para generar pequeñas grietas en la tierra."
      }
    }
  ]
}
```

## Anexo B. Datos exactos: level_progression.json

```json
{
  "schema": 1,
  "approved": "2026-10-15",
  "victory_xp": 25,
  "xp_per_level": 100,
  "stat_step": 0.05,
  "regions": [
    {
      "id": "jade",
      "name": "Valle Jade",
      "min_level": 1,
      "cost": 0,
      "xp_cap": 10
    },
    {
      "id": "veil",
      "name": "Bosque del Velo",
      "min_level": 10,
      "cost": 1,
      "xp_cap": 15,
      "route_file": "res://data/veil_route.json"
    }
  ],
  "unlocks": [
    {
      "id": "book_upgrade_1",
      "name": "Mejora 1",
      "min_level": 4,
      "cost": 1,
      "prerequisite": ""
    },
    {
      "id": "book_upgrade_2",
      "name": "Mejora 2",
      "min_level": 8,
      "cost": 2,
      "prerequisite": "book_upgrade_1"
    }
  ]
}
```

## Anexo B. Datos exactos: tactical_combat.json

```json
{
  "status": "experimental_approved_2026_10_15",
  "baseline": "67d006dd268f95dc6351b9bc39a9ba42b54a3c2b",
  "species": {
    "zephyr": {
      "life": 80,
      "attack": 20,
      "defense": 8,
      "speed": 10,
      "signature": {
        "power": 1.5,
        "cooldown": 2
      }
    },
    "tanugami": {
      "life": 80,
      "attack": 20,
      "defense": 8,
      "speed": 10,
      "signature": {
        "heal": 12,
        "guard": 0.25,
        "cooldown": 3
      }
    },
    "ushigane": {
      "life": 96,
      "attack": 18,
      "defense": 10,
      "speed": 10,
      "signature": {
        "power": 1.25,
        "guard": 0.25,
        "cooldown": 2
      }
    },
    "kitsunibi": {
      "life": 68,
      "attack": 22,
      "defense": 6,
      "speed": 10,
      "signature": {
        "power": 1.2,
        "weaken": 0.3,
        "cooldown": 2
      }
    },
    "sakuromushi": {
      "life": 76,
      "attack": 19,
      "defense": 9,
      "speed": 10,
      "signature": {
        "power": 0.7,
        "relay_boost": 0.2,
        "relay_rounds": 2,
        "cooldown": 2
      }
    },
    "sakuraneko": {
      "life": 72,
      "attack": 20,
      "defense": 7,
      "speed": 10,
      "signature": {
        "heal": 10,
        "guard": 0.2,
        "cooldown": 3
      }
    },
    "inubari": {
      "life": 84,
      "attack": 18,
      "defense": 11,
      "speed": 10,
      "signature": {
        "power": 1.1,
        "guard": 0.3,
        "cooldown": 2
      }
    },
    "suzumeko": {
      "life": 64,
      "attack": 23,
      "defense": 5,
      "speed": 10,
      "signature": {
        "power": 1.25,
        "weaken": 0.2,
        "cooldown": 2
      }
    },
    "kodamashi": {
      "life": 84,
      "attack": 17,
      "defense": 10,
      "speed": 10,
      "signature": {
        "heal": 14,
        "guard": 0.2,
        "cooldown": 3
      }
    },
    "mujina_kage": {
      "life": 76,
      "attack": 20,
      "defense": 8,
      "speed": 10,
      "signature": {
        "power": 1.1,
        "weaken": 0.3,
        "cooldown": 2
      }
    },
    "tsukimi_usagi": {
      "life": 72,
      "attack": 18,
      "defense": 8,
      "speed": 10,
      "signature": {
        "power": 1.0,
        "grant_boost": 0.3,
        "cooldown": 2
      }
    },
    "kodama_shin": {
      "life": 80,
      "attack": 18,
      "defense": 10,
      "speed": 10,
      "signature": {
        "heal": 10,
        "guard": 0.25,
        "cooldown": 3
      }
    },
    "karasu_origami": {
      "life": 68,
      "attack": 23,
      "defense": 6,
      "speed": 10,
      "signature": {
        "power": 1.3,
        "cooldown": 2
      }
    }
  },
  "schema": 1
}
```

## Anexo B. Datos exactos: trainer_skill_tree.json

```json
{
  "schema": 1,
  "prototype": true,
  "level_cap": 15,
  "equip_slots": 4,
  "capture_milestones": [
    5,
    10,
    15
  ],
  "rank_level_step": 2,
  "rank_power_step": 0.1,
  "nodes": [
    {
      "id": "curacion",
      "name": "Curación",
      "branch": "general",
      "min_level": 1,
      "prerequisites": [],
      "max_rank": 3,
      "position": [
        0.19,
        0.25
      ],
      "description": "Rama de recuperación para tus Karmany."
    },
    {
      "id": "proteccion",
      "name": "Protección",
      "branch": "general",
      "min_level": 1,
      "prerequisites": [],
      "max_rank": 3,
      "position": [
        0.5,
        0.25
      ],
      "description": "Rama de protección del equipo."
    },
    {
      "id": "propia",
      "name": "Resonancia propia",
      "branch": "personal",
      "min_level": 1,
      "prerequisites": [],
      "max_rank": 3,
      "position": [
        0.81,
        0.25
      ],
      "description": "Ficha provisional para probar el dominio de una resonancia exclusiva. No define el poder canónico de Ezel."
    },
    {
      "id": "potenciacion",
      "name": "Potenciación",
      "branch": "general",
      "min_level": 2,
      "prerequisites": [
        "curacion"
      ],
      "max_rank": 3,
      "position": [
        0.19,
        0.75
      ],
      "description": "Rama de apoyo a las capacidades del equipo."
    },
    {
      "id": "control",
      "name": "Control",
      "branch": "general",
      "min_level": 2,
      "prerequisites": [
        "proteccion"
      ],
      "max_rank": 3,
      "position": [
        0.5,
        0.75
      ],
      "description": "Rama de interferencia sobre el rival."
    }
  ]
}
```

## Anexo B. Datos exactos: trial_combat.json

```json
{
  "schema": 1,
  "experimental": true,
  "stats": {"life": 80, "attack": 20, "defense": 8, "speed": 10},
  "actions": {
    "golpe": {"name": "Golpe", "power": 1.0, "cooldown": 0},
    "guardia": {"name": "Protección", "guard": 0.5, "cooldown": 0},
    "insignia": {"name": "Insignia", "power": 1.5, "cooldown": 2}
  },
  "resonances": {
    "curacion": {"name": "Curación", "heal": 18, "cooldown": 2},
    "proteccion": {"name": "Escudo", "guard": 0.5, "cooldown": 2},
    "potenciacion": {"name": "Potenciación", "boost": 0.25, "cooldown": 2},
    "control": {"name": "Control", "weaken": 0.3, "cooldown": 2},
    "propia": {"name": "Raíces · prueba", "weaken": 0.4, "cooldown": 3}
  }
}
```

## Anexo B. Datos exactos: veil_route.json

```json
{
  "schema": 1,
  "id": "veil_trial_route",
  "experimental": true,
  "points": [
    {
      "id": "veil_point_1",
      "species": "suzumeko",
      "level": 10,
      "first_xp": 700,
      "repeat_xp": 175,
      "cost": 10,
      "enemies": [
        "suzumeko"
      ]
    },
    {
      "id": "veil_point_2",
      "species": "kodamashi",
      "level": 11,
      "first_xp": 750,
      "repeat_xp": 210,
      "cost": 10,
      "enemies": [
        "kodamashi"
      ]
    },
    {
      "id": "veil_point_3",
      "species": "mujina_kage",
      "level": 12,
      "first_xp": 800,
      "repeat_xp": 240,
      "cost": 10,
      "enemies": [
        "mujina_kage"
      ]
    },
    {
      "id": "veil_point_4",
      "species": "tsukimi_usagi",
      "level": 13,
      "first_xp": 850,
      "repeat_xp": 260,
      "cost": 10,
      "enemies": [
        "tsukimi_usagi"
      ]
    },
    {
      "id": "veil_point_5",
      "species": "kodama_shin",
      "level": 14,
      "first_xp": 900,
      "repeat_xp": 290,
      "cost": 10,
      "enemies": [
        "kodama_shin"
      ]
    },
    {
      "id": "veil_point_6",
      "species": "karasu_origami",
      "level": 15,
      "first_xp": 950,
      "repeat_xp": 325,
      "cost": 30,
      "enemies": [
        "karasu_origami",
        "mujina_kage"
      ]
    }
  ]
}
```

## Anexo B. Datos exactos: veil_species.json

```json
{
  "schema": 1,
  "source": {
    "filename": "Enciclopedia Oficial de Shisai- Ecosistemas y Best....pdf"
  },
  "species": [
    {
      "id": "suzumeko",
      "name": "Suzumeko",
      "epithet": "El Gorrión de Papel",
      "biome": "Bosque del Velo",
      "rarity": "Común",
      "biology": "Ovíparo (Ave)",
      "mythology": "El mito de la grulla/gorrión de origami (Orizuru menor).",
      "physiology": "Gorrión con plumaje de fibras entrelazadas que emula al papel pergamino doblado con patrones geométricos rígidos.",
      "behavior": "Curioso y activo. Se asienta en los troncos de los cerezos perennes para escuchar los susurros de los viajeros.",
      "resonance": {
        "luminous": "Al batir las alas, dispersa esporas luminosas que revelan la posición de enemigos o trampas ocultas en la densa niebla.",
        "shadow": "Sus plumas se vuelven de color ceniza y ejecutan ataques de papel afilado que causan pequeños pero dolorosos cortes en el rival."
      },
      "source_page": 8,
      "source_entry": 17
    },
    {
      "id": "kodamashi",
      "name": "Kodamashi",
      "epithet": "El Reptil de Musgo",
      "biome": "Bosque del Velo",
      "rarity": "Común",
      "biology": "Ovíparo (Lagarto)",
      "mythology": "Los espíritus del musgo y la vegetación (Kodama).",
      "physiology": "Lagarto pequeño de piel cubierta de musgo denso y líquenes que cambian de color según la humedad.",
      "behavior": "Se mimetiza con las rocas y raíces húmedas; es un excelente indicador de la salud del bosque de cerezos.",
      "resonance": {
        "luminous": "El musgo de su cuerpo florece, desprendiendo un polen curativo que acelera la regeneración de la piel del entrenador.",
        "shadow": "El musgo se marchita en un fango negro que exhala un olor pestilente, reduciendo la agilidad de los enemigos cercanos."
      },
      "source_page": 9,
      "source_entry": 19
    },
    {
      "id": "mujina_kage",
      "name": "Mujina-Kage",
      "epithet": "El Tejón de Vapor",
      "biome": "Bosque del Velo",
      "rarity": "Común",
      "biology": "Vivíparo (Tejón)",
      "mythology": "El tejón ilusionista de la niebla (Mujina).",
      "physiology": "Tejón de pelaje gris cenizo denso. Al madurar, su piel exuda un vapor constante que desdibuja su silueta física.",
      "behavior": "Cavador experto que habita en los sistemas de raíces del bambú; es sumamente tímido ante la presencia humana.",
      "resonance": {
        "luminous": "El vapor que genera limpia las vías respiratorias de su portador del aire viciado de azufre de la montaña.",
        "shadow": "Se funde por completo con la niebla, permitiéndole atacar por sorpresa y drenar la estamina de su objetivo."
      },
      "source_page": 9,
      "source_entry": 20
    },
    {
      "id": "tsukimi_usagi",
      "name": "Tsukimi-Usagi",
      "epithet": "El Conejo de la Luna",
      "biome": "Bosque del Velo",
      "rarity": "Común",
      "biology": "Vivíparo (Lagomorfo)",
      "mythology": "El conejo lunar de las leyendas del bambú (Tsuki).",
      "physiology": "Conejo blanco de orejas desproporcionadamente largas y delgadas que captan las fluctuaciones kármicas del aire.",
      "behavior": "Se alimenta del rocío condensado en los pétalos de los cerezos sagrados durante las noches despejadas.",
      "resonance": {
        "luminous": "Sus orejas brillan con una luz plateada pura que revela la ubicación de los flujos de Karma más estables del bioma.",
        "shadow": "Sus ojos refulgen en un amarillo sulfúrico y emite un chillido que perturba e interrumpe la canalización de los Libros."
      },
      "source_page": 9,
      "source_entry": 21
    },
    {
      "id": "kodama_shin",
      "name": "Kodama-Shin",
      "epithet": "El Espíritu Crujiente",
      "biome": "Bosque del Velo",
      "rarity": "Común",
      "biology": "Vivíparo (Espíritu de Madera)",
      "mythology": "Los duendes del bambú (Kodama menores).",
      "physiology": "Pequeña criatura humanoide hecha de fibras vegetales y una máscara ósea redonda que simula un nudo de madera seca.",
      "behavior": "Se oculta dentro de las cañas de bambú huecas; produce pequeños crujidos para alertar de la presencia de intrusos.",
      "resonance": {
        "luminous": "Su presencia aumenta de forma pasiva la velocidad de ejecución de la cloromancia de su entrenador.",
        "shadow": "Produce sonidos desorientadores que causan interferencia en la percepción espacial del rival."
      },
      "source_page": 11,
      "source_entry": 28
    },
    {
      "id": "karasu_origami",
      "name": "Karasu-Origami",
      "epithet": "El Cuervo de Luto",
      "biome": "Bosque del Velo",
      "rarity": "Común",
      "biology": "Ovíparo (Ave)",
      "mythology": "Los cuervos de papel ceremoniales.",
      "physiology": "Cuervo de plumaje rígido y negro que imita los pliegues del papel doblado con bordes filosos.",
      "behavior": "Se asienta en las ramas altas de los cerezos para vigilar el avance de los forasteros por el sendero antiguo.",
      "resonance": {
        "luminous": "Transporta rápidamente pergaminos de curación menor entre aliados distantes del grupo.",
        "shadow": "Lanza plumas de papel rígido que causan micro-cortes dolorosos y debilitan la resistencia kármica del rival."
      },
      "source_page": 10,
      "source_entry": 22
    }
  ]
}
```

## Anexo C. Operación y evidencia: .github/workflows/android-preview.yml

````text
name: Android Preview

on:
  pull_request:
    branches: [main, dev/karmany-core]
  workflow_dispatch:
    inputs:
      ui_review:
        description: "Autorizar imágenes de revisión de interfaz en el servidor"
        type: boolean
        default: false
        required: false

permissions:
  contents: read

concurrency:
  group: android-preview-${{ github.head_ref || github.ref }}
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-24.04
    timeout-minutes: 30
    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ github.event.pull_request.head.sha || github.sha }}
      - uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: '17'
      - name: Install exact Godot and Android templates
        run: python3 ci/install_godot.py
      - name: Prepare Android SDK
        run: |
          "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" "platform-tools" "build-tools;35.0.1" "platforms;android-35"
          "$ANDROID_HOME/platform-tools/adb" start-server
      - name: Prepare preview metadata and test signing
        env:
          BUILD_COMMIT: ${{ github.event.pull_request.head.sha || github.sha }}
        run: python3 ci/prepare_android.py
      - name: Import and verify scripts
        run: |
          set -o pipefail
          godot --headless --editor --path . --import --quit 2>&1 | tee build/import.log
          python3 ci/check_log.py build/import.log
      - name: Run regression tests
        run: |
          set -o pipefail
          godot --headless --path . --script tests/run_tests.gd 2>&1 | tee build/tests.log
          python3 ci/check_log.py build/tests.log
      - name: Validate canonical catalog and capture contracts
        # Canonical content and approved capture limits have independent regressions.
        # Book probabilities are approved; trainer skill effects remain undefined.
        if: success()
        run: |
          set -o pipefail
          godot --headless --path . --script tests/catalog_capture_tests.gd 2>&1 | tee build/catalog-capture.log
          python3 ci/check_log.py build/catalog-capture.log
      - name: Validate approved book and trainer structure
        run: |
          set -o pipefail
          godot --headless --path . --script tests/book_trainer_rules_tests.gd 2>&1 | tee build/book-trainer.log
          python3 ci/check_log.py build/book-trainer.log
      - name: Validate shared turn and resonance learning
        run: |
          set -o pipefail
          godot --headless --path . --script tests/shared_turn_learning_tests.gd 2>&1 | tee build/turn-learning.log
          python3 ci/check_log.py build/turn-learning.log
      - name: Validate functional skill tree and save migration
        run: |
          set -o pipefail
          godot --headless --path . --script tests/skill_tree_tests.gd 2>&1 | tee build/skill-tree.log
          python3 ci/check_log.py build/skill-tree.log
      - name: Validate playable encounter and touch
        run: |
          set -o pipefail
          godot --headless --path . --script tests/playable_tests.gd 2>&1 | tee build/playable.log
          python3 ci/check_log.py build/playable.log
      - name: Validate R1 navigation identity and prologue
        run: |
          set -o pipefail
          godot --headless --path . --script tests/r1_tests.gd 2>&1 | tee build/r1.log
          python3 ci/check_log.py build/r1.log
          xvfb-run -a godot --rendering-method gl_compatibility --audio-driver Dummy --path . --script tests/r1_tests.gd -- --allow-ui-review 2>&1 | tee build/r1-render.log
          python3 ci/check_log.py build/r1-render.log
      - name: Validate R1.1 contextual navigation and isolated QA
        run: |
          set -o pipefail
          godot --headless --path . --script tests/r11_tests.gd 2>&1 | tee build/r11.log
          python3 ci/check_log.py build/r11.log
          xvfb-run -a godot --rendering-method gl_compatibility --audio-driver Dummy --path . --script tests/r11_ui_tests.gd 2>&1 | tee build/r11-ui.log
          python3 ci/check_log.py build/r11-ui.log
      - name: Validate latest action display
        run: |
          set -o pipefail
          godot --headless --path . --script tests/last_action_tests.gd 2>&1 | tee build/last-action.log
          python3 ci/check_log.py build/last-action.log
      - name: Validate collection and team loadout
        run: |
          set -o pipefail
          godot --headless --path . --script tests/roster_tests.gd 2>&1 | tee build/roster.log
          python3 ci/check_log.py build/roster.log
      - name: Validate battle continuation without resonances
        run: |
          set -o pipefail
          godot --headless --path . --script tests/no_resonance_flow_tests.gd 2>&1 | tee build/no-resonance.log
          python3 ci/check_log.py build/no-resonance.log
          python3 -m unittest discover -s tests -p test_apk_privacy.py
      - name: Validate automatic trainer-first turns
        run: |
          set -o pipefail
          godot --headless --path . --script tests/automatic_turn_tests.gd 2>&1 | tee build/automatic-turn.log
          python3 ci/check_log.py build/automatic-turn.log
      - name: Validate tactical combat, replacement and legacy migration
        run: |
          set -o pipefail
          godot --headless --path . --script tests/tactical_tests.gd 2>&1 | tee build/tactical.log
          python3 ci/check_log.py build/tactical.log
      - name: Validate read-only combat details and mobile layout
        run: |
          set -o pipefail
          godot --headless --path . --script tests/combat_readout_tests.gd 2>&1 | tee build/combat-readout.log
          python3 ci/check_log.py build/combat-readout.log
      - name: Validate guided Jade route and migration
        run: |
          set -o pipefail
          godot --headless --path . --script tests/jade_route_tests.gd 2>&1 | tee build/jade-route.log
          python3 ci/check_log.py build/jade-route.log
      - name: Validate exploration, stamina, rewards and compact combat UI
        run: |
          set -o pipefail
          godot --headless --path . --script tests/exploration_energy_tests.gd 2>&1 | tee build/exploration-energy.log
          python3 ci/check_log.py build/exploration-energy.log
      - name: Validate combat animation boundaries
        run: |
          set -o pipefail
          godot --headless --path . --script tests/combat_animation_tests.gd 2>&1 | tee build/combat-animation.log
          python3 ci/check_log.py build/combat-animation.log
      - name: Validate binding animation and capture transactions
        run: |
          set -o pipefail
          godot --headless --path . --script tests/binding_animation_tests.gd 2>&1 | tee build/binding-animation.log
          python3 ci/check_log.py build/binding-animation.log
      - name: Validate sound cues, audio settings and save migration
        run: |
          set -o pipefail
          godot --headless --path . --script tests/sound_effect_tests.gd 2>&1 | tee build/sound-effects.log
          python3 ci/check_log.py build/sound-effects.log
      - name: Validate reduced motion and preference migration
        run: |
          set -o pipefail
          godot --headless --path . --script tests/reduced_motion_tests.gd 2>&1 | tee build/reduced-motion.log
          python3 ci/check_log.py build/reduced-motion.log
      - name: Validate levels, regional XP, books and shared skill points
        run: |
          set -o pipefail
          godot --headless --path . --script tests/level_progression_tests.gd 2>&1 | tee build/level-progression.log
          python3 ci/check_log.py build/level-progression.log
      - name: Validate XP summary, level-up bars and stat changes
        run: |
          set -o pipefail
          godot --headless --path . --script tests/experience_summary_tests.gd 2>&1 | tee build/experience-summary.log
          python3 ci/check_log.py build/experience-summary.log
      - name: Validate frozen regional contracts, relays and unique rewards
        run: |
          set -o pipefail
          godot --headless --path . --script tests/regional_engine_tests.gd 2>&1 | tee build/regional-engine.log
          python3 ci/check_log.py build/regional-engine.log
      - name: Validate twelve-point convergence and Preview32 migrations
        run: |
          set -o pipefail
          godot --headless --path . --script tests/unification_tests.gd 2>&1 | tee build/unification.log
          python3 ci/check_log.py build/unification.log
          godot --headless --path . --script tests/e2_source_compatibility_tests.gd 2>&1 | tee build/e2-source-compatibility.log
          python3 ci/check_log.py build/e2-source-compatibility.log
      - name: Validate regional balance and full-screen UI
        run: |
          set -o pipefail
          godot --headless --path . --script tests/regional_balance_tests.gd 2>&1 | tee build/regional-balance.log
          python3 ci/check_log.py build/regional-balance.log
          godot --headless --path . --script tests/unification_ui_tests.gd 2>&1 | tee build/unification-ui.log
          python3 ci/check_log.py build/unification-ui.log
          if ! command -v xvfb-run >/dev/null; then sudo apt-get update -qq && sudo apt-get install -y xvfb; fi
          xvfb-run -a godot --rendering-method gl_compatibility --audio-driver Dummy --path . --script tests/unification_ui_tests.gd -- --allow-ui-review 2>&1 | tee build/unification-render.log
          python3 ci/check_log.py build/unification-render.log
      - name: Validate E5 first session and contextual help
        run: |
          set -o pipefail
          godot --headless --path . --script tests/first_session_tests.gd 2>&1 | tee build/first-session.log
          python3 ci/check_log.py build/first-session.log
          xvfb-run -a godot --rendering-method gl_compatibility --audio-driver Dummy --path . --script tests/first_session_tests.gd -- --allow-ui-review 2>&1 | tee build/first-session-render.log
          python3 ci/check_log.py build/first-session-render.log
          godot --headless --path . --script tests/help_persistence_tests.gd 2>&1 | tee build/help-persistence.log
          python3 ci/check_log.py build/help-persistence.log
          xvfb-run -a godot --rendering-method gl_compatibility --audio-driver Dummy --path . --script tests/help_persistence_tests.gd -- --allow-ui-review 2>&1 | tee build/help-persistence-render.log
          python3 ci/check_log.py build/help-persistence-render.log
      - name: Export playable encounter APK
        run: |
          set -o pipefail
          godot --headless --path . --script tests/location_presentation_tests.gd 2>&1 | tee build/location-presentation.log
          python3 ci/check_log.py build/location-presentation.log
          godot --headless --path . --export-debug "Android Preview" build/karmany-monsta-preview.apk 2>&1 | tee build/export.log
          python3 ci/check_log.py build/export.log
          test -s build/karmany-monsta-preview.apk
          "$ANDROID_HOME/build-tools/35.0.1/apksigner" verify --verbose build/karmany-monsta-preview.apk
          python3 ci/check_apk_privacy.py build/karmany-monsta-preview.apk
          sha256sum build/karmany-monsta-preview.apk > build/apk.sha256
      - name: Render UI for review
        if: github.event_name == 'workflow_dispatch' && inputs.ui_review == true
        run: |
          set -o pipefail
          if ! command -v xvfb-run >/dev/null; then sudo apt-get update -qq && sudo apt-get install -y xvfb; fi
          xvfb-run -a godot --audio-driver Dummy --path . --script tests/render_smoke.gd -- --allow-ui-review 2>&1 | tee build/ui.log
          python3 ci/check_log.py build/ui.log
          python3 -m zipfile -c build/ui-review.zip build/screenshots
      - name: Upload APK and diagnostic logs
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: karmany-android-preview-${{ github.run_number }}
          path: build/
          retention-days: 14
          if-no-files-found: error

  preview-download:
    needs: build
    if: github.event_name == 'workflow_dispatch' || github.event.pull_request.head.repo.full_name == github.repository
    runs-on: ubuntu-24.04
    permissions:
      contents: write
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: karmany-android-preview-${{ github.run_number }}
          path: build
      - name: Publish downloadable test APK
        env:
          GH_TOKEN: ${{ github.token }}
          GH_REPO: ${{ github.repository }}
          BUILD_COMMIT: ${{ github.event.pull_request.head.sha || github.sha }}
          BUILD_NUMBER: ${{ github.run_number }}
        run: |
          TAG="android-preview-${BUILD_NUMBER}"
          ASSETS=(build/karmany-monsta-preview.apk build/apk.sha256)
          if test -f build/ui-review.zip; then ASSETS+=(build/ui-review.zip); fi
          if gh release view "$TAG" >/dev/null 2>&1; then
            gh release upload "$TAG" "${ASSETS[@]}" --clobber
          else
            gh release create "$TAG" "${ASSETS[@]}" --target "$BUILD_COMMIT" --prerelease --title "Android Preview ${BUILD_NUMBER}" --notes "Candidata R1.1 0.24.0: navegación Atrás contextual y laboratorio QA aislado. Guardados compatibles y regresiones completas. Pendiente prueba física; no integrada a dev."
          fi
````

## Anexo C. Operación y evidencia: ci/README.md

````text
# Compilación reproducible de preview

Motor fijado: Godot 4.7.2, GDScript y Compatibility. Java 17. Exportación Android mediante plantillas oficiales precompiladas; APK ARM64 para la primera prueba en POCO X6.

El workflow se ejecuta al crear/actualizar una PR hacia main o dev/karmany-core, y manualmente con workflow_dispatch. Descarga engine y plantillas, verifica SHA-512 oficial, configura SDK, importa, ejecuta tests, exporta y verifica firma. Conserva artefactos y publica una prerelease de prueba descargable para PR de este mismo repositorio.

## Firma de pruebas

`preview.keystore.b64` es intencionalmente una clave PÚBLICA DE PRUEBAS. Contraseña estándar `android`; alias `androiddebugkey`. Mantiene la firma entre builds de preview para poder actualizar sin desinstalar. No identifica al editor ni protege una distribución comercial. Nunca utilizar esta clave ni el paquete `.preview` para Google Play, pagos o datos sensibles. La distribución comercial usará un paquete y una firma protegida independientes.

Las claves comerciales, contraseñas privadas y credenciales no se guardan en este repositorio público.

## Versiones

Cada ejecución usa versionCode = 1000 + GITHUB_RUN_NUMBER. Reintentar una ejecución mantiene la misma versión; una nueva ejecución incrementa el código. Diagnóstico incluye SHA exacto de la rama de trabajo, no el merge sintético de la PR.

`main` permanece con la inicialización. No crear un baseline jugable validado en `dev/karmany-core` hasta la aprobación física del bloque.
````

## Anexo C. Operación y evidencia: docs/R1_1_CANDIDATA_VERIFICACION.json

````text
{
  "preview": 45,
  "url": "https://github.com/axenoban/karmany-monsta-android/releases/download/android-preview-45/karmany-monsta-preview.apk",
  "sha256": "701108382045758c013bb5ed5cceaddeae4e5f5970822770fb704b3c5242ef08",
  "apk_size": 83404111,
  "manifest": {
    "versionCode": 1045,
    "versionName": "0.24.0-r1.1",
    "installLocation": 0,
    "compileSdkVersion": 36,
    "compileSdkVersionCodename": "16",
    "package": "com.axenoban.karmanymonsta.preview",
    "platformBuildVersionCode": 36,
    "platformBuildVersionName": 16
  },
  "certificate_sha256": "756c8c1a8136ae2e80987c540d805641d7bfd2d5b657d1f04584f0074ac61bf8",
  "build_info": {
    "version": "0.24.0-r1.1",
    "commit": "636565422baa63dd4cc0f5026e55361ccd8f4fe1",
    "build": 45,
    "stage": "R1.1 · navegación contextual y laboratorio QA"
  },
  "unchanged_game_data": [
    "assets/data/tactical_combat.json",
    "assets/data/level_progression.json",
    "assets/data/combat_structure.json",
    "assets/data/jade_route.json",
    "assets/data/book_levels.json",
    "assets/data/veil_route.json",
    "assets/data/veil_species.json",
    "assets/data/jade_species.json",
    "assets/data/trainer_skill_tree.json",
    "assets/data/exploration_rules.json",
    "assets/data/trial_combat.json"
  ],
  "unchanged_art_audio_count": 122,
  "changed_scripts_from_42": [
    "assets/scripts/app.gdc",
    "assets/scripts/trial_ui.gdc",
    "assets/scripts/main.gdc"
  ],
  "added_scripts": [
    "assets/scripts/qa_lab.gdc",
    "assets/scripts/qa_store.gdc",
    "assets/scripts/qa_profile.gdc",
    "assets/scripts/navigation_history.gdc"
  ],
  "verified_date": "2026-10-17",
  "ci_run": 38955362578,
  "ci_conclusion": "success",
  "godot_suites": 31,
  "godot_checks": 5857,
  "python_tests": 3,
  "signature_schemes_verified_by_ci": [
    "v2",
    "v3"
  ],
  "physical_approval": false
}
````

## Índice de fuentes adicionales conservadas en el repositorio

- `docs/ARBOL_RESONANCIAS_05.md`
- `docs/AUDITORIA_DOS_LINEAS_2026-10-15.md`
- `docs/BASELINE_VALIDADO.md`
- `docs/BASE_DESARROLLO.md`
- `docs/CLARIDAD_COMBATE_11.md`
- `docs/COMBATE_PROPUESTA_01.md`
- `docs/COMBATE_TACTICO_10.md`
- `docs/CONTINUIDAD.md`
- `docs/CORRECCION_SIN_RESONANCIAS_08.md`
- `docs/CORRECCION_ULTIMA_ACCION.md`
- `docs/DECISIONES_ENTRENADORES_03.md`
- `docs/E1_JADE_RELEVO_2026-10-15.md`
- `docs/E2_MOTOR_REGIONAL.md`
- `docs/E5_CANDIDATA_39_VERIFICACION.json`
- `docs/E5_CANDIDATA_40_VERIFICACION.json`
- `docs/E5_IMPLEMENTACION.md`
- `docs/E5_PRIMERA_SESION.md`
- `docs/ENCUENTRO_JUGABLE_06.md`
- `docs/EQUIPO_JUGABLE_07.md`
- `docs/EXPLORACION_STAMINA_UI_13.md`
- `docs/LOCALIZACIONES_ARTE_14.md`
- `docs/NIVELES_LIBRO_19.md`
- `docs/PROPUESTA_COMBATE_TACTICO_10.md`
- `docs/PROPUESTA_LIBRO_19.md`
- `docs/PROPUESTA_PROGRESION_19.md`
- `docs/PROPUESTA_RECORRIDO_JADE_12.md`
- `docs/PROPUESTA_REGION_21.md`
- `docs/PRUEBA_ANDROID_01.md`
- `docs/PRUEBA_ANDROID_02.md`
- `docs/PRUEBA_ANDROID_03.md`
- `docs/PRUEBA_ANDROID_04.md`
- `docs/PRUEBA_ANDROID_05.md`
- `docs/PRUEBA_ANDROID_06.md`
- `docs/PRUEBA_ANDROID_07.md`
- `docs/PRUEBA_ANDROID_10.md`
- `docs/PRUEBA_ANDROID_11.md`
- `docs/PRUEBA_ANDROID_12.md`
- `docs/PRUEBA_ANDROID_13.md`
- `docs/PRUEBA_ANDROID_14.md`
- `docs/PRUEBA_ANDROID_15.md`
- `docs/PRUEBA_ANDROID_16.md`
- `docs/PRUEBA_ANDROID_17.md`
- `docs/PRUEBA_ANDROID_18.md`
- `docs/PRUEBA_ANDROID_19.md`
- `docs/PRUEBA_ANDROID_20.md`
- `docs/R1_1_CANDIDATA_VERIFICACION.json`
- `docs/R1_1_IMPLEMENTACION.md`
- `docs/R1_1_NAVEGACION_LABORATORIO_QA.md`
- `docs/R1_CANDIDATA_42_VERIFICACION.json`
- `docs/R1_IMPLEMENTACION.md`
- `docs/R1_NAVEGACION_IDENTIDAD.md`
- `docs/RECORRIDO_JADE_12.md`
- `docs/ROADMAP_CHAT_WORK.md`
- `docs/ROADMAP_ESTADO.md`
- `docs/TURNO_APRENDIZAJE_04.md`
- `docs/TURNO_AUTOMATICO_09.md`
- `docs/UNIFICACION_JADE_BOSQUE.md`
- `docs/proposals/COMBAT_10_SCREENING.md`
- `docs/proposals/combat_10.json`
- `docs/proposals/simulate_combat_10.py`
- `docs/recovery/CANDIDATA_38_VERIFICACION.json`
- `docs/recovery/E2_incremental.bundle`
- `docs/recovery/Preview32_editable_scripts.zip`
- `docs/recovery/certificates.json`

## Cierre documental

HECHO: consolidación de producto, especificaciones, datos, arquitectura, estado y recuperación; sin modificación de gameplay.
SIGUIENTE PASO: revisar la concordancia documental y conciliar el cierre pendiente de R1.1 con la aprobación física existente.
RESPONSABLE: CHAT.
INSTRUCCIÓN PARA CONTINUAR: Revisa DOCUMENTO_MAESTRO_ANDROID.md en axenoban/karmany-monsta-android, contrasta PR21/Preview45 y la confirmación física recuperada. Señala discrepancias antes de que Work prepare integración. No inicies nuevas etapas ni importes reglas de otros proyectos.
