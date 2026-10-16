# R1 · implementación y prueba de la candidata

Contrato: `R1_NAVEGACION_IDENTIDAD.md`. Work único escritor. Base documental `ce6917a61ab4dadd9e06296854361d9b9a56f22c`, funcional Preview40 `0c356db`. Rama `feature/r1-navegacion-identidad`. No integración hasta «prueba correcta» explícita de la nueva APK.

## Alcance implementado
- R1-01: cinco viñetas manuales con imágenes originales Ezel/Axe/Zephyr, Valle Jade y Libro; transición breve, inmediata con movimiento reducido. Siguiente/Omitir/Atrás, lectura libre sin temporizador ni combate. Duración orientativa de lectura45–90s, no espera obligatoria. Repetición desde Ajustes de solo lectura. Nueva partida crea `r1_intro`; ausencia = anterior. Guardado normal transaccional; fallo deja aviso y salida, sin cambiar perfil ni reabrir en bucle durante la sesión. Tras reiniciar una introducción pendiente puede retomarse desde el comienzo; no repite recompensas porque no concede ninguna.
- R1-02: Inicio Continuar aventura/Nueva partida/Ajustes. Continuar retoma búsqueda o encuentro pendiente sin entrada adicional; sin encuentro abre Shisai. Tarjetas Jade/Bosque6+6, requisitos y coste existentes; apertura no gasta stamina. Eliminados CTA duplicado y Visitar, se preserva campo histórico. Diagnóstico en Ajustes.
- R1-03:21 entradas originales con filtro de rareza, ilustración o reserva neutral. Silueta para especies no vinculadas; ficha real según `campaign.collection`, nunca según capturas simuladas. Nv1 desde CombatCatalog solo si existen cifras. Zephyr permanece fuera del catálogo.
- R1-04: Ezel, nivel/XP/puntos/resonancias reales y cada individuo del equipo por instance_id. Axe mentor. Sin PS persistentes ni nuevas bonificaciones.
- R1-05: un área de gesto para fondo/enlaces/nodos, umbral adaptado a densidad y escala, límites, tap/drag separados, ratón y pantalla táctil. Posición conservada al seleccionar, compra/equipamiento explícitos sin cambios al modelo económico.

## Evidencia técnica
Suite R1:411 comprobaciones; incluye perfiles originales Preview32/E2/38, siete perfiles generados ejecutando fuente exactaPreview40, cargas sin escritura, persistencia de marca, fallo real `.tmp` bloqueado con primario/backup conservados, repetición/Atrás, reanudación, propiedad de especies, ausencia de arte/stats, equipo1–3 y40 arrastres sintéticos normal/grande. Renders26 pantallas (normal/grande y960×540). Esto no certifica20 arrastres en hardware Android: debe comprobarlo el creador.

Suite histórica completa y CI se registrarán con referencias reales al entregar. No cambios a JSON de juego, motores de combate/progresión/regiones, migraciones Preview32 ni recursos artísticos. SaveStore conserva schema3, validando solo la extensión opcional. Versionado candidata0.23.0-r1.

## Prueba física concreta
Actualizar sin desinstalar ni borrar datos. Primero probar la partida anterior; Nueva partida conserva su confirmación destructiva: usarla solo después de respaldar la partida que se quiera conservar.

1. Abrir partida anterior: Continuar recupera mapa/búsqueda/combate correcto, sin prólogo automático ni cobro adicional. Comprobar progreso y equipo.
2. Ajustes → Ver introducción: cinco viñetas, Siguiente/Atrás/Omitir; al salir permanecen partida y ayudas E5. Probar sonido apagado y movimiento reducido.
3. En nueva partida de prueba: completar u omitir lleva al mapa; cerrar/reabrir retoma si quedó pendiente y no la fuerza tras completarla. Probar Atrás Android.
4. Shisai: acceder a Jade y comprobar Bosque/requisitos,6+6 puntos; abrir una región no descuenta stamina. Libro, Bestiario, Equipo y perfil accesibles.
5. Bestiario:21 especies; no vinculadas en silueta, adquiridas con ilustración/datos, filtros; Zephyr solo en perfil/equipo. Comprobar Ezel, nivel, XP y resonancias.
6. Árbol:20 arrastres repartidos entre nodo/enlace/fondo; tap selecciona; arrastre nunca compra/equipa. Repetir con texto grande; comprobar posición y botones explícitos.

Informar versión/Preview, resultado y defectos reproducibles. Solo «prueba correcta» sobre la APK identificada autoriza a Work a comprobar después la integración segura. No E6/R2/R3/R4.

SIGUIENTE PASO: revisión de Chat y validación física de la candidata. RESPONSABLE: CHAT. INSTRUCCIÓN PARA CONTINUAR: verificar PR/CI/SHA reales de feature/r1-navegacion-identidad contra contrato R1; auditar en lectura, acompañar los seis pasos y registrar decisión del creador. No escribir ni integrar ni iniciar otra etapa.
