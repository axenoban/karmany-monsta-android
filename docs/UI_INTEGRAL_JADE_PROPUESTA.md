# UI integral Jade Nocturno · Bloque transversal propuesto

> **Candidata**. Rama `feature/ui-integral-jade-exploracion-combate` derivada de PR28/Preview89, no integrada ni aprobada físicamente. El PR29 de skills fue integrado por fast-forward a `dev/karmany-core` y las cinco skills se copiaron a esta rama candidata para poder trabajar con ellas. No se fusionaron PR23/24/27/28 a dev.

## Alcance implementado
El rediseño usa composición y recursos de la candidata Jade Nocturno (dirección artística propuesta 02 escogida), pero **no presume aprobación del kit integral del PR24**. Se mantiene gameplay, navegación, canon, progreso y persistencia exactamente como estaban. La intención es una interfaz visualmente unificada en todas las etapas existentes, no añadir etapas ni mecánicas.

### Cobertura funcional por flujo
| Flujo | Tratamiento |
| --- | --- |
| Inicio y menú | Títulos jerarquizados, línea de acento, CTA principal y navegación secundaria |
| Regiones Jade y Velo | Paneles reutilizables, CTA de selección / acceso, estado y progreso existentes |
| Doce lugares (6+6) | Reutilizan tema común: mapa, detalles, localización y búsqueda existente |
| Exploración | Cabecera contextual, estado del entrenador, navegación y entrada primaria |
| Combate | Cabecera persistente, acciones principales, táctica, equipo y PS con rol definido |
| Captura / Libro | Botones, tarjetas y cuadros de diálogo heredan tema; sin probabilidades alteradas |
| Resultados / XP | Acciones principales y secundarias, paneles de experiencia coherentes |
| Perfil / Árbol / Equipo / Colección | Títulos y tarjetas comunes, estados seleccionados donde existen |
| Bestiario | Filtros diferenciados por selección y tarjetas de especies |
| Prólogo / Ayuda / Transiciones | CTAs y controles secundarios legibles, conservan animaciones y timings |
| Ajustes / QA / Diagnóstico | Herencia de Theme global; sin modificar lógica de laboratorio ni guardados |

### Componentes reutilizables
- `adventure_theme.gd`: JadePrimary, JadeSelected, JadeQuiet, JadeNav, JadeDanger, JadeCard, JadeStatusPanel; variaciones de títulos y texto.
- `jade_ui.gd`: `heading`, `section`, `status`, `panel`, `row`, `art` y fondo.
- Integración semántica en las escenas dinámicas existentes, preservando acciones y señales originales.

### Contrato visual
- Respeto a identidad Jade Nocturno seleccionada. No sustituir la ilustración por un placeholder ni adoptar todo PR24 automáticamente.
- Primer plano legible sobre fondos detallados; texto auténtico de Godot, no incrustado en imagen.
- Accesibilidad: foco visible, contraste funcional, estados normal/pressed/disabled y texto grande.
- Acciones de abandono se distinguen de acciones primarias de avance.
- No cortar botones ni ocultar navegación a 1280×720 y 960×540; verificar con capturas de CI.
- Los doce puntos reutilizan el sistema de interfaz; la propuesta **no** genera doce fondos nuevos ni redibuja escenarios artísticos.

### Validación
1. `python3 ci/validate_skills.py`.
2. `godot --headless --editor --path . --import --quit`.
3. `godot --headless --path . --script tests/ui_integral_theme_tests.gd`.
4. `xvfb-run -a godot --rendering-method gl_compatibility --audio-driver Dummy --path . --script tests/jade_ui_tests.gd -- --allow-ui-review`.
5. Regresiones CI existentes: rutas, combate, captura, progreso, QA, guardados y APK.
6. Revisión humana de capturas en tamaños reales, elementos pulsables y acciones tras transición.
7. Prueba física antes de aprobar: los 12 lugares, combate táctico, Libro, selección de equipo, navegación contextual, texto grande y actualización APK.

**Criterio de integración:** primero validar rama madre PR28 y dependencias visuales pertinentes. Este PR debe permanecer como propuesta apilada hasta aprobación explícita; ni un CI verde ni una captura aislada son aprobación artística.
