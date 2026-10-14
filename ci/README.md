# Compilación reproducible de preview

Motor fijado: Godot 4.7.2, GDScript y Compatibility. Java 17. Exportación Android mediante plantillas oficiales precompiladas; APK ARM64 para la primera prueba en POCO X6.

El workflow se ejecuta al crear/actualizar una PR hacia main o dev/karmany-core, y manualmente con workflow_dispatch. Descarga engine y plantillas, verifica SHA-512 oficial, configura SDK, importa, ejecuta tests, exporta y verifica firma. Conserva artefactos y publica una prerelease de prueba descargable para PR de este mismo repositorio.

## Firma de pruebas

`preview.keystore.b64` es intencionalmente una clave PÚBLICA DE PRUEBAS. Contraseña estándar `android`; alias `androiddebugkey`. Mantiene la firma entre builds de preview para poder actualizar sin desinstalar. No identifica al editor ni protege una distribución comercial. Nunca utilizar esta clave ni el paquete `.preview` para Google Play, pagos o datos sensibles. La distribución comercial usará un paquete y una firma protegida independientes.

Las claves comerciales, contraseñas privadas y credenciales no se guardan en este repositorio público.

## Versiones

Cada ejecución usa versionCode = 1000 + GITHUB_RUN_NUMBER. Reintentar una ejecución mantiene la misma versión; una nueva ejecución incrementa el código. Diagnóstico incluye SHA exacto de la rama de trabajo, no el merge sintético de la PR.

`main` permanece con la inicialización. No crear un baseline jugable validado en `dev/karmany-core` hasta la aprobación física del bloque.
