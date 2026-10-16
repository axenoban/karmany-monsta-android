# E5 · implementación candidata

Contrato: [E5_PRIMERA_SESION.md](E5_PRIMERA_SESION.md), aprobado 15/10/2026. Work único escritor. Rama `feature/e5-primera-sesion`, base documental `08ed2e70b35bfd1489fd9d88a5cdff52e9447dc2`, juego Preview38 `f0266ba`. Sin E6 ni integración en dev/main. La aprobación del contrato no valida esta APK.

## Correspondencia de contrato y pruebas

| Intervención | Componente real | Prueba E5 |
|---|---|---|
| E5-01 | TrialUI mapa, tarjeta de selección | Texto aprobado y ayuda automática/manual en mapa |
| E5-02 | Ficha existente de localización | Coste real antes de aceptar; ayuda no gasta; entrada única |
| E5-03 | Exploración / Buscar encuentro | Tarjeta Buscar, reentrada al mismo encuentro sin nuevo gasto |
| E5-04 | Combate / PS y turno | Datos existentes, textos PS/turno; sin escritura al abrir |
| E5-05 | Ayuda / Otra explicación | Golpe/Guardia/Insignia con descripción y disponibilidad del modelo real |
| E5-06 | Menú Entrenador | Resonancia opcional y menú real sin consumir turno |
| E5-07 | Menú Equipo | Cambio voluntario y respuesta rival; abrir no modifica el encuentro |
| E5-08 | Reemplazo | Texto permanente distinto del cambio voluntario; fixture de reemplazo |
| E5-09 | Derrota / Aftermath | Recuperación y ausencia XP permanentes; no ofrece premio antiguo |
| E5-10 | Experiencia / Aftermath | Recibo persistido por individuo y topes, ayuda tras animación XP |
| E5-11 | Vínculo / Aftermath | Intentos del CaptureSession actual, omisión conserva victoria/XP |
| E5-12 | Mapa / combate / exploración | Retomar, pausa/reanudar, descarte persistido, Atrás antes de salir |

`first_session.gd` es presentación de solo lectura; `context_help.gd` reutiliza Label, PanelContainer, ScrollContainer y Button. Una tarjeta por vez, sin ventana modal, sin robar foco ni bloquear acciones. `Ayuda` vuelve a abrir las explicaciones pertinentes al estado actual; `Otra explicación` recorre sus temas. No muestra mensajes de captura/encuentro pendiente en estados terminales. El texto de técnicas extenso se desplaza dentro de una tarjeta acotada.

La extensión opcional de perfil `first_session: {version: 1, seen: [...]}` solo se activa en App cuando no hay perfil primario ni backup, o al confirmar un nuevo viaje (la confirmación destructiva previa ya existente se conserva). **Campo ausente no significa partida nueva.** Store mantiene schema3, defaults y migraciones históricas intactos; valida el campo solo si existe. Descartar guarda únicamente los identificadores vistos mediante la transacción normal; fallo de guardado conserva el progreso y permite cerrar la tarjeta, con aviso visible; la explicación no guardada puede repetirse. Abrir o consultar Ayuda no escribe. No se cambian motores, cifras, recursos, regiones, recompensas, tiradas, turnos ni captura.

## Validación técnica

- Godot 4.7.2 exacto y plantillas Android verificadas mediante SHA512 oficial.
- Suite histórica completa correcta (26 suites), 3 Python. Nueva suite `tests/first_session_tests.gd`: 601 comprobaciones, cero fallos.
- Regresión E5 sobre 69 archivos Preview32, 10 E2 y 7 perfiles generados por Store del código Preview38 aprobado: cargas válidas, bytes originales intactos y ningún tutorial forzado.
- Suite histórica también comprueba recompensa/bono únicos, reemplazo, derrota, XP parcial, finales, vínculo, turnos automáticos, sonido y movimiento reducido. Las 24 simulaciones de balance permanecen sin cambios.
- 12 pantallas E5 renderizadas normal/grande y 22 regionales de regresión; botones no recortados y objetivos táctiles comprobados. La suite E5 comprueba una tarjeta, entrada/retomar sin gasto duplicado, menús opcionales, Atrás, pausa/reanudar y exclusión de animaciones.
- Se corrigió primero el fallo real del contrato de defaults de instalación trasladando el opt-in a App; no se modificaron tests históricos ni watchdogs.
- CI38829976270 correcta; Preview39 v0.22.0-e5, código e9795fc, SHA25641578be4373256e46b7f26644be26a85ec15fe92c1fda08baf9382ce9a070bc7. Evidencia en E5_CANDIDATA_39_VERIFICACION.json; consultar checkpoint más reciente en ROADMAP_ESTADO y CONTINUIDAD. Los renders y logs se adjuntan al artefacto de CI. No confundirlos con prueba física Android.

## Prueba física propuesta · máximo 10 pasos

1. Actualizar instalando la APK E5 **sin desinstalar**. Verificar versión/build/SHA en Diagnóstico y conservar la partida existente. No comenzar un nuevo viaje sobre la partida que quieras conservar.
2. En la partida previa, comprobar progreso/equipo/regiones y reanudar. No debe aparecer tutorial automático. Abrir Ayuda y cerrarla con Atrás: conserva vista y partida.
3. Probar la primera sesión en un perfil de dispositivo Android separado o en otro dispositivo. Crear viaje nuevo; una persona novata elige y completa una localización sin guía verbal. Registrar dudas/asistencia.
4. Seleccionar un punto: leer coste antes de aceptar, entrar, volver al mapa y Retomar. Stamina se cobra una vez. Buscar encuentro debe continuar al combate.
5. Consultar PS/turno y Ayuda → Otra explicación para las técnicas reales. Abrir Entrenador y Equipo. Ayuda no consume acciones, no tapa ataques y admite descarte.
6. Provocar reemplazo y derrota total cuando sea posible. Reemplazo sin ataque adicional; derrota sin XP y recuperación en el próximo encuentro, con resumen claro.
7. Ganar: comprobar recompensa una vez, barra XP, subidas/topes por individuo. Ayuda ampliada espera la animación; resumen breve permanece disponible.
8. Probar vínculo, intentos restantes y continuación sin vínculo. Reabrir conserva victoria/XP sin repetir recompensa. Mantener finales de dos rivales y relevo Sakuromushi.
9. Activar texto grande, movimiento reducido y silencio. Pulsar Atrás, suspender/reanudar durante ataque/XP/vínculo, cerrar/reabrir. Controles y fondo continúan accesibles.
10. Reabrir una partida E5 tras descartar tarjetas: no repite esas ayudas automáticamente, Ayuda permite consultarlas. Informar dispositivo, versión/build, pasos, esperado/real y asistencia recibida. Confirmar explícitamente **«prueba correcta»** únicamente sobre la APK/SHA probada si resulta aceptable.

Pendiente: comprensión real por una persona novata, compatibilidad visual y ciclo de vida en dispositivo físico. No se declara validación humana ni se integra hasta la confirmación del creador.

## E5-REV-01 · corrección posterior a candidata39

El cierre de Ayuda dejó de depender del éxito de guardar su reconocimiento. Ante fallo, Cerrar/Atrás cierran y Otra explicación avanza; queda un aviso visible de almacenamiento, perfil y `seen` sin modificar. La explicación no guardada puede repetirse al volver; un segundo Atrás vuelve al mapa. La transacción y los respaldos de Store no se cambian. Se evita también la reapertura por oferta automática diferida cancelada.

La prueba anterior de E5 esperaba que la tarjeta quedara visible al fallar. Esa expectativa incorrecta se sustituyó por el contrato no bloqueante, reproduciendo el fallo antes del cambio. La nueva suite ayuda/persistencia añade comparación exacta de perfil y bytes primario/respaldo, dos fallos reales de escritura, cierre por botones/Atrás, avance, interrupción/recarga, reintento y guardados antiguos. La suite completa y APK nuevas constan en los checkpoints más recientes.

**Prueba física adicional obligatoria:** en la APK corregida abrir/cerrar Ayuda varias veces, probar Atrás una y dos veces, Otra explicación, suspender/cerrar/reabrir y comprobar la partida. No es necesario ni recomendable llenar el almacenamiento del dispositivo: el fallo de escritura se inyecta de forma reproducible en tests aislados. Se mantiene pendiente la prueba autónoma por una persona novata y nueva confirmación «prueba correcta» para la APK/SHA corregida; no se hereda de39.
