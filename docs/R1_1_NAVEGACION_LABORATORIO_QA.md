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