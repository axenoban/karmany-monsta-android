# Jade nocturno · candidata v0.25.0-jade

**Entrega verificable:** [Preview46 / v0.25.0-jade](https://github.com/axenoban/karmany-monsta-android/releases/tag/android-preview-46), [PR23](https://github.com/axenoban/karmany-monsta-android/pull/23), código `ca3fd8d95d913998415618d11d27b706a669fbfd`, [CI43597428376 correcta](https://github.com/axenoban/karmany-monsta-android/actions/runs/43597428376). APK83.431.938 bytes, SHA256 `40fdf39d1012bbb5440eb1218adb7eb2edf0dd5a7ef4a508dcda84667b481e33`. Descarga completa comprobada; firma con el mismo certificado anterior;11 JSON de juego idénticos. 5.972 comprobaciones/32 suites Godot y3 Python correctas. Capturas en ui-review.zip de la release. Prueba física pendiente, sin integración. Evidencia: docs/JADE_NOCTURNO_VERIFICACION.json. Los commits documentales posteriores no alteran esta APK.

## Aprobación y base

Axe eligió la opción1 «jade nocturno» y aprobó su extensión a Libro, Bestiario, perfil y ajustes, seguido de «Apruebo la extensión del estilo,pasa a la implementación». Dirección: misterio y fantasía con momentos luminosos; formas limpias, símbolos propios; información esencial en combate y detalle al tocar.

Base real: docs/documento-maestro-android@3a468deb03e1fd67a869d30f33c62cf3f7103433, descendiente de R1.1. Rama feature/jade-nocturno. PR propuesto contra la rama documental para aislar este diff; PR21 y PR22 no se integran implícitamente. Dev29be7ba/main9ef7af7 permanecen intactos.

## Alcance implementado

| Superficie | Cambio |
|---|---|
| Sistema compartido | Tinta verde, jade luminoso, acentos dorados e imagen de fondo continua; estados normal, foco, pulsado, seleccionado y deshabilitado |
| Botones y paneles | SVG originales con esquinas biseladas y borde doble, nueve segmentos; iconos propios de navegación/acciones |
| Inicio | Composición de criatura protagonista y tarjeta de acciones |
| Regiones | Tarjetas paralelas, arte actual y navegación inferior fija |
| Equipo | Miembro seleccionado, retrato, estadísticas reales y selección/colección fija |
| Colección | Galería y acciones existentes para incorporar individuos |
| Libro | Ilustración del Libro, nivel/reglas reales y mejoras desplegables |
| Bestiario | Galería, filtros y ficha dividida; siluetas y propiedad preservadas |
| Perfil | Ezel, progresión real y tarjetas compactas del equipo |
| Ajustes | Dos columnas, controles propios, preferencias persistidas por App |
| Exploración/combate | Tema común, acceso a equipo, criaturas protagonistas, PS visibles y Detalles directo |
| Laboratorio/árbol | Tema compartido, límites y navegación previa preservados |

No se añade personalización cosmética inexistente ni nuevos objetos, especies, reglas o estadísticas. Bestiario conserva21 entradas canónicas y Zephyr separado. Tampoco se reemplaza el arte actual por las ilustraciones conceptuales: los conceptos guían composición/paleta, no constituyen contenido canónico. Esta es una candidata de interfaz, no una certificación de publicación.

## Implementación

scripts/adventure_theme.gd centraliza colores, estilos y estados. assets/ui/jade contiene SVG originales escalables, sin texto incrustado. scripts/jade_ui.gd crea composiciones sin escritura de perfil. main.gd y trial_ui.gd reutilizan las acciones existentes. Los detalles de combate cierran primero Opciones para evitar dos ventanas exclusivas simultáneas; abrirlos no ejecuta un turno.

El Libro conserva sus nodos de mejora ocultos hasta desplegarlos. Equipo conserva restricciones de encuentro, mínimo de miembros y capacidad3. Los márgenes de laboratorio mantienen su límite de ancho. Se preservan App, motor, datos de juego, guardados y migraciones. Solo cambia build_info entre los JSON de datos.

## Validación reproducible

Motor exacto Godot4.7.2. Suite histórica completa:31 suites headless incluyendo Jade; Jade ampliada a89 comprobaciones tras ajustar navegación fija. R1.1 visual:34 comprobaciones. Total local: 5972 comprobaciones únicas en32 suites, cero fallos;3 pruebas Python satisfactorias. Los renders repiten comprobaciones y no se suman como casos nuevos.

Jade revisa9 pantallas en1280×720 y960×540, normal/texto grande, ausencia de escritura de perfil al verlas, ancho, accesibilidad de la navegación fija, Detalles y Atrás, persistencia de sonido y salida QA. Ejecuta callbacks automatizados; no sustituye gestos ni pruebas físicas. Capturas con banner QA usan perfiles aislados.

Comandos:
```sh
godot --headless --editor --path . --import --quit
godot --headless --path . --script tests/jade_ui_tests.gd
godot --headless --path . --script tests/r11_tests.gd
xvfb-run -a godot --rendering-method gl_compatibility --audio-driver Dummy --path . --script tests/r11_ui_tests.gd
python3 -m unittest discover -s tests -p 'test_*.py'
```

CI ejecuta todas las regresiones existentes, Jade con render, exportación Android y auditoría APK. build/ui-review.zip reúne capturas. Una CI verde no implica validación física ni integración. Verificar número/commit/checksum en la release producida por el PR; Preview45 es la candidata anterior.

## Prueba física pendiente

1. Instalar la candidata sobre la preview anterior, sin desinstalar. Confirmar partida, colección, equipo y progreso conservados. Verificar versión/commit en información de compilación.
2. Recorrer inicio, ambas regiones y sus6 puntos. Probar Volver y gesto Android, regreso contextual y navegación inferior.
3. Revisar Libro (Ver mejoras), Bestiario/filtros/ficha, perfil, equipo con1 y3 miembros y colección. Probar selección y restricciones durante encuentro.
4. Entrar a combate: revisar PS, Golpe, Protección, Insignia, entrenador, equipo y Detalles. Confirmar que abrir/cerrar detalles no consume turno ni pierde el encuentro. Probar opciones y Atrás.
5. Activar texto grande; repetir en horizontal. Verificar legibilidad, desplazamiento, botones completos, foco y ausencia de pulsaciones accidentales. Cambiar sonido/volumen/vibración/movimiento reducido; cerrar y reabrir.
6. Laboratorio: dos regiones, niveles1/15 y equipo1/3; regresar a partida normal sin contaminación. Revisar rendimiento y respuesta táctil en el teléfono real.

Resultado esperado: identidad jade coherente, controles utilizables y misma partida/reglas. Registrar pantalla, paso, dispositivo y captura de cualquier fallo. No atribuir aprobaciones anteriores a esta nueva interfaz.

## Continuación

Responsable WORK. Tras «prueba correcta» identificando la candidata, conciliar PR21/22 y el nuevo PR, revisar ascendencia y cerrar por avance seguro; nunca force push. No iniciar E6 ni expandir alcance canónico. Si falta aprobación física, mantener feature sin integración.
