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
