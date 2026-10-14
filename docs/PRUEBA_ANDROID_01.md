# Bloque 01 — Base Android

Estado: aprobado por el creador el 14 de octubre de 2026 mediante «Prueba correcta, continúa».

Versión validada: Preview 3, commit `5de6f6e26292d6e2c508cbbd1d296e477553425d`. La captura de diagnóstico confirma Android API 36, modelo 23122PCD1G y 60 FPS en esa pantalla; esto no constituye una medición de rendimiento del combate ni de carga futura. Instalación y uso de la base aceptados por el creador. La prueba de actualización entre builds se realizará con el siguiente APK.

## Descarga e instalación

En GitHub, abrir Releases y seleccionar la preview más reciente. Descargar `karmany-monsta-preview.apk`, abrirlo y permitir instalación desde ese navegador cuando Android lo solicite. No desinstalar la preview anterior para actualizar: el paquete y la firma de pruebas se mantienen.

## Prueba

1. Abrir la aplicación. Debe verse el menú y la versión de preview.
2. En Ajustes, activar Texto grande y cambiar Vibración. Volver al menú.
3. Comenzar viaje y tocar Valle Jade. Debe aparecer «Visitado» y «Visita guardada».
4. Consultar el Libro y comprobar que Volver funciona.
5. Enviar la aplicación a segundo plano, bloquear/desbloquear el teléfono y volver. La pantalla debe responder.
6. Cerrar completamente la aplicación y volver a abrir. Continuar debe conservar la visita y los ajustes.
7. Abrir Diagnóstico. Comprobar build, commit y modelo; copiar el informe. Probar Exportar informe y elegir destino si el sistema lo permite.
8. Usar Atrás en una pantalla interior: vuelve al menú. Atrás en el menú cierra la aplicación.
9. Cuando se entregue la siguiente build, instalarla encima y comprobar que conserva los datos.
10. Comenzar otro viaje debe pedir confirmación, reiniciar la visita y conservar los ajustes. Cancelar no debe modificar la partida.

Reportar: build/commit, paso que falló, resultado observado y captura o diagnóstico cuando sea posible.

## Alcance

Esta entrega valida infraestructura Android, interfaz y persistencia. No incluye combates, captura, habilidades, ilustraciones finales ni una misión jugable. La orientación horizontal y primera base offline son decisiones técnicas provisionales para esta preview.

## Verificación automática

`godot --headless --editor --path . --import --quit`

`godot --headless --path . --script tests/run_tests.gd`

La prueba usa archivos separados de la partida. Incluye recuperación tras corrupción, interrupción de escritura, errores de guardado, retención de ajustes y navegación de todas las pantallas. CI conserva logs, imágenes de las pantallas y verificación de firma del APK.
