# ESTADO VIVO · Roadmap de Karmany Monsta (Chat + Work)

**Control de planificación:** 2026-10-15, zona America/La_Paz. **Versión del estado:** 1.0.  
**Regla:** este archivo es el tablero operativo que ambos agentes deben consultar y actualizar. La planificación completa y los prompts están en [ROADMAP_CHAT_WORK.md](ROADMAP_CHAT_WORK.md). El historial técnico está en [CONTINUIDAD.md](CONTINUIDAD.md). Se debe comprobar el GitHub real antes de confiar en cualquier SHA anotado.

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
| **Fase de implementación actual** | **E1: ensayo de Insignia con relevo, esperando verificación física** |
| **Dueño del código activo** | **Chat en `feature/e1-jade-relay` hasta cierre/traspaso explícito** |
| **Área permitida a Work ahora** | Leer/auditar y preparar criterios de E2 **sin editar** los scripts E1 |
| **Siguiente objetivo habilitado** | Validar o corregir E1; **E2 aún NO está autorizado para escritura simultánea** |

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
| E2 · Motor regional | **En espera / no iniciado** | Chat prepara pruebas sin tocar E1 | **Work (Sol Medio)** cuando libre | CI + migración y final por relevos probados |
| E3 · Jade de seis etapas | **En espera** | Chat: canon, assets y QA | Work (Sol Medio) | Campaña corta completa en Android |
| E4 · Continuidad de batalla/vínculo | **En espera** | Chat: UX/criterios | Work (Sol Medio) | Un fondo continuo, controles compactos, transiciones |
| E5 · Primera partida autónoma | **En espera** | Chat: microtutorial | Work (Sol Medio) | Tester navega sin ayuda |
| E6 · Alfa y playtest | **En espera** | Chat: QA, 5–10 testers | Work: corrección de P0/P1 | APK alfa con recorrido Jade testeado |
| E7 · Bosque del Velo | **Después de alfa** | Chat: balance/canon | Work | Segunda región con nivel 10–15 aprobado |
| E8 · Profundidad y pulido | **Después de feedback** | Chat: priorizar | Work | Mejoras justificadas y probadas |
| E9 · Beta | **En espera** | Chat: pruebas extendidas | Work | Beta estable |
| E10 · Publicación | **En espera, sujeto a autorización** | Chat: requisitos/editorial | Work | Go/no-go y release aprobado |

**Prioridad vigente:** terminar E1 y pasar a E2 → E3 → E4 → E5 → E6. **No trabajar simultáneamente en Bosque, tienda, multijugador o publicación.**

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

**Próxima acción concreta:** **Chat** debe resolver la observación de E1 contra APK34 y comprobar qué Karmany estaba activo, si se ejecutó Insignia de Sakuromushi y si el cambio persiste visualmente. Si se reproduce un defecto, corregirlo en la única rama E1; si se confirma prueba correcta, cerrar/validar E1 e iniciar Work E2. No comenzar E2 mientras E1 siga abierto.
