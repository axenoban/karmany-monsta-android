# UX jugable · Candidata de combate compacto

**Base:** `feature/ux-combate-resultados-continuos@6b8d61426eb1179a2311c7243affaf3df6baae25` (PR27/Preview73; NO aprobada para dev).
**Estado:** trabajo de UX en `feature/ux-jugador-combate-compacto-preview`; candidata de Android **pendiente de CI y validación física**.
**Fuente:** Plan Director v0.16, D-21 y D-32. La decisión de objetivos únicos (historia/misiones secundarias) se conserva solo en documento hasta recibir catálogo canónico.

## Implementado en esta candidata
- En combate se mantienen **Golpe** e **Insignia real** como acciones primarias; Guardia/Protección sigue disponible en **Táctica** y conserva exactamente el motor y la respuesta rival.
- Entrenador y Equipo accesibles en un solo toque, consultas sobre combate sin abandonar la ruta. Panel Detalles reubicado dentro de **Menú → Estado y técnicas**, con las cuatro pestañas anteriores.
- Cabecera más limpia con un único **Menú** y el turno actual. Atrás Android abre el mismo menú reversible en combate; «Volver al combate» lo cierra, sin consumir turno ni stamina.
- Menú de combate incluye **Volver al mapa** (conserva el encuentro y respuesta pendiente), **Abandonar pelea** (confirmación y misma restricción de enemigo pendiente) y Estado y técnicas.
- Se reutilizan los iconos del kit Jade Nocturno existente; no hay arte nuevo ni cambios de paleta.
- Menú **no se llama Pausa y no suspende el temporizador rival**. Las semánticas de Pausa real/Reiniciar/Salir continúan pendientes D-21; no se simulan.
- La ayuda E5 de primera sesión se mantiene disponible como en PR27. El antiguo vínculo tras derrota sigue intacto en APK.

## No se implementa ni se promete en esta APK
- Misiones de historia o secundarias, aunque se aprobaron como **objetivos únicos** y criterios posibles «capturar especie» / «derrotar especie N veces». Faltan contenidos canónicos concretos.
- Captura con rival vivo, sellos consumibles, XP por captura P5, botín exclusivo, inventario general, fabricación, equipamiento pasivo, tienda o monetización.
- Cambio de efectos de Guardia/Insignias o nuevos actos de Karmany: se mantienen el canon y validadores de PR27.

## QA de la candidata
1. Verificar CI de Android en PR de esta rama; descargar solo la APK de release de **esa ejecución y SHA real**.
2. Abrir en Android 16:9 y probar texto normal/grande, movimiento reducido y controles táctiles.
3. Batalla: deben verse **Golpe / Insignia / Entrenador / Equipo / Táctica / Menú**; *Detalles* no debe ocupar el HUD primario.
4. Abrir Táctica: Guardia/Protección debe estar disponible según la regla real y sus bloqueos. Cerrar con Atrás; contador de turno y PS idénticos.
5. Atrás Android abre Menú (sin abandonar); segundo Atrás cierra Menú. «Estado y técnicas» abre las cuatro pestañas. «Volver al combate» vuelve a la misma pelea.
6. «Volver al mapa» y «Retomar encuentro» conservan HP/turno/estado, sin nueva stamina; «Abandonar pelea» requiere confirmación y sigue bloqueado si hay respuesta pendiente.
7. Probar un ataque/Insignia con destinatario, victoria, XP, Libro anterior, captura o renuncia, final de dos enemigos y Laboratorio QA aislado. Ningún premio ni captura duplicados.
8. La CI incluye regresiones reforzadas en `continuous_ux_tests.gd` y `combat_readout_tests.gd`.

**Integración:** no fusionar con `dev/karmany-core` ni `main` hasta «prueba correcta» y cierre de dependencias PR21–27. No afirmar que la CI confirma calidad visual de Android.
