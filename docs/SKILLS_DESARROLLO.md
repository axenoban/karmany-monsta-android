# Guía de uso de skills · Karmany Monsta Android

**Alcance:** infraestructura de instrucciones para desarrollo y diseño, no implementación jugable ni aprobación de diseño.

## Inventario
- `.agents/skills/godot-ui-ux/SKILL.md`: usabilidad, estructura de pantallas y navegación.
- `.agents/skills/game-visual-system/SKILL.md`: arte, identidad Jade Nocturno, revisión de componentes y estados.
- `.agents/skills/godot-ui-implementation/SKILL.md`: temas, controles y recursos UI nativos Godot.
- `.agents/skills/android-game-qa/SKILL.md`: Android, CI, APK y validación física.
- `.agents/skills/godot-gameplay/SKILL.md`: lógica y protección canónica.

## Activación práctica
**Codex:** abrir el repo en la rama donde figuran las skills y solicitar: «Usa `godot-ui-ux` y `game-visual-system` para auditar el menú actual, sin modificar gameplay». Codex descubre metadata del repositorio; si no, pedir lectura explícita de los archivos.

**ChatGPT Work:** conectar GitHub, indicar repo y rama, y solicitar lectura de `AGENTS.md`, estado vigente y la skill relevante. La presencia de `SKILL.md` en GitHub no garantiza que todo cliente Work la active automáticamente.

**Chat:** usar estos archivos como fuente de procedimiento si están accesibles por GitHub. No afirmar que quedaron instalados como plugins personales.

## Pipeline de calidad visual
1. Auditar un flujo real, no diseñar en abstracto.
2. Identificar familia visual y referencias aprobadas de la rama/PR.
3. Revisar variantes individuales a tamaño de uso (no solo mosaico masivo).
4. Implementar componentes reutilizables de Godot sobre una rama feature.
5. Comparar capturas del build real con la referencia.
6. Validar UI/tacto en Android, preservar guardados y regresar a revisión si hay defectos.
7. Con aprobación del creador, integrar con verificación de historia y regresiones.

## Precaución del estado Git (14/11/2026)
El `dev/karmany-core` verificado al crear estas skills estaba en `29be7ba3d30ea72e860f62ec4f0c8aa766e6d1b4` (R1.1 documental, 16/10). Existían PR abiertos, incluido PR23 de Jade Nocturno, PR24 del kit Cristal Vivo y PR28 de UX compacta. Son líneas posteriores **no integradas en dev**; sus contenidos y permisos de integración deben verificarse al usarlos. El kit íntegro de PR24 NO está automáticamente aprobado.

## Validación documental
Ejecutar `python ci/validate_skills.py`. La verificación solo revisa metadatos y presencia de las cinco skills; no sustituye pruebas Godot, CI ni APK. Este bloque no altera scripts jugables, escenas, `assets/`, `project.godot` ni `main`/`dev`.

**Siguiente trabajo recomendado:** usar `godot-ui-ux` y `game-visual-system` para auditar una pantalla real del candidato elegido, con referencia gráfica y captura a tamaño real; después `godot-ui-implementation` + `android-game-qa`.
