# Continuidad de Karmany Monsta

## Estado vigente · cierre aprobado de R0 (15/10/2026, America/La_Paz)

La **Preview 38 / v0.21.0-unification**, código `f0266badaa7851da3de2bcc08a65752b6409360b`, ha sido **probada físicamente y aprobada por el creador**: «Confirmo que probé físicamente la Preview 38 (v0.21.0-unification) y la considero correcta y aceptable. Apruebo esta versión».

Referencia adicional: [validación registrada por Chat en PR #18](https://github.com/axenoban/karmany-monsta-android/pull/18#issuecomment-6204818029). Es aprobación general de la versión; no se atribuyen pruebas específicas no detalladas por el usuario.

- **Unificación completada y aprobada.** Valle Jade y Bosque del Velo (6 + 6 etapas), contenido recuperado de Preview32 y mejoras E1/E2 constituyen el baseline estable.
- **Integración autorizada:** fast-forward de `dev/karmany-core` desde `2ea590cff0b0e1cb1c6b33318bf156901efb681e` al commit documental de este cierre, descendiente de `892a109e8db48f25c30d81fa3c74aefdf0d7d414`. El SHA exacto de cierre es el commit que contiene esta sección y debe comprobarse en GitHub.
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
