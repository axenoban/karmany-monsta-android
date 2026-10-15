# E1 — Paquete aprobado de Valle Jade y ataque con relevo

Estado: aprobado como diseño para implementación y pruebas. La rama feature/e1-jade-relay es **experimental**. No integrar directamente a dev sin validación del creador.

## Aprobaciones de Valle Jade
- Seis etapas: Tanugami Nv1, Ushigane Nv3, Kitsunibi Nv5, Sakuromushi Nv7, Sakuraneko Nv8 y final Inubari + Ushigane Nv10 por relevos consecutivos.
- XP total primera victoria 400/500/600/650/700/750 por individuo elegible; XP al repetir 100/125/160/200/240/300. Solo un bono de primera victoria por etapa, nunca repetirlo al recargar.
- Stamina de 10 para cada etapa normal y 30 para la final. Mantener regeneración y consumibles actuales.
- Equipo rival final: uno activo, otro reserva; sin curación al relevo, sin ataque rival adicional, una victoria/recompensa al ganar al equipo completo. Elegir un enemigo derrotado para el único vínculo de tres intentos.
- Capturas nuevas al nivel del rival derrotado con XP parcial 0. Conservar guardados, equipo, capturas, niveles y progreso antiguo; respetar encuentros/capturas ya iniciados.
- Sakuraneko Vida72/Ataque20/Defensa7, insignia cura10 y protección20%, recarga3. Inubari Vida84/Ataque18/Defensa11, insignia daño110% y protección30%, recarga2. Cifras experimentales para el juego, no canon de la enciclopedia.

## Cambio de diseño: apoyo sin doble coste de turno
El creador rechaza los apoyos en que hay que usar una acción de potenciación y gastar el siguiente turno para cambiar de Karmany. Ahora la intención aprobada es **golpe ligero + relevo inmediato + mejora durante varias rondas**, de forma que el nuevo activo reciba el contraataque rival.

En esta primera implementación aislada, **solo Sakuromushi** usa el nuevo mecanismo:
1. Requiere elegir una reserva viva diferente del Karmany activo.
2. Golpea al rival, releva automáticamente al activo y habilita una única respuesta rival dirigida al entrante.
3. Bonus temporal de ataque al entrante, con vencimiento por número de rondas, no por una sola acción. No se suma aditivamente a otros bonus: prevalece el mayor.
4. Duración y beneficio quedan en el guardado del individuo, se preservan al recargar y expiran al inicio de la tercera ronda posterior. Su Insignia conserva la recarga de dos turnos.
5. Si la habilidad derrota al enemigo, procede la victoria/vínculo normalmente. Sin reserva viva o selección válida no gasta turno ni recursos.

### Balance **provisional** usado solo en la rama de ensayo
- Daño del golpe de relevo: **70%** del golpe estándar.
- Bono al entrante: **+20%** de daño durante las **dos rondas siguientes**.

Son parámetros ajustables de test, no valores finales aprobados individualmente. Se mantendrán fuera de `dev/karmany-core` hasta validar comportamiento y balance en Godot/Android.

## Alcance actual de esta rama
Implementa la habilidad experimental de Sakuromushi, controles y pruebas de regresión. **No** integra todavía las etapas 5–6, las dos criaturas nuevas, XP por etapa, captura al nivel enemigo ni rivales de reserva; corresponden a E2 y E3 según el roadmap. No incorporar Tsukimi-Usagi del Bosque hasta E7.

## Prueba de aceptación
- Sakuromushi activo con dos reservas: usar Insignia, elegir una, comprobar daño y cambio instantáneo; el contraataque daña al que entra.
- No poder seleccionar activo, reserva debilitada o inexistente.
- El buff funciona las dos rondas siguientes; una acción defensiva también consume tiempo, y en la tercera caduca. No apilar buffs acumulativos.
- Guardar tras el relevo, cerrar/abrir app, y verificar activo, HP, bonus, plazo y que no se duplica el turno rival.
- Probar la Insignia normal, sustituciones por derrota, ataques de Sakuromushi enemigo sin reserva, texto grande y movimiento reducido.
- CI Godot/Android y test físico del creador. No confundir CI con validación física.

## Siguiente paso — E2 (Work)
Partir del baseline validado cuando el creador lo autorice; crear feature dedicada a motor regional, XP por etapa y bonos únicos, niveles rivales, relevos enemigos, capturas al nivel encontrado y migración de partidas. Después E3: dos especies jugables, seis etapas, fondos/arte Jade. **No trabajar Bosque del Velo ahora ni reescribir historial de Git.**
