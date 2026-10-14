# Baseline validado

## Bloque 01 · Base Android

- Aprobación del creador: «Prueba correcta, continúa», 14 de octubre de 2026.
- APK: Android Preview 3, versión 0.1.0, versionCode 1003.
- Código probado: `5de6f6e26292d6e2c508cbbd1d296e477553425d`.
- CI: 32 comprobaciones, exportación, firma, render de pantallas y publicación correctos.
- Dispositivo de validación: Android API 36, modelo 23122PCD1G, declarado por el creador como POCO X6.
- Incluye: menú, ajustes, visita a Valle Jade, guardado/respaldo, reanudación y diagnóstico.
- La imagen de diagnóstico muestra 60 FPS en la interfaz. No extrapolar al futuro combate.
- Pendiente de siguiente entrega: verificar actualización sobre Preview 3 sin perder datos.

`dev/karmany-core` se establece desde este código validado, seguido solo por documentación de cierre. `main` conserva la inicialización; no hay versión comercial publicable.

No cambiar motor, paquete, firma de preview ni esquema de guardado sin justificación y regresiones. Los bloques nuevos se trabajan en `feature/*` y no se integran hasta su validación.

## Bloque 02 · Bestiario de Valle Jade y contratos de captura

- Aprobación: «Prueba correcta», 14 de octubre de 2026.
- APK: Preview 4, versión 0.2.0, versionCode 1004.
- Código aprobado: `e09462a6d551c1583a8c30f67be9dbe2908fea4d`.
- Verificación: 35 regresiones de base/navegación y 38 de catálogo/captura, CI y firma correctos.
- Alcance: 15 especies canónicas, filtros/fichas, contratos de captura y restauración. No incluye combate o captura jugable.
- `dev/karmany-core` avanza por fast-forward desde el baseline anterior; el cierre solo cambia documentación.

## Bloques 03–05 · Libro, turno compartido y árbol de resonancias

- Aprobación: «El avance está correcto», 14 de octubre de 2026. Mejora pendiente del touch del árbol para la siguiente entrega.
- APK: Preview 8, versión 0.4.0, versionCode 1008.
- Código validado: `a436d58b3a08c55cebe2d0b3654d8d2af011bc5d`.
- Verificación: 221 comprobaciones, exportación y firma correctas; capturas normal/texto grande revisadas.
- Incluye: tabla del Libro, equipo/turno compartido, árbol aprendible/mejorable y cuatro espacios, laboratorio experimental y migración persistente.
- No incluye todavía combate ni captura jugable. El usuario autorizó comenzar ese bloque con fichas experimentales y Ezel/Zephyr frente a Tanugami.
- Integración mediante fast-forward desde `ad618c2`; `main` se conserva.

## Bloques 06–08 · Encuentro, equipo y correcciones

- Aprobación: «Prueba correcta, vínculo, árbol, todo correcto», 14 de octubre de 2026.
- APK: Preview 14, versión 0.6.1, versionCode 1014.
- Código validado: `71f5a0d39be6ac2f31a7e2cbabfbdb1aa985d142`.
- Verificación: 310 comprobaciones Godot y tres pruebas Python, firma y auditoría del APK correctas.
- Incluye: combate experimental ilustrado, resonancias, vínculo, colección, equipo/activo previo al encuentro, última acción, persistencia y corrección sin resonancias.
- Capturas de revisión desactivadas por defecto, solo activación manual de escritorio; bloqueadas en Android y excluidas del APK.
- Integrado por fast-forward desde `b2c411a`, sin reescribir historia ni alterar main.
- Nueva decisión del creador para la próxima rama: resonancia opcional primero; habilidad del Karmany termina el turno y da respuesta automática del rival. El cierre manual y el orden libre se reemplazarán únicamente en ese bloque.

## Bloque 09 · Turnos automáticos

- Aprobación: «Prueba exitosa y hasta el momento no encontré errores graves o visibles», 14 de octubre de 2026.
- APK: Preview 15, versión 0.7.0, versionCode 1015.
- Código validado: `61cfc5c6b505e38f65f39488e10ddf5ef122bdf5`.
- Verificación: 344 comprobaciones Godot y tres pruebas Python; CI, exportación, firma v2/v3 y auditoría del APK correctas.
- Incluye: resonancia opcional antes de la habilidad, respuesta rival automática, recuperación de respuestas pendientes sin duplicar daño y paso directo al Libro tras la derrota rival.
- Capturas de revisión desactivadas; el paso de render en CI fue omitido.
- Integrado por fast-forward desde `d078c8b`; main conserva su estado.
- La siguiente fase se definirá mediante cuestionario solicitado por el creador. No se autorizan aún nuevas reglas, balance, especies o economía.
