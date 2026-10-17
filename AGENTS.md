# Instrucciones de desarrollo de Karmany Monsta

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

