# Auditoría de bifurcación: Preview32 (2 regiones) vs Chat E1 / Work E2

**Fecha de auditoría: 15 de octubre de 2026. Estado: divergencia CONFIRMADA; fusión funcional NO realizada.** Este archivo es fuente obligatoria antes de continuar Karmany Monsta; consultar también `docs/ROADMAP_ESTADO.md`.

## Conclusión verificada

El creador reportó que la APK anterior tenía dos regiones y la nueva solo una. **Tenía razón**: el archivo recuperado `Karmany_Monsta_Preview32.apk` contiene `data/jade_route.json` (6 etapas), `data/veil_route.json` (6 etapas), `data/veil_species.json` (6 especies del Bosque), estadísticas de ocho especies nuevas y recursos para dos regiones. La APK entregada por Chat/E1 `android-preview-34` partió de la última base sincronizada `dev/karmany-core` Preview29, con solo 4 puntos de Jade, y no contiene el Bosque. No está simplemente oculto ni es un problema de nivel de desbloqueo: **su código y sus recursos regionales pertenecían a una línea de desarrollo distinta que no se había subido a GitHub**.

### Comparación basada en archivos APK y GitHub

| Fuente | Compilación | Jade | Bosque | Funcionalidad / condición |
|---|---|---|---|---|
| Preview30 APK recuperada | 0.18.0, commit local `898b397d...` | 6 etapas | 6 etapas | Primer recorrido regional recuperado |
| Preview31 APK recuperada | 0.19.0, commit local `c6429a67...` | 6 etapas | 6 etapas | Transiciones/experiencia/vínculo contextuales |
| **Preview32 APK recuperada** | **0.20.0**, commit local `009e0c7d9dc4e7e6aa61509157318982152971f7` | **6 etapas** | **6 etapas** | Derrotas animadas y entrada de relevos; último paquete completo preservado como APK |
| GitHub `dev/karmany-core` | Preview29/v0.17.0 validada; luego solo documentación | 4 etapas | No | Última base publicable para trabajar; no incluye Preview30–32 |
| GitHub `feature/e1-jade-relay` | Preview34/v0.18.0 experimental, commit `1719c682...` del APK | 4 etapas | No | Relevo de Sakuromushi, bonus temporal; CI correcta, validación física pendiente |
| **Work E2 en ZIP recuperado** | Preview35 local/v0.19.0, código `42fed0ce330366de891ad7944e50e6d79f5836d8` | 4 visibles | No | Nuevo motor regional, bonos únicos, rivales por relevo y migraciones; fuente incremental Git; CI GitHub y prueba física pendientes |

**No confundir el release GitHub etiquetado `android-preview-35` con el `Karmany_Monsta_E2_Preview35.apk` de Work:** aunque comparten número visible, son compilaciones de líneas distintas. Comprobar `data/build_info.json` / SHA antes de decidir.

### Evidencia exacta recuperada de Preview32

- `assets/data/jade_route.json`: seis puntos con enemigos/niveles/XP, incluida final Inubari+Ushigane Nv10.
- `assets/data/veil_route.json`: Suzumeko Nv10, Kodamashi Nv11, Mujina-Kage Nv12, Tsukimi-Usagi Nv13, Kodama-Shin Nv14; final Karasu-Origami+Mujina-Kage Nv15. Seis puntos.
- `assets/data/veil_species.json`: seis fichas de Bosque del Velo. `assets/data/tactical_combat.json` incorpora las ocho especies nuevas (Sakuraneko, Inubari y seis de Bosque).
- Doce texturas CTEX exclusivas: ocho Karmany nuevos y cuatro entornos de Bosque (`veil_bamboo`, `veil_clearing`, `veil_overhead`, `veil_roots`).
- Cinco scripts GDScript exportados adicionales frente a la rama de E2: `aftermath_flow.gdc`, `aftermath_screen.gdc`, `combat_transition.gdc`, `combat_transition_screen.gdc` y `experience_panel.gdc`.
- **Límite crítico:** la APK contiene `.gdc` compilados y `.ctex` importados, **no los archivos editables originales .gd/.png**. No afirmar que el proyecto Preview32 se recuperó completo sin descompilar/convertir y validar. Los commits locales `009e0c7d...` y `42fed0ce...` no están presentes en el repositorio GitHub consultado.

### Archivos de rescate verificables

Disponible en **ChatGPT Library** bajo estos nombres exactos (no inferir rutas de contenedor en futuras sesiones):
- `Karmany_Monsta_Preview30.apk`
- `Karmany_Monsta_Preview31.apk`
- `Karmany_Monsta_Preview32.apk` — SHA-256 `3a65d6f760bd881e0fb176220e1c2ae59c25b1e09327d4fa2ed71c36f453f06a`.
- `Karmany_Monsta_E2_Fuente_y_Pruebas.zip` — SHA-256 `9ecf0f8064ea71293d4d47d44e1edffced47bd97aaa9a6e76169f6d0c60383af`; incluye `E2_incremental.bundle`, LEEME, documentación, 22 logs de suites y resultados.
- `Karmany_Monsta_E2_Preview35.apk` — SHA-256 `eaf1b8c8e6e8df3e0497217f171b9dd103400f4d7f0875560b7a1570ffbb5f47`.
- Artefacto creado por Chat: `Karmany_Monsta_Rescate_Preview32_y_E2.zip`, conteniendo JSON exactos, scripts compilados/CTEX originales del APK y bundle incremental de E2. Entregarlo a Work si no puede abrir Library.

En el paquete de Work: rama original local `feature/e2-regional-engine`, base E1 `1719c682...`, código `42fed0c...`, última cabecera documental `dc4a20a...`; 1587 checks Godot y tres Python reportados localmente, **no CI remota**. Work indicaba explícitamente que no era compatible con el progreso divergente Preview30–32. No reinterpretar eso como compatibilidad probada.

## REGLA DE NO REGRESIÓN — desde esta auditoría

**No se permite declarar una nueva alfa/unificación ni sustituir Preview32 como «versión más completa» hasta recuperar o reconstruir y probar:**
1. Las seis etapas de Jade y las seis de Bosque con progresión, niveles, stamina, capturas y jefes de dos miembros.
2. Las ocho especies/arte/animaciones regionales adicionales ya presentes en Preview32.
3. Los flujos de derrota, entrada de reserva, experiencia y vínculo continuos que existían en Preview32.
4. Las correcciones posteriores que sí aportaron valor: ataque con relevo Sakuromushi de E1 y motor regional más robusto, bonos y persistencia de E2.
5. **Migración sin pérdida de progreso desde ambas familias de APK** (Preview32 y Preview29/E1/E2); guardar y reabrir tras cambiar de región y tras una derrota. No borrar datos del usuario, no forzar firma o instalación sobre una partida existente sin verificar.

## Estrategia de integración (único dueño escritor: Work tras acordar la recuperación)

**R0 · Salvamento y prueba de origen.** Recuperar la fuente de Work E2 desde `E2_incremental.bundle` en un clon que contenga E1 original. Antes, verificar `git bundle verify` y crear `feature/e2-regional-engine-recovered`. No sobrescribir ni rebasar commits del usuario. Para Preview32, buscar respaldo de los fuentes originales fuera de la APK; si no aparece, convertir sus CTEX con herramienta compatible y reconstruir los .gd desde pruebas/especificaciones o técnica de recuperación **verificable y legal**. Registrar qué es idéntico y qué fue reconstruido.

**R1 · Rama de convergencia.** Crear `feature/unificacion-jade-bosque` desde la mejor base fuente recuperada e integrar E1/E2 mediante merge revisado. Convertir/añadir recursos y JSON rescatados como referencia canónica de la versión Preview32, **sin copiar archivos compilados .gdc como código editado**. Resolver cambios a rutas, catálogo, guardados, UI y motor táctico con pruebas. La dirección aprobada de apoyo con golpe/relevo debe respetarse también para especies nuevas con habilidades compatibles; no inventar balance sin aprobación.

**R2 · Paridad funcional y presentación.** Primero alcanzar las 12 etapas y 2 regiones de Preview32, mapas, encuentros, jefe y vínculo; después combinar las mejoras E1/E2, transiciones continuas, derrotas animadas y navegación. Registrar comparativa por escenario y diferencia visual, guardados y acciones.

**R3 · APK de convergencia para el creador.** Solo publicar como candidata si todas las suites Godot, CI GitHub, export/firma y pruebas de regresión específicas pasan. Exigir prueba Android del creador **en instalación segura sin comprometer guardados** antes de marcar integrada o superar Preview32. Mantener las APK anteriores disponibles para comparación.

**R4 · Seguir roadmap.** Una vez validada la convergencia, actualizar `docs/ROADMAP_ESTADO.md` y `docs/CONTINUIDAD.md` con el nuevo SHA/PR/CI/versión, retomar UX E4 y pruebas alfa. No tratar Bosque como una implementación futura inexistente: su contenido se debe preservar en la convergencia.

### Separación entre agentes para evitar volver a perder avances

- **Chat:** inventario de diferencias, fichas/canon, balance, criterios de prueba, revisión de código/CI, documentación y validación; solo lectura durante implementación de Work.
- **Work:** recuperación de fuente local E2, portado de Preview32, integración real, imágenes/conversión, pruebas Godot/Android, PR en rama feature. **No trabajar en paralelo sobre `tactical_encounter.gd`, `app.gd`, `trial_ui.gd`, `jade_route.gd`, `save_store.gd` u otros scripts compartidos.**
- **Ningún agente** debe promover `main` ni `dev/karmany-core` por contener un APK más reciente en número. Base validada ≠ base con más contenido; ambas deben preservarse hasta convergencia.

### Instrucción para Work (copiar sin reinterpretación)

«En `axenoban/karmany-monsta-android`, lee `AGENTS.md`, `docs/ROADMAP_ESTADO.md` y `docs/AUDITORIA_DOS_LINEAS_2026-10-15.md`. Primero recupera la rama E2 desde el archivo Library `Karmany_Monsta_E2_Fuente_y_Pruebas.zip` (`E2_incremental.bundle`) y audita el APK original Library `Karmany_Monsta_Preview32.apk`. No sobreescribas Preview32 ni versiones actuales. Prepara `feature/unificacion-jade-bosque` para recuperar el contenido de dos regiones/12 etapas, arte, derrotas y transiciones de Preview32 más el relevo E1 y el motor E2; conserva partidas anteriores. Ejecuta CI y emite una APK candidata **solo después** de comprobar regresión. Si faltan fuentes editables, registra el bloqueo específico y restaura de forma trazable, sin afirmar equivalencia no comprobada. Actualiza ROADMAP_ESTADO y CONTINUIDAD en la rama, con el siguiente paso». 
