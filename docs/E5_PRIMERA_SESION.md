# E5 · Primera sesión autónoma · contrato funcional aprobado

**Aprobación humana:** 15/10/2026 (America/La_Paz). El creador aprobó explícitamente las 12 intervenciones, microcopias, criterios y cuatro decisiones de UX.
**Estado actual:** IMPLEMENTADA Y APROBADA FÍSICAMENTE en Preview40 por el creador; cierre seguro autorizado a Work el15/10/2026. Código0c356db, CI38833949394 y SHA en ROADMAP_ESTADO. Este documento conserva íntegro el contrato aprobado; referencias a implementación futura del cuerpo son antecedentes. E6 no iniciada.
**Repositorio:** `axenoban/karmany-monsta-android`.
**Base comprobada al aprobar:** `dev/karmany-core` @ `76a7347f60605cc28259b0a087f4654b69a89164`. **Código de juego aprobado:** `f0266badaa7851da3de2bcc08a65752b6409360b` (Preview 38 / v0.21.0-unification). Work DEBE consultar HEAD real antes de crear rama.
**Rama futura sugerida:** `feature/e5-primera-sesion`, desde el nuevo `dev` validado. `main` intacta.
**Fuente de autorización:** declaración explícita del creador en la conversación de aprobación E5; no confundir aprobación de especificación con validación de APK E5.

## Objetivo y frontera

Una persona sin experiencia previa debe poder comenzar una partida, seleccionar una localización, entender el coste de stamina, descubrir el encuentro, combatir, interpretar victoria o derrota, entender la progresión y decidir si intentar un vínculo, regresar al mapa y reanudar sin explicación verbal. **Solo UX/onboarding y claridad; ninguna modificación de reglas.**

Contrato de comportamiento aprobado:
1. Tarjetas contextuales pequeñas, descartables, no bloqueantes, integradas en la interfaz real.
2. Primer recorrido guiado automáticamente SOLO en **partidas nuevas**. Las partidas previas no reciben tutorial forzado; no inferir que todo campo ausente equivale a “partida nueva”.
3. Una opción `Ayuda`, disponible en ubicaciones pertinentes, permite consultar de nuevo todas las explicaciones cuando el jugador lo desee.
4. **Resumen breve** de derrota/progresión siempre visible en los estados pertinentes; explicación contextual ampliada únicamente cuando corresponda a primera experiencia o ayuda solicitada.
5. Mostrar como máximo una tarjeta contextual a la vez. La ayuda no roba turnos, recompensa, desbloqueos, recursos ni acciones y no se superpone a animaciones críticas.
6. Toda variable en los textos se toma del estado real del juego; no fijar costes, XP, intentos, niveles o especies como constantes de tutorial.
7. Preservar continuidad visual, controles y fondos de E4. No añadir nuevas pantallas largas ni navegación obligatoria.

## Alcance E5 · 12 intervenciones de interfaz

| ID | Ámbito | Intervención |
|---|---|---|
| E5-01 | Mapa | Guiar la selección de puntos explorables |
| E5-02 | Stamina | Informar el coste de entrada antes de aceptar |
| E5-03 | Exploración | Distinguir Buscar encuentro y Retomar sin segundo gasto |
| E5-04 | Combate | Interpretar PS, turno y respuesta rival |
| E5-05 | Habilidades | Diferenciar Golpe, Guardia e Insignia consultando el efecto real |
| E5-06 | Entrenador | Identificar resonancias opcionales |
| E5-07 | Equipo | Explicar cambio voluntario y su respuesta rival |
| E5-08 | Derrota parcial | Explicar reemplazo tras caer el activo |
| E5-09 | Derrota total | Explicar recuperación y ausencia de XP |
| E5-10 | Progresión | Interpretar recompensa, barra XP, niveles y límite regional |
| E5-11 | Vínculo | Explicar intentos disponibles y continuación sin vínculo |
| E5-12 | Continuidad | Volver al mapa, reanudar encuentro e interrupciones |

No obliga a crear doce pantallas ni doce scripts. Reutilizar vistas existentes y agrupar lógica de ayuda de manera simple.

## Microcopias aprobadas

Estas cadenas son texto editorial autorizado. Cambios sustantivos se consultan antes de implementar; sustituciones dinámicas y ajustes accesibles de corte de línea son aceptables.

| Contexto | Texto aprobado |
|---|---|
| Primer mapa | "Selecciona un punto del mapa para explorar esa localización." |
| Antes de entrar | "Entrar cuesta {coste} de stamina. Retomar un encuentro no vuelve a cobrarte." |
| Dentro de la localización | "Pulsa Buscar encuentro para descubrir al Karmany de este lugar." |
| Primer combate | "Los PS indican la vida restante. Si llegan a cero, el Karmany queda fuera de combate." |
| Turno | "Puedes usar una resonancia y después actuar con tu Karmany. El rival responderá." |
| Insignia | "Cada Insignia tiene su propio efecto y disponibilidad. Consulta su descripción." |
| Entrenador | "Las resonancias son opcionales. Puedes combatir sin utilizar ninguna." |
| Cambio voluntario | "Cambiar de Karmany consume tu acción. El rival responderá contra el nuevo activo." |
| Reemplazo por derrota | "Tu Karmany ha caído. Elige un compañero disponible: este relevo no provoca otro ataque rival." |
| Derrota total | "Todo tu equipo ha caído. No recibes XP por esta derrota. En el próximo encuentro, el equipo volverá recuperado." |
| Experiencia | "Has ganado {xp} XP. Observa la barra para comprobar tu progreso y las subidas de nivel." |
| Límite regional | "Has alcanzado el límite de experiencia de esta región." |
| Vínculo | "Puedes intentar el vínculo con el Libro. Te quedan {intentos} intentos." |
| Omitir vínculo | "Puedes continuar sin vincular. Tu victoria y la experiencia obtenida se conservan." |
| Regresar al mapa | "Volver al mapa conserva tu encuentro pendiente. Usa Retomar para continuar." |

**Precisión:** mensajes solo en estados verdaderos. No prometer XP en derrotas ni duplicar una recompensa guardada. El comportamiento real de `aftermath_screen.gd` y los demás flujos de Preview 38 tienen prioridad sobre suposiciones de texto; cualquier contradicción funcional debe informarse, no cambiar reglas.

## Criterios de aceptación

| ID | Prueba observable |
|---|---|
| AC-01 | Jugador nuevo localiza y entra en un punto sin orientación externa |
| AC-02 | Stamina clara antes del coste; Retomar nunca cobra una segunda vez |
| AC-03 | Identifica PS, acciones y turno; la ayuda nunca altera combate |
| AC-04 | Ayudas de Insignia/resonancia reflejan opciones realmente disponibles |
| AC-05 | Derrota parcial y reemplazo correctos, sin ataque rival adicional |
| AC-06 | Derrota total: no recibe XP; jugador comprende cómo regresar |
| AC-07 | XP y subida de niveles veraces, ninguna duplicación de recompensa |
| AC-08 | Vínculo opcional: omitirlo conserva la victoria y XP |
| AC-09 | Tutorial y botón Ayuda no bloquean interacción ni estados pendientes |
| AC-10 | Reinicio conserva guardado y estado del tutorial, sin onboarding forzado en guardados previos |
| AC-11 | Texto grande, movimiento reducido, audio/silencio y Atrás de Android funcionan |
| AC-12 | Jade y Bosque, ambas seis etapas, 13 criaturas, arte, finales, relevos, migraciones y demás Preview 38 permanecen idénticos |

**Test de comprensión:** prueba humana sin guía verbal que cubra: (1) elegir punto; (2) coste; (3) Buscar; (4) PS/turno; (5) Insignia/Entrenador; (6) ganar o recuperarse de derrota; (7) XP si gana; (8) vínculo opcional; (9) regresar/cerrar/reanudar. Registrar dudas, fallos y asistencia. Al menos una persona novata completa una localización autónomamente; recomendable tres para contrastar antes de E6.

## Regresiones obligatorias

- **Guardados:** partida nueva, perfil Preview 38, fixtures Preview 32 y E2, batalla abierta, enemigo pendiente, sustitución, derrota, victoria, vínculo pendiente, XP parcial, cierre en tutorial y reapertura.
- **Economía/progreso:** stamina única, recompensa/bonos únicos, captura única, puntos y árbol, XP correcta y topes regionales.
- **Flujos UI:** batalla y transiciones E4, derrota, resumen XP, vínculo, finales con varios rivales, fondo continuo, activación de Ayuda, descartado, no repetición automática en partidas antiguas.
- **Android:** Atrás, pausar/reanudar durante animaciones, cierre/reapertura, tamaño de texto, movimiento reducido, silencio, pantalla pequeña y botones accesibles.
- **Técnicas:** Godot 4.x import limpio, parser/runtime sin errores, suites existentes completas + pruebas E5, CI, exportación/firma y auditoría habitual. No aumentar watchdogs ni debilitar asserts.

## Exclusiones / zonas protegidas

No añadir Karmany, regiones, lugares, narrativa, tutorial narrativo, objetos, habilidades o recompensas. No modificar canon, balance, costes de stamina, XP, dificultad, técnicas, turnos, probabilidades de vínculo, Libro, datos regionales, árbol, motor E1/E2, combate ni migraciones históricas; no rehacer E4 ni su arte. No crear telemetría, cuentas, monetización, servidores ni tareas E6/E7/E8. No modificar `main`.

Si para persistir el tutorial se requiere un dato adicional, usar extensión opcional, aislada y compatible con los guardados existentes; verificar que no altera ni normaliza destructivamente ningún perfil. Work evalúa el mecanismo concreto inspeccionando el código real antes de implementarlo. No sobrescribir guardados ni iniciar tutorial al cargar un perfil previo.

## Entrega exigida a Work

1. Antes de editar: `AGENTS.md`, `docs/ROADMAP_ESTADO.md`, `docs/ROADMAP_CHAT_WORK.md`, `docs/CONTINUIDAD.md` y este contrato; verificar HEAD, historia, PR, CI y estado exclusivo del escritor.
2. Una única rama `feature/e5-primera-sesion` desde `dev/karmany-core` actualizado, sin trabajo paralelo sobre los mismos archivos.
3. Implementar únicamente E5-01 a E5-12; documentar correspondencia requisito → componente y prueba.
4. Ejecutar todas las regresiones, CI y exportar APK candidata identificable; no declarar prueba física por CI.
5. Actualizar `ROADMAP_ESTADO.md` y `CONTINUIDAD.md` EN LA RAMA feature, con SHA, CI, APK y validación humana pendiente.
6. Entregar PR con diff revisable y prueba local de máximo 10 pasos; E5 queda pendiente hasta “prueba correcta” sobre APK/SHA identificable. No integrar a `dev` sin ese hito. `main` intacta.

## Checkpoint documental de aprobación

- **R0:** cerrada, Preview38 aprobada físicamente, PR18 integrado.
- **E5 especificación:** aprobada explícitamente, contrato congelado para Work.
- **E5 código:** no iniciado durante este traspaso documental.
- **Responsable siguiente:** WORK.
- **Siguiente paso:** verificar HEAD real, crear feature desde dev, implementar alcance E5 aprobado y entregar CI/APK/PR para revisión y validación física.
