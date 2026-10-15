# Instrucciones de desarrollo de Karmany Monsta

Antes de iniciar cualquier desarrollo, ajuste o actualización, leer `docs/CONTINUIDAD.md` completo y los documentos que indique para el bloque actual. Verificar ramas, commits, cambios locales y CI reales antes de editar. Esta lectura es obligatoria, especialmente antes de cambios grandes.

Al terminar cada mejora actualizar `docs/CONTINUIDAD.md`: implementación, rama, pruebas ejecutadas, validación pendiente, limitaciones y siguiente paso concreto si el creador confirma «prueba correcta». Actualizarlo también ante interrupciones o cambios de alcance. No afirmar resultados aún no comprobados.

«Prueba correcta» permite cerrar el bloque e integrar por fast-forward en `dev/karmany-core`, sin force push. `main` se reserva para publicación. Trabajar en `feature/*` para bloques no validados. Conservar guardados y reglas aprobadas; no inventar canon, balance o economía. Si el siguiente bloque requiere decisiones nuevas, preparar preguntas concretas antes de implementarlo.

Las instrucciones del usuario tienen prioridad. No es necesario recuperar el chat anterior si este documento y el estado real del repositorio proporcionan el contexto suficiente.

## ALERTA DE RAMAS DIVERGENTES (prioridad máxima, 15/10/2026)

ANTES de codificar: leer `docs/AUDITORIA_DOS_LINEAS_2026-10-15.md` además del roadmap vivo. Se verificó por análisis de APK que Preview32 contenía **dos regiones y 12 etapas**, mientras que las APK Chat/E1 y Work/E2 retornaron a 4 etapas de Jade por partir del `dev` previo. **NO dar por terminado el proyecto ni avanzar E2/E3 aisladamente:** primero rescatar la fuente E2 en Library (`Karmany_Monsta_E2_Fuente_y_Pruebas.zip`) y preservar los elementos de Preview32 (`Karmany_Monsta_Preview32.apk`) mediante una rama de convergencia. Solo Work escribe motor/arte durante ese rescate; Chat audita. No presentar `.gdc` como fuente editable. No migrar perfiles de Preview32 sin pruebas. No tocar `dev`/ `main` salvo documentación verificada y futuras aprobaciones explícitas.

## Roadmap vivo y reparto Chat / Work (lectura obligatoria)

**Antes de cualquier acción**, desde Chat, Work u otro agente, leer desde la rama actual `docs/ROADMAP_ESTADO.md` (estado vigente/propietario), `docs/ROADMAP_CHAT_WORK.md` (etapas E0–E10, roles, prompts y puertas) y `docs/CONTINUIDAD.md` (historial técnico). Verificar después los HEAD/commits reales de `dev/karmany-core`, `feature/*`, PR abiertos, checks y últimas APK. Un texto con SHA antiguo o un comentario de chat nunca sustituye a GitHub.

- Cuando el creador diga «continúa», identificar primero la etapa activa y **su dueño único de escritura** según `docs/ROADMAP_ESTADO.md`. Si no te toca programar, revisar, especificar, auditar o explicar el bloqueo sin duplicar trabajo de otro agente.
- Chat suele ser responsable de diseño, decisiones, balance, auditoría y QA; Work de programación de bloques, compilación y APK. La prioridad es la **fase del tablero**, no el tipo de agente. La asignación puede cambiar expresamente por el creador; registrar el traspaso antes de modificar código.
- Solo **una rama funcional escribible** para los mismos archivos; lecturas simultáneas sí. No permitir doble edición de `AGENTS.md`, `CONTINUIDAD.md`, `ROADMAP_ESTADO.md`, código compartido o archivos de reglas mientras otro es dueño.
- Tras cada avance, fallo, interrupción, prueba o traspaso, **el dueño de la rama** actualiza `docs/ROADMAP_ESTADO.md` y `docs/CONTINUIDAD.md` en esa misma rama. Anotar fase, estado real, responsable, SHA, PR, CI, release/APK, validación física (o pendiente) y siguiente acción. No marcar `aprobado` por CI verde.
- Solo cuando el creador valide explícitamente la APK/cambio, el dueño verifica historial, CI y contratos; **integra por fast-forward si es seguro**, verifica `dev/karmany-core`, cierra PR y actualiza ambos documentos de estado en `dev`. Si `dev` avanzó por documentación, incorporar `dev` a la feature de manera trazable antes de intentar FF; no forzar ni reescribir historia.
- No dar por terminado E1 por la publicación de Preview34: el relevo de Sakuromushi tiene observación humana pendiente. No iniciar implementación E2 sin cerrar ese bloqueo y adjudicar expresamente la escritura.

