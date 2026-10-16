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