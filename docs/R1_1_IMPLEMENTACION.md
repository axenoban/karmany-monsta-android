# R1.1 · implementación y validación

Base documental:29be7ba. Base funcional aprobada:Preview42/293ac5e. Candidata:Preview45/v0.24.0-r1.1, código636565422baa63dd4cc0f5026e55361ccd8f4fe1; CI38955362578 correcta. SHA256701108382045758c013bb5ed5cceaddeae4e5f5970822770fb704b3c5242ef08. Evidencia completa en R1_1_CANDIDATA_VERIFICACION.json. Work implementa, Chat revisa; no integración en dev/main sin prueba física explícita.

La primera ejecución PR21/Preview43 corresponde a cef00c5 y queda sustituida por la corrección de repetición de escenarios: el laboratorio conserva en memoria su preset al volver de combate y mantiene preferencias de accesibilidad al aplicar/reiniciar escenarios. Se añadió comprobación de igualdad de configuración tras regresar. No se entregó ni aprobó físicamente Preview43.

## NAV-01

`navigation_history.gd` guarda hasta32 nombres de ruta, deduplica redibujos y colapsa retornos a ancestros. `main._back` comparte botón y Android, cierra modales antes de los protocolos de ayudas/transiciones y vuelve al origen. Cambios de perfil/nuevo viaje invalidan historia. `TrialUI` ofrece Volver contextual y mantiene Mapa explícito. Ninguna navegación llama a iniciar encuentro ni concede recompensas.

## QA-01

`qa_profile.gd` construye desde defaults perfiles sintéticos estrictamente válidos, Ezel1–15/XP parcial, equipo1–3 de13 especies, niveles individuales/activo, región/etapa y stamina. Zephyr es la instancia inicial única; otras especies admiten duplicados con ID propio. Historial de rutas sintético ordenado para las12 entradas.

El adaptador QA omite exclusivamente la puerta de nivel/desbloqueo regional en `start_route`, `_start_encounter` y `select_region`, solo con `qa_active`. Los validadores, costes, estadísticas, combate, recompensas y guardados normales conservan sus reglas. No se alteran archivos de datos salvo metadatos de versión, ni recursos gráficos.

`qa_store.gd` fija `user://qa/profile.json`; App comprueba modo/almacén/ruta antes de guardar. Crear QA fallido no cambia el contexto. Salir recarga el almacenamiento normal validado; un error mantiene QA y muestra aviso sin escritura real. Reiniciar la aplicación nunca restaura modo QA automáticamente. Reiniciar QA requiere confirmación. No hay exportación en QA. Generación de Timer y contexto de botones impiden callbacks antiguos tras cambiar perfil.

Build preview:feature de exportación explícita `qa_preview`. Editor:requiere además `karmany/qa/development=true` (no activada por defecto). Producción sin feature no muestra entrada ni habilita simuladores. El antiguo laboratorio que mutaba la partida real fue sustituido; la redistribución normal de resonancias permanece operativa.

Indicador QA en CanvasLayer100, incluso sobre transiciones/captura. Controles en panel desplazable; letras grandes verificadas en render1280×720. Las pruebas de hardware siguen pendientes.

## Evidencia local

-CI final:31 suites Godot/5.857 comprobaciones sin fallos,3 pruebas Python; export/firma v2-v3 y publicación correctos.
-Suite R1.1 final:233 comprobaciones correctas, incluyendo perfiles/bytes principales, ruta errónea, archivo temporal no escribible, corrupción QA/recuperación, fallo de recarga normal, reinicio de App, callbacks, combate victoria/derrota, XP/recibo/captura únicos,12 etapas/finales dobles, navegación y Preview42.
-Interfaz:32 comprobaciones correctas,8 renders laboratorio/exploración/combate con texto normal/grande; logs sin errores.
-7 fixtures Preview42 emitidas por checkout exacto293ac5efb1b781258065171384db58db47b77aec, script reproducible `ci/recovery/generate_preview42_fixtures.gd`. Las regresiones históricas32/E2/38/40 se conservan.
-El test fundacional ahora establece rutas reales antes de comprobar Atrás, en lugar de suponer destinos fijos tras una lista artificial de pantallas. No se eliminaron sus aserciones.
-El test de captura usa tiradas deterministas y distingue la nueva ficha de unidad de una duplicación de XP. No se modifica el motor para satisfacer el test.

## Prueba física pendiente

1.Actualizar sobre Preview42 sin desinstalar. Exploración→Equipo→Colección→Atrás dos veces vuelve al origen.
2.Libro/Ajustes/Perfil/Bestiario vuelven al origen; ficha vuelve al Bestiario. Comprobar botón y gesto Android.
3.Combate vivo→mapa→retomar conserva encuentro y stamina.
4.Ajustes→Diagnóstico→Laboratorio QA: Ezel10, equipo3, Velo6. Confirmar indicador permanente y dos enemigos.
5.Salir QA: comparar equipo/niveles/stamina/regiones/capturas originales. Reiniciar QA no afecta la partida.
6.Cerrar app en QA y reabrir: carga partida normal. Comprobar letras grandes.

**SIGUIENTE PASO:** Chat revisa PR21/contrato/evidencias en lectura y acompaña la prueba física dePreview45.
**RESPONSABLE:** CHAT.
**INSTRUCCIÓN PARA CONTINUAR:** En axenoban/karmany-monsta-android revisa en lectura R1.1/PR21, código636565422baa63dd4cc0f5026e55361ccd8f4fe1, CI38955362578 y Preview45/SHA701108382045758c013bb5ed5cceaddeae4e5f5970822770fb704b3c5242ef08. Contrasta docs/R1_1_NAVEGACION_LABORATORIO_QA.md, R1_1_IMPLEMENTACION.md y R1_1_CANDIDATA_VERIFICACION.json; acompaña las seis pruebas físicas. No modifiques código ni integres dev/main antes de confirmación explícita «prueba correcta, Preview45». No E6/R2–R4.
