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
