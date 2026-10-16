# Instrucciones de desarrollo de Karmany Monsta

Antes de actuar, leer `docs/ROADMAP_ESTADO.md`, `docs/ROADMAP_CHAT_WORK.md` y `docs/CONTINUIDAD.md`; verificar HEAD, historia, PR, diferencias y CI reales. Los documentos históricos no sustituyen GitHub ni las instrucciones actuales del creador.

## Baseline y etapa vigentes

Preview 38 / v0.21.0-unification, código `f0266badaa7851da3de2bcc08a65752b6409360b`, aprobada físicamente por el creador el 15/10/2026. R0 unifica Preview32 + Chat E1 + Work E2 y queda completada. PR #18 integrado por fast-forward verificado en dev @525acef829ba934ddce3bb84ed08edc194c2640e. GitHub cerró PR #17 por ascendencia, sin una segunda fusión. Los commits documentales posteriores conservan el mismo código aprobado.

E5 es la siguiente etapa pendiente: **Chat prepara primero diseño, especificación y criterios de aceptación**. **Work espera lo aprobado** y solo después implementará en una nueva feature desde dev validado. Esta intervención únicamente cierra R0; no inicia E5.

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

