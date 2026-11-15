# Revisión profesional · controles candidatos

## Verificación local y bloqueo de entrega

Godot **4.7.2** instalado y verificado con SHA-512 oficial. Importación sin errores. Siete suites locales: tema 47, UI 119, foundation 40, R1.1 233, combat-readout 37, unificación 1849, primera sesión 609; **2934 checks, cero fallos**, logs revisados con ci/check_log.py. Tres pruebas Python y validación de cinco skills correctas.

No hay CI nueva ni APK nueva. El auto-review rechazó publicar el payload en el repositorio público incluso después de verificar GitHub (repo ID 1418670401, permisos push/admin). Se requiere autorización explícita del creador para publicar esta candidata en axenoban/karmany-monsta-android. No se intenta otro canal para evitar ese rechazo. Los commits están locales; dev/main intactos.

Capturas reales pendientes: entorno local sin display conectado; intento de render falló al inicializar X11/Wayland. No atribuir aprobación visual a los tests headless. La captura de familia queda implementada en tests/jade_ui_tests.gd para CI. Próximo responsable WORK: tras autorización explícita, push de feature/jade-visual-controls-review, PR borrador, CI completa, inspección de capturas y entrega de APK. No merge antes de aprobación visual/física.


## 14/11/2026 (Bolivia) · Candidata de controles desde Preview104

- Responsable escritor: WORK. Rama `feature/jade-visual-controls-review`, base real `b885e6ce7f3d09a99cdbabef4c39465164d81b8a`.
- Autorización vigente: revisión profesional, implementación visual en otra rama y APK para prueba física; aprobación visual obligatoria antes de integrar.
- Una familia: superficies de botones normal/hover/pulsado/deshabilitado/foco, principal y seleccionado. 11 texturas comparten geometría; no son 11 ilustraciones diferentes. Fuente reproducible `ci/generate_jade_controls.py`.
- Hallazgo: Preview104 hereda estados genéricos en principal/seleccionado y usa foco redondeado sobre contorno biselado. Candidata conserva identidad y esquinas nine-patch; facetas en márgenes, zona de lectura despejada. Paleta y tamaño del baseline conservados.
- Originales preservados; candidatos en `assets/ui/jade/controls_v2/`. No se copia ni integra PR24. Sin reglas, canon, guardados, nueva fase ni cambios a main/dev.
- Pruebas preliminares Godot local 4.6.3: importación limpia, tema 47 checks, UI 119 checks; Python 3 pruebas y 5 skills correctas. Validación exacta 4.7.2/CI y APK en curso, no acreditadas por estas pruebas preliminares.
- Evidencia prevista: captura Godot `controls-family-v2.png` y capturas menú/mapa/combate/equipo/Libro en `ui-review.zip` de la release candidata. Estado artístico: PROPUESTO; prueba física pendiente.
- Siguiente paso / WORK: verificar CI y APK del SHA candidato, presentar evidencia; esperar aprobación visual/física identificable antes de integrar.
- Instrucción: En axenoban/karmany-monsta-android, verificar HEAD de feature/jade-visual-controls-review, comparar contra dev b885e6c/Preview104, revisar CI y capturas, probar actualización y botones normal/pulsado/deshabilitado, texto grande, Atrás y reanudación. No integrar ni ampliar familias sin aprobación del creador.

### Evaluación del PR24

El SVG `jn-ctrl-01-normal.svg` (520×150) contiene ornamento y un cristal dentro del área de contenido. Escalarlo directamente a botones de 56 px o estirarlo como nine-patch requiere revisar márgenes: podría invadir texto/icono o deformarse. No es un defecto acreditado en APK, porque el kit no está integrado. Se conserva como propuesta independiente. Esta candidata deriva de la geometría del baseline (128×64, márgenes 14 px) con decoración fuera del texto.

### Trazabilidad

Fuentes: assets/ui/jade de Preview104 y tokens de adventure_theme.gd. Autoría de adaptación: proyecto Karmany Monsta, sin material externo. No se añade una licencia distinta de la política del repositorio. SVG editable = recurso consumido por Godot; PNG de revisión = render real, no textura de juego. Generador con estados y rutas explícitos. Componentes existentes Quiet/Nav/Danger e iconos preservados.

### Prueba física pendiente

1. Actualizar sobre la preview anterior sin borrar datos y verificar el SHA en Diagnóstico.
2. Abrir inicio, regiones, equipo y Libro: texto/iconos legibles y acciones visibles.
3. Observar principal, selección, pulsación y controles deshabilitados; un bloqueo no debe confundirse con selección.
4. Repetir con texto grande y durante combate; ninguna decoración debe cubrir cifras o etiquetas.
5. Volver al combate, salir y reabrir: progreso conservado y acciones sin duplicarse.

Criterio visual: aprobar esta familia o indicar pantalla, estado y captura con el cambio pedido. CI no equivale a aprobación artística ni prueba física.
