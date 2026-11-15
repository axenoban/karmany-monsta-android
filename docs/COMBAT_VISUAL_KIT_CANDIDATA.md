# Kit visual de combate — candidata física

## Alcance autorizado

Solicitud: «Ok implementa el kit para una prueba física». Base `dev/karmany-core` b885e6ce7f3d09a99cdbabef4c39465164d81b8a, Preview104 validada. Versión 0.25.1-combat-kit. Rama feature/combat-visual-kit-physical. No integrar hasta aprobación del creador.

El kit denominado PvP se aplica al combate jugable existente para evaluar su calidad real. El baseline no ofrece PvP de red; esta candidata no lo añade. Tampoco añade estadísticas, acciones, recompensas ni cambios de balance. Protección conserva su acceso por Táctica. No incorpora PR24 ni PR32/Preview108.

## Implementación

- 40 SVG originales del paquete Karmany_PvP_Kit_v01 en assets/ui/combat_kit, sin texto rasterizado. Se conservan variantes reutilizables aunque no todas estén activas en esta pantalla.
- scripts/combat_kit_theme.gd adapta superficies de nueve segmentos, estados normal/pulsado/deshabilitado/seleccionado, foco e iconos a los controles existentes.
- scripts/trial_ui.gd aplica el Theme local al combate, añade retratos de la especie real y tarjetas de PS ligadas al encuentro. Conserva ProgressBar, acciones, navegación, escenas, animaciones y guardado existentes.
- scripts/combat_context_panel.gd utiliza el marco del kit en consultas. Los paneles conservan desplazamiento y cierre contextual.
- No reemplaza ilustraciones, sprites ni escenarios aprobados. El resto del juego mantiene el Theme baseline.

## Validación reproducible

Motor exacto Godot 4.7.2 stable ed1daf0bf, descarga comprobada contra SHA512 oficial. Importación sin errores.

`godot --path . --audio-driver Dummy --script tests/combat_kit_tests.gd -- --allow-ui-review`

159 verificaciones, 0 fallos: 1280×720, 960×540 y 1600×720 con texto normal/grande; sprites vinculados a especies reales, PS reales, botón que ejecuta la transacción vigente, bloqueo durante respuesta, consultas sin consumir acciones, Atrás, mapa sin Theme nuevo y aislamiento QA. Las comprobaciones de geometría usan coordenadas del viewport lógico, coherentes con el stretch del proyecto. Capturas en build/combat-kit-review.

Regresiones locales Godot 4.7.2: continuous_ux 27, combat_readout 37, exploration_energy 80, ui_integral_theme 28, r11 233, tactical 174, roster 22 y combat_animation 74; total 675, 0 fallos. Ejecutar cada una con `godot --headless --path . --script tests/NOMBRE_tests.gd`. Logs verificados con ci/check_log.py. CI ejecuta además la suite completa y exporta APK firmada de preview; resultado remoto pendiente al crear esta candidata.

## Prueba física pendiente

1. Instalar la APK candidata como actualización de la preview; conservar datos.
2. Entrar al Laboratorio QA y abrir un combate. Comprobar PS, nombres, retratos e ilustraciones correctos.
3. Probar Golpe, Insignia y Táctica → Protección; verificar respuesta rival, bloqueo temporal y actualización de PS.
4. Abrir Equipo, Entrenador y Estado y técnicas; deslizar contenido y usar Atrás físico. Consultar no debe consumir turno.
5. Repetir con texto grande; revisar que botones y paneles se pueden leer y tocar en horizontal.
6. Salir de QA, volver al mapa y reiniciar; comprobar conservación de partida normal.

Registrar modelo Android, versión, número de Preview, capturas y cualquier fallo. No se afirma rendimiento en teléfono ni aprobación visual hasta recibir esa prueba. La integración a dev/main queda pendiente.
