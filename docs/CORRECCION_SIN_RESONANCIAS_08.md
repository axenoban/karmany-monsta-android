# Corrección sin resonancias y revisión de imágenes · 0.6.1

La imagen del POCO X6 mostró que la leyenda de resonancias vacías ocupaba una columna de ancho casi cero. El Label con autowrap estaba dentro de un HBoxContainer sin expansión horizontal. Esto disparaba su altura y desplazaba Cerrar turno fuera del área visible. El estado del combate sí conservaba la acción de Zephyr, pero no quedaba accesible el control que resolvía al rival.

Se da al Label expansión horizontal y una indicación breve para cerrar turno. No se cambia la economía de acciones ni se consume automáticamente la resonancia opcional. La actualización retoma el mismo encuentro: después del ataque ya ejecutado, Cerrar turno permite la respuesta rival.

La regresión reprodujo cinco fallos de disposición antes del arreglo. Después verifica ancho/altura del texto y posición/activación del botón en texto normal y grande. Pulsando botones reales completa respuesta rival, siguiente ronda, victoria y vínculo sin resonancias; se verifica el guardado final.

## Imágenes y APK

La revisión del APK Preview 13 no encontró scripts de pruebas ni recursos de captura. Los usos de get_texture/get_image/save_png del proyecto estaban en tests/render_smoke.gd, excluido del APK, ejecutado por GitHub Actions en el servidor. El juego no tiene código de captura del teléfono en sus scripts de producción. El manifiesto de esa preview declara DUMP de depuración y VIBRATE, sin permisos de captura de pantalla.

A solicitud del creador, la generación automática de imágenes en CI queda desactivada por defecto. Solo puede habilitarse con la entrada manual ui_review; el script exige además --allow-ui-review y rechaza Android. El workflow normal no crea ui-review.zip. La publicación admite ese archivo únicamente cuando existe.

ci/check_apk_privacy.py comprueba el APK exportado y rechaza pruebas/recursos de revisión empaquetados y permisos específicos de captura/grabación. Sus pruebas verifican rechazo de recursos y permisos en cadenas UTF-8/UTF-16. No se modifica la función del sistema Android con la que el usuario decide tomar su propia captura.

Validación local: 310 comprobaciones Godot y tres pruebas Python de auditoría. El APK debe aprobar firma y auditoría en CI. Protocolo físico: instalar sobre Preview 13, retomar el combate atascado, pulsar Cerrar turno, completar combate y probar Libro. No reiniciar ni desinstalar para conservar el encuentro.
