# Prototipo UX continua · Combate y resultados

**Estado:** candidata funcional en rama feature, pendiente CI y prueba física.  
**Contrato de diseño:** `docs/PLAN_DIRECTOR_EXPERIENCIA_BORRADOR.md` en PR26, D-18, D-19 y D-20.  
**Base de código:** `feature/jade-interactive-location-prototype@f83914ae295aeabf656c6b288caf407c1b0fba40` (PR25, no integrado).  
**Rama:** `feature/ux-combate-resultados-continuos`, [PR27](https://github.com/axenoban/karmany-monsta-android/pull/27) (base visual PR23; dependiente PR25).  
**Restricción:** NO integrar en `dev/karmany-core` ni `main` sin CI y prueba física correcta. No merge ciego de PR24 (kit SVG paralelo).

## Alcance implementado

1. **Panel sobre combate**: `CombatContextPanel` muestra Entrenador, Equipo o Detalles sin navegación fuera de la batalla. Contenido del motor real; pestañas Detalles Activos/Equipo/Técnicas/Resonancias. Las ventanas de confirmación de cambio/abandono conservan su semántica. El selector de destinatario de Insignia usa el mismo patrón de panel.
2. **Navegación**: botón Atrás Android cierra primero la consulta abierta; no mueve el encuentro. Se añade fade de 0,18 s desde opacidad 0,62 a 1, únicamente para vistas reconstruidas y cuando `reduced_motion` está desactivado; el fondo principal conserva su instancia. No se crea un nuevo sistema de rutas.
3. **Victoria/XP integradas**: `AftermathScreen` muestra victoria, retratos, filas individuales de experiencia, subidas de nivel y recompensa de stamina real en un único momento. La página dedicada a «victoria» ya no exige pasar primero a otra pantalla de XP. El Libro mantiene su propio momento y las ramas elección/doble objetivo/duplicado/fallo/éxito.
4. **Persistencia**: los checkpoints `victory` y `experience` aún se guardan por separado usando `App.advance_aftermath`, secuencialmente desde «Continuar al Libro». Se conserva `App.trial_action`, recibo durable, `encounter.id`, `revision` y validadores.
5. **Pruebas**: `continuous_ux_tests.gd` valida consulta, Atrás, unicidad de panel y resultado integrado; `combat_readout_tests.gd` y `first_session_tests.gd` actualizan expectativas de navegación sin reducir pruebas de validez funcional. CI de Android ejecuta la suite nueva antes de exportar.

## Alcance **no** implementado en este bloque

- Ayuda global solo en menú principal y Opciones (D-16): corresponde a otro bloque, todavía existe E5 contextual en algunas superficies.
- Redibujo de sprites y nuevo pipeline de animación (D-09/D-10): falta comparar prototipos y aprobar técnica antes de reemplazar arte.
- Shell de mapa/exploración completamente persistente, reorganización de ficha de localización y otras mejoras extensas de navegación.
- IA, balance, stamina, rutas secundarias, variación de encuentros, guion/canon y reglas de captura: **intactos**.
- Kit de PR24: sigue propuesto, sin aprobación de producción.

## Revisión local recomendada — creador, APK candidata tras CI

1. Instalar la **APK de la ejecución CI específica de PR27** tras verificar su commit y SHA256. No confundir con Preview53/PR25. Abrir una partida de prueba o QA aislado.
2. Entrar a combate, abrir **Detalles**, recorrer cuatro pestañas y cerrar con Atrás Android. La misma batalla y el mismo turno siguen visibles. Repetir con **Entrenador** y **Equipo**, alternando paneles; no se deben apilar ventanas.
3. Cambiar voluntariamente una criatura y cancelar en otra prueba: solo la confirmación debe ejecutar acción y respuesta rival. Abrir sin actuar jamás consume un turno.
4. Activar una Insignia que requiera destinatario si el equipo actual la ofrece: elegir destinatario o cerrar sin gastar acción.
5. Ganar un combate regional: confirmar **una vista única de victoria y XP** (con cifras reales) y **Continuar al Libro**. Probar uno/dos fallos, captura, renuncia y un caso de especie repetida. No debe haber doble XP ni cuarto intento.
6. Comprobar **Atrás**, cambiar a otra app y regresar, texto grande y movimiento reducido. Medir si el recorrido tiene menos cortes; reportar si un panel tapa demasiado la escena.
7. En el laboratorio QA (aislado) probar una final de dos rivales, con elección de un solo objetivo, y cerrar la aplicación en resultado/Libro. Reabrir sin nuevo premio ni nueva tirada.

## Regresiones y dependencias

- Verificar `tests/continuous_ux_tests.gd`, `tests/combat_readout_tests.gd`, `tests/first_session_tests.gd` y la suite completa de `.github/workflows/android-preview.yml`.
- No modificar datos de `data/`, `scripts/app.gd`, `scripts/tactical_encounter.gd`, `scripts/save_store.gd` o `scripts/aftermath_flow.gd`.
- La CI del PR es una candidata automatizada, no aprobación artística o de hardware.
- Mantener PR27 en **draft** hasta «prueba correcta» de la APK identificada y resolver dependencias PR21–25, sin tocar `main`.

**Responsable:** Chat — código y pruebas; creador — validación física.  
**Siguiente paso:** CI y prueba en Android, corregir primer error si aparece; después abordar el bloque D-16 ayuda voluntaria y comparación artística D-10 por separado.
