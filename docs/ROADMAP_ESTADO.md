# ESTADO VIVO · Roadmap de Karmany Monsta (Chat + Work)

**Control de planificación:** 2026-10-15, zona America/La_Paz. **Versión del estado:** 1.0.  
**Regla:** este archivo es el tablero operativo que ambos agentes deben consultar y actualizar. La planificación completa y los prompts están en [ROADMAP_CHAT_WORK.md](ROADMAP_CHAT_WORK.md). El historial técnico está en [CONTINUIDAD.md](CONTINUIDAD.md). Se debe comprobar el GitHub real antes de confiar en cualquier SHA anotado.

## 0. ALERTA DE NO REGRESIÓN (actualizada tras auditoría de dos líneas)

**PRIORIDAD MÁXIMA — fase R0 «RECUPERACIÓN / CONVERGENCIA»**, por encima de continuar E1/E2/E3 sin unificar. [Auditoría y plan de integración](AUDITORIA_DOS_LINEAS_2026-10-15.md).

Se ha recuperado la **Preview32 v0.20.0** de otra línea local, con **Valle Jade 6 etapas + Bosque del Velo 6 etapas**, ocho criaturas adicionales, doce recursos CTEX regionales y pantallas de derrota/transición. El código fuente editable de Preview32 **no está en GitHub**; solo la APK (GDScript compilado) y sus datos/arte empaquetados. La rama GitHub E1/Preview34 solo tiene cuatro etapas de Jade. **Esto es una divergencia real, no una zona simplemente oculta**.

También existe **E2 ejecutada localmente por Work**: commit `42fed0ce330366de891ad7944e50e6d79f5836d8`, rama local `feature/e2-regional-engine`, APK E2 Preview35 v0.19.0, resultados locales correctos. No se subió a GitHub; está preservada en Library como `Karmany_Monsta_E2_Fuente_y_Pruebas.zip` con `E2_incremental.bundle`. **No confundir** con el release público `android-preview-35`, que es otro artefacto.

**DUEÑO DE ESCRITURA AUTORIZADO POR EL CREADOR:** Work para recuperar E2 y reconstruir la convergencia en rama `feature/unificacion-jade-bosque`. **Chat:** auditoría/QA/documentación y lectura. En esta etapa de decisión no se autoriza a ningún agente a sobrescribir `dev/karmany-core`, `main` o perder los avances de Preview32. No comenzar nuevas funciones hasta restaurar las dos regiones y migraciones.

**Portón de salida del rescate:** fuente de E2 subida a rama feature, inventario de lo recuperable de Preview32, 12 etapas y 2 regiones reconstruidas y regresiones/migraciones probadas. APK candidata revisada por el creador antes de integrar. El progreso anterior de Preview32 requiere migración específica.

## 1. Estado confirmado al crear este tablero

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

### Última observación del creador — **no dar E1 por validada**
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

## 2. Etapas, responsable y condición de salida

| Etapa | Estado | Dueño de análisis | Dueño de implementación | Paso de salida |
|---|---|---|---|---|
| E0 · Coordinación y roadmap | **Implementado como documentación** | Chat | No aplica | Mantener docs y responsabilidades actualizadas |
| E1 · Reglas Jade y relevo de prueba | **Reglas aceptadas; prototipo CI verde; prueba Android pendiente** | Chat | **Chat (rama E1)** | Verificar en Android, corregir si procede y aprobación explícita |
| E2 · Motor regional | **Recuperado y publicado en feature/e2-regional-engine-recovered; integrado en candidata** | Chat audita archivos de rescate | Work recupera `E2_incremental.bundle` | Rama recuperada + CI GitHub + prueba física antes de integración |
| E3 · Jade de seis etapas | **En espera** | Chat: canon, assets y QA | Work (Sol Medio) | Campaña corta completa en Android |
| E4 · Continuidad de batalla/vínculo | **En espera** | Chat: UX/criterios | Work (Sol Medio) | Un fondo continuo, controles compactos, transiciones |
| E5 · Primera partida autónoma | **En espera** | Chat: microtutorial | Work (Sol Medio) | Tester navega sin ayuda |
| E6 · Alfa y playtest | **En espera** | Chat: QA, 5–10 testers | Work: corrección de P0/P1 | APK alfa con recorrido Jade testeado |
| E7 · Bosque del Velo | **Contenido anterior existente en Preview32; RESCATE prioritario** | Chat compara catálogo y reglas | Work reconstruye código/arte de Preview32 en convergencia | Recuperar sus 6 etapas sin perder funcionalidades |
| E8 · Profundidad y pulido | **Después de feedback** | Chat: priorizar | Work | Mejoras justificadas y probadas |
| E9 · Beta | **En espera** | Chat: pruebas extendidas | Work | Beta estable |
| E10 · Publicación | **En espera, sujeto a autorización** | Chat: requisitos/editorial | Work | Go/no-go y release aprobado |

**Prioridad vigente actualizada:** R0 rescate Preview32 + fuente Work E2 → rama de convergencia → 2 regiones/12 etapas + relevo E1 + motor E2 + UX → validar APK con partidas antiguas → retomar roadmap alfa. No desarrollar contenido adicional hasta lograr paridad con Preview32.

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

## 5. Registro cronológico mínimo

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
